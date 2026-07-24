#!/usr/bin/env bash
# Regression: cross-host MRU merge keeps max timestamp and drops missing/noise paths.
set -euo pipefail

mkdir -p "${HOME}/.config/nvim/tmp"
TMP="$(mktemp -d "${HOME}/.config/nvim/tmp/test-mru-XXXXXX")"
trap 'rm -rf "${TMP}"' EXIT

mkdir -p "${TMP}/Sync/nvim" "${TMP}/shared" "${TMP}/only-a"
echo a >"${TMP}/shared/a.txt"
echo b >"${TMP}/shared/b.txt"
echo c >"${TMP}/only-a/c.txt"

cat >"${TMP}/Sync/nvim/mru.host-a" <<EOF
100	${TMP}/shared/a.txt
50	${TMP}/shared/b.txt
90	${TMP}/only-a/c.txt
999	/tmp/noise.txt
EOF

cat >"${TMP}/Sync/nvim/mru.host-b" <<EOF
80	${TMP}/shared/a.txt
200	${TMP}/shared/b.txt
EOF

python3 - "${TMP}" <<'PY'
import glob, os, sys, re

root = sys.argv[1]
best = {}
exclude = [
    re.compile(r"^/tmp/"),
    re.compile(r"^/dev/shm/"),
    re.compile(r"COMMIT_EDITMSG$"),
    re.compile(r"/\.cursor/"),
]
for path in glob.glob(os.path.join(root, "Sync/nvim/mru.*")):
    with open(path) as f:
        for line in f:
            line = line.rstrip("\n")
            if "\t" not in line:
                continue
            ts_s, p = line.split("\t", 1)
            ts = int(ts_s)
            if any(rx.search(p) for rx in exclude):
                continue
            if not os.path.isfile(p):
                continue
            if p not in best or ts > best[p]:
                best[p] = ts
ordered = sorted(best.items(), key=lambda kv: -kv[1])
out = os.path.join(root, "merged.txt")
with open(out, "w") as f:
    for p, ts in ordered:
        f.write(f"{ts}\t{p}\n")
PY

mapfile -t lines <"${TMP}/merged.txt"
[[ "${lines[0]}" == "200	${TMP}/shared/b.txt" ]] || { echo "FAIL line0: ${lines[0]}"; exit 1; }
[[ "${lines[1]}" == "100	${TMP}/shared/a.txt" ]] || { echo "FAIL line1: ${lines[1]}"; exit 1; }
[[ "${lines[2]}" == "90	${TMP}/only-a/c.txt" ]] || { echo "FAIL line2: ${lines[2]}"; exit 1; }
[[ "${#lines[@]}" -eq 3 ]] || { echo "FAIL count ${#lines[@]}"; exit 1; }

echo "OK test-mru-merge"
