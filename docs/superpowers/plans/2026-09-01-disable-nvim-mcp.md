# Disable nvim-mcp Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep the nvim-mcp configuration available for later use while disabling its Lazy.nvim plugin, OpenCode server launch, and active-only regression checks.

**Architecture:** Preserve the existing nvim-mcp declarations as dormant configuration by adding `enabled = false` at both integration points. Replace runtime prerequisite checks with static disabled-state assertions, and condense the repository guidance to document the intentional off state without changing unrelated agent integrations.

**Tech Stack:** Lua, JSON, Bash, Neovim headless mode, jq, StyLua.

## Global Constraints

- Keep the `linw1995/nvim-mcp` plugin declaration as a re-enable point.
- Keep the `opencode.json` `mcp.nvim` declaration as a re-enable point.
- Do not change the unrelated `opencode.nvim` entry, permissions, plugin lock data, or other integrations.
- Do not require an installed `nvim-mcp` binary, Cargo build, tmux session, or RPC socket while disabled.
- Follow the repository rule that Lua files use StyLua with `stylua.toml`.
- Do not create a git commit; repository guidance assigns version-control operations to the user.

---

### Task 1: Disable the two nvim-mcp entry points

**Files:**
- Modify: `lua/plugins/agents.lua:54-59`
- Modify: `opencode.json:19-25`

**Interfaces:**
- Consumes: Existing Lazy.nvim plugin and OpenCode MCP declarations.
- Produces: Dormant declarations with `enabled = false` and unchanged plugin/build/server identity.

- [ ] **Step 1: Disable the Lazy.nvim plugin declaration**

Add `enabled = false` to the `linw1995/nvim-mcp` table without changing its repository, build command, or options:

```lua
  {
    "linw1995/nvim-mcp",
    enabled = false,
    build = "cargo install --path .",
    opts = {},
  },
```

- [ ] **Step 2: Disable the OpenCode MCP server**

Change only the server's existing boolean value in `opencode.json`:

```json
        "nvim": {
            "type": "local",
            "command": ["nvim-mcp", "--connect", "auto"],
            "enabled": false
        }
```

- [ ] **Step 3: Format and validate the declarations**

Run:

```bash
stylua --config-path stylua.toml lua/plugins/agents.lua
stylua --check --config-path stylua.toml lua/plugins/agents.lua
jq empty opencode.json
```

Expected: StyLua exits successfully and `jq` accepts the JSON.

### Task 2: Convert the MCP regression test to disabled-state coverage

**Files:**
- Modify: `tests/test-mcp.sh`

**Interfaces:**
- Consumes: `opencode.json` and Lazy.nvim's plugin registry.
- Produces: A regression test that passes without `nvim-mcp`, tmux, or an RPC socket.

- [ ] **Step 1: Replace the binary prerequisite check**

Remove the `command -v nvim-mcp` check. The disabled-state test must not fail when the binary is absent.

- [ ] **Step 2: Assert the OpenCode server is disabled**

Keep JSON validation, then replace the enabled expectation with an explicit disabled expectation:

```bash
MCP_ENABLED=$(jq -r '.mcp.nvim.enabled // false' "$OPENCODE_JSON" 2> /dev/null)
MCP_CMD=$(jq -r '.mcp.nvim.command[0] // ""' "$OPENCODE_JSON" 2> /dev/null)
if [ "$MCP_ENABLED" = "false" ] && [ "$MCP_CMD" = "nvim-mcp" ]; then
    echo "  ✓ opencode.json MCP server disabled (cmd=nvim-mcp)"
else
    echo "  ✗ opencode.json MCP server should be disabled (enabled=$MCP_ENABLED, cmd=$MCP_CMD)"
    FAIL=1
fi
```

- [ ] **Step 3: Assert the Lazy plugin is registered but disabled**

Replace the current loaded-plugin probe with a headless Lua probe that prints whether the plugin is found and whether Lazy marks it disabled:

```bash
PLUGIN_INFO=$(nvim --headless -c 'lua
local plugins = require("lazy").plugins()
for _, p in ipairs(plugins) do
  if p.name == "nvim-mcp" then
    print("FOUND:" .. tostring(p.enabled == false) .. ":" .. tostring(p._.loaded == nil))
    return
  end
end
print("NOTFOUND")
' -c 'quit' 2>&1 | grep -E "^(FOUND|NOTFOUND)" | tail -1)

if [ "$PLUGIN_INFO" = "FOUND:true:true" ]; then
    echo "  ✓ nvim-mcp plugin registered but disabled and unloaded"
else
    echo "  ✗ nvim-mcp plugin should be registered, disabled, and unloaded: $PLUGIN_INFO"
    FAIL=1
fi
```

- [ ] **Step 4: Remove socket and tmux assertions**

Delete the block that starts a tmux session, waits for `/tmp/nvim-mcp.*`, and kills the session. The disabled configuration must not require runtime socket creation.

- [ ] **Step 5: Run the focused test**

Run:

```bash
bash tests/test-mcp.sh
```

Expected: PASS without requiring `nvim-mcp` on `PATH`.

### Task 3: Make repository guidance reflect the disabled state

**Files:**
- Modify: `AGENTS.md:365-368,722-1029`

**Interfaces:**
- Consumes: Existing nvim-mcp plugin/MCP configuration status.
- Produces: Accurate agent guidance that no longer directs agents to launch or connect to an active nvim-mcp server.

- [ ] **Step 1: Replace the active integration description**

Change the AI integrations list entry to state that nvim-mcp is retained but disabled and is not part of the normal testing workflow.

- [ ] **Step 2: Replace the live nvim-mcp workflow section**

Remove the active architecture, launch, connection, socket, and live-verification instructions that assume nvim-mcp is enabled. Replace them with a concise note that:

```markdown
#### nvim-mcp Status

The `linw1995/nvim-mcp` plugin and the matching OpenCode MCP server configuration are intentionally disabled. Normal Neovim startup and regression tests must not require the `nvim-mcp` binary, Cargo, tmux, or an RPC socket. To re-enable it, set both configuration entries to `enabled = true`, restore active MCP-specific tests and workflow documentation, and verify the build prerequisites.
```

- [ ] **Step 3: Preserve generic headless testing guidance**

Keep the general headless config, health-check, plugin, and regression-test instructions that do not require nvim-mcp. Remove only references whose purpose is to start, connect to, inspect, or validate the nvim-mcp server.

- [ ] **Step 4: Check documentation consistency**

Search for remaining references:

```bash
grep -n "nvim-mcp\\|nvim_mcp\\|nvim MCP" AGENTS.md lua/plugins/agents.lua opencode.json tests/test-mcp.sh
```

Expected: remaining references identify the disabled declarations, disabled-state test, or re-enable note; no instructions claim the server is active.

### Task 4: Run end-to-end verification

**Files:**
- Test: `lua/plugins/agents.lua`
- Test: `opencode.json`
- Test: `tests/test-mcp.sh`
- Test: `tests/run-all.sh`

**Interfaces:**
- Consumes: All changes from Tasks 1-3.
- Produces: Evidence that startup, focused tests, formatting, JSON parsing, and the complete regression suite work with nvim-mcp disabled.

- [ ] **Step 1: Verify Neovim starts and the plugin is not loaded**

Run:

```bash
nvim --headless -c 'lua
local found = false
local loaded = false
for _, p in ipairs(require("lazy").plugins()) do
  if p.name == "nvim-mcp" then
    found = true
    loaded = p._.loaded ~= nil
  end
end
assert(found, "nvim-mcp declaration is missing")
assert(not loaded, "disabled nvim-mcp plugin was loaded")
' -c 'quit'
```

Expected: exit status 0.

- [ ] **Step 2: Run the focused MCP regression test**

Run:

```bash
bash tests/test-mcp.sh
```

Expected: PASS without binary/socket checks.

- [ ] **Step 3: Run all regression tests**

Run:

```bash
bash tests/run-all.sh
```

Expected: all tests pass.

- [ ] **Step 4: Check the final diff**

Run:

```bash
git diff --check
git diff -- lua/plugins/agents.lua opencode.json tests/test-mcp.sh AGENTS.md docs/superpowers/specs/2026-09-01-disable-nvim-mcp-design.md docs/superpowers/plans/2026-09-01-disable-nvim-mcp.md
```

Expected: no whitespace errors, and only the approved dormant-state changes are present.
