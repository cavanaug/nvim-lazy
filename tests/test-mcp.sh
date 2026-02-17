#!/bin/bash
# Regression test: nvim-mcp server is properly configured and functional

set -euo pipefail

echo "Testing: MCP server setup"

FAIL=0

# Test 1: nvim-mcp binary is installed and on PATH
if command -v nvim-mcp > /dev/null 2>&1; then
    echo "  ✓ nvim-mcp binary found: $(command -v nvim-mcp)"
else
    echo "  ✗ nvim-mcp binary not found on PATH"
    FAIL=1
fi

# Test 2: opencode.json is valid JSON and has MCP server defined
OPENCODE_JSON="$HOME/.config/nvim/opencode.json"
if [ -f "$OPENCODE_JSON" ]; then
    if jq empty "$OPENCODE_JSON" 2> /dev/null; then
        # Check that the nvim MCP server is defined and enabled
        MCP_ENABLED=$(jq -r '.mcp.nvim.enabled // false' "$OPENCODE_JSON" 2> /dev/null)
        MCP_CMD=$(jq -r '.mcp.nvim.command[0] // ""' "$OPENCODE_JSON" 2> /dev/null)
        if [ "$MCP_ENABLED" = "true" ] && [ "$MCP_CMD" = "nvim-mcp" ]; then
            echo "  ✓ opencode.json MCP server configured (enabled=true, cmd=nvim-mcp)"
        else
            echo "  ✗ opencode.json MCP server misconfigured (enabled=$MCP_ENABLED, cmd=$MCP_CMD)"
            FAIL=1
        fi
    else
        echo "  ✗ opencode.json is invalid JSON"
        FAIL=1
    fi
else
    echo "  ✗ opencode.json not found at $OPENCODE_JSON"
    FAIL=1
fi

# Test 3: nvim-mcp plugin is loaded by lazy.nvim
PLUGIN_INFO=$(nvim --headless -c 'lua
local plugins = require("lazy").plugins()
for _, p in ipairs(plugins) do
  if p.name == "nvim-mcp" then
    print("FOUND:" .. tostring(p._.loaded ~= nil))
    return
  end
end
print("NOTFOUND")
' -c 'quit' 2>&1 | grep -E "^(FOUND|NOTFOUND)" | tail -1)

if [ "$PLUGIN_INFO" = "FOUND:true" ]; then
    echo "  ✓ nvim-mcp plugin loaded by lazy.nvim"
elif [ "$PLUGIN_INFO" = "FOUND:false" ]; then
    echo "  ✗ nvim-mcp plugin registered but not loaded"
    FAIL=1
else
    echo "  ✗ nvim-mcp plugin not found in lazy.nvim"
    FAIL=1
fi

# Test 4: nvim-mcp creates RPC socket in a persistent session
# Start a short-lived headless Neovim to verify socket creation
TMUX_SESSION="nvim-mcp-test-$$"
tmux new-session -d -s "$TMUX_SESSION" -c "$HOME/.config/nvim" 'nvim --headless' 2> /dev/null

SOCKET_FOUND=0
for i in $(seq 1 20); do
    if ls /tmp/nvim-mcp.* > /dev/null 2>&1; then
        SOCKET_FOUND=1
        break
    fi
    sleep 0.5
done

if [ "$SOCKET_FOUND" -eq 1 ]; then
    SOCKET=$(ls /tmp/nvim-mcp.* 2> /dev/null | head -1)
    echo "  ✓ nvim-mcp RPC socket created: $SOCKET"
else
    echo "  ✗ nvim-mcp RPC socket not created within 10 seconds"
    FAIL=1
fi

# Clean up the test tmux session
tmux kill-session -t "$TMUX_SESSION" 2> /dev/null
sleep 1

# Summary
if [ "$FAIL" -eq 0 ]; then
    echo "✓ PASS: MCP server setup verified"
    exit 0
else
    echo "✗ FAIL: MCP server issues detected"
    exit 1
fi
