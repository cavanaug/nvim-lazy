# Disable nvim-mcp Without Removing Its Configuration

## Goal

Stop nvim-mcp from being built, loaded, or launched by this Neovim/OpenCode setup while preserving its configuration for a later, explicit re-enable.

## Scope

- Disable the `linw1995/nvim-mcp` Lazy plugin in `lua/plugins/agents.lua`.
- Disable the `nvim` MCP server entry in `opencode.json`.
- Update `tests/test-mcp.sh` to verify that the integration is disabled and does not require an installed `nvim-mcp` binary or an RPC socket.
- Update `AGENTS.md` so its nvim-mcp documentation reflects the intentionally disabled state rather than describing it as an active workflow.
- Do not change the unrelated `opencode.nvim` plugin entry, permissions, plugin lock data, or other integrations.

## Design

The existing nvim-mcp plugin declaration remains in place with `enabled = false`. Lazy.nvim will therefore retain the declaration as a re-enable point but will not install, build, load, or execute it during normal startup.

The existing OpenCode MCP declaration remains in place with `enabled = false`. OpenCode will retain the server configuration without spawning `nvim-mcp`.

The MCP regression test will become a configuration regression test. It will validate that `opencode.json` is valid JSON, that `.mcp.nvim.enabled` is `false`, and that the Lazy plugin is present but disabled. It will not inspect the local binary or attempt to create a socket because those are no longer expected while the feature is disabled.

The nvim-mcp section in `AGENTS.md` will be reduced to a concise status note and re-enablement guidance. General Neovim headless testing guidance will remain intact, but instructions that assume an active nvim-mcp socket or live MCP connection will be removed.

## Verification

- Run StyLua on the modified Lua file and check its formatting.
- Validate `opencode.json` with `jq`.
- Run `nvim --headless -c 'quit'` and confirm the disabled plugin is not loaded.
- Run `tests/test-mcp.sh` and the full `tests/run-all.sh` regression suite.
- Confirm no nvim-mcp process or socket is required for the tests to pass.

## Future Re-enable

To re-enable the integration, set both `enabled` values back to `true`, restore the active MCP test assertions and workflow documentation, and ensure the `nvim-mcp` binary/build prerequisites are available.
