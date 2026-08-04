#!/usr/bin/env bash
# Regression: nvim.mru merges hosts, filters noise, respects -n / --host.
set -euo pipefail

SCRIPT="${HOME}/bin/nvim.mru"
[[ -x "$SCRIPT" ]] || { echo "FAIL: missing $SCRIPT"; exit 1; }

mkdir -p "${HOME}/.config/nvim/tmp"
TMP="$(mktemp -d "${HOME}/.config/nvim/tmp/test-nvim-mru-XXXXXX")"
trap 'rm -rf "${TMP}"' EXIT

mkdir -p "${TMP}/Sync/nvim" "${TMP}/shared" "${TMP}/only-a" "${TMP}/many"
echo a >"${TMP}/shared/a.txt"
echo b >"${TMP}/shared/b.txt"
echo c >"${TMP}/only-a/c.txt"

export NVIM_MRU_DIR="${TMP}/Sync/nvim"

# 15 real paths so default head(10) differs from -a
{
  echo "200	${TMP}/shared/b.txt"
  echo "100	${TMP}/shared/a.txt"
  echo "90	${TMP}/only-a/c.txt"
  for i in $(seq 1 12); do
    echo "x$i" >"${TMP}/many/f$i.txt"
    echo "$((80 - i))	${TMP}/many/f$i.txt"
  done
  echo "999	/tmp/noise.txt"
} >"${TMP}/Sync/nvim/mru.host-a"

# host-b bumps b.txt timestamp (merge keeps max)
cat >"${TMP}/Sync/nvim/mru.host-b" <<EOF
80	${TMP}/shared/a.txt
200	${TMP}/shared/b.txt
EOF

mapfile -t lines < <("$SCRIPT")
[[ "${#lines[@]}" -eq 10 ]] || { echo "FAIL default count ${#lines[@]}"; exit 1; }
[[ "${lines[0]}" == "${TMP}/shared/b.txt" ]] || { echo "FAIL line0: ${lines[0]}"; exit 1; }

mapfile -t all_lines < <("$SCRIPT" -a)
[[ "${#all_lines[@]}" -eq 15 ]] || { echo "FAIL -a count ${#all_lines[@]}"; exit 1; }

mapfile -t limited < <("$SCRIPT" -n 2)
[[ "${#limited[@]}" -eq 2 ]] || { echo "FAIL -n 2 count"; exit 1; }
[[ "${limited[0]}" == "${TMP}/shared/b.txt" ]] || { echo "FAIL -n 2 first"; exit 1; }

mapfile -t one < <("$SCRIPT" -1)
[[ "${#one[@]}" -eq 1 && "${one[0]}" == "${TMP}/shared/b.txt" ]] || { echo "FAIL -1"; exit 1; }

mapfile -t verbose < <("$SCRIPT" -v -n 1)
expected_ts="$(date -d @200 '+%Y-%m-%d %H:%M:%S')"
[[ "${verbose[0]}" == "${expected_ts}	${TMP}/shared/b.txt" ]] || { echo "FAIL -v: ${verbose[0]}"; exit 1; }

# --host with fake hostname via only one file named for this host
host="$(hostname)"
cat >"${TMP}/Sync/nvim/mru.${host}" <<EOF
100	${TMP}/shared/a.txt
50	${TMP}/shared/b.txt
90	${TMP}/only-a/c.txt
999	/tmp/noise.txt
EOF
rm -f "${TMP}/Sync/nvim/mru.host-a" "${TMP}/Sync/nvim/mru.host-b"
mapfile -t host_only < <("$SCRIPT" --host -a)
[[ "${host_only[0]}" == "${TMP}/shared/a.txt" ]] || { echo "FAIL --host: ${host_only[0]}"; exit 1; }
[[ "${host_only[1]}" == "${TMP}/only-a/c.txt" ]] || { echo "FAIL --host[1]: ${host_only[1]}"; exit 1; }
[[ "${#host_only[@]}" -eq 3 ]] || { echo "FAIL --host count ${#host_only[@]}"; exit 1; }

echo "OK test-nvim-mru"
