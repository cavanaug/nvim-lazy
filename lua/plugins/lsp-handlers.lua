-- ============================================================================
-- TAPLO LSP SHUTDOWN ERROR WORKAROUND
-- ============================================================================
--
-- TODO: Remove this entire file when taplo releases a version > 0.10.0 that
--       includes the fix from PR #844 (merged Feb 10, 2026)
--
-- Background:
--   Taplo LSP server v0.10.0 has a bug where it sends error responses with
--   the wrong request ID during shutdown, causing NO_RESULT_CALLBACK_FOUND
--   errors to appear when closing Neovim with TOML files open.
--
-- Bug details:
--   - GitHub Issue: https://github.com/tamasfe/taplo/issues/845
--   - Fix PR: https://github.com/tamasfe/taplo/pull/844
--   - Fixed in: master branch (not yet released)
--   - Current version: 0.10.0 (released May 23, 2025)
--
-- To check if fix is available:
--   1. Run: taplo --version
--   2. If version > 0.10.0, check release notes for PR #844
--   3. If included, delete this file and test TOML editing
--   4. Verify no errors appear when doing: nvim config.toml -> :wq
--
-- ============================================================================

return {
  "neovim/nvim-lspconfig",
  opts = {
    -- This function runs after LSP clients are set up
    setup = {
      taplo = function(_, opts)
        -- Return false to use default setup, but we'll patch it after
        return false
      end,
    },
  },
  init = function()
    -- Hook into LspAttach to override write_error for taplo client
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "taplo" then
          -- Override the write_error method to suppress NO_RESULT_CALLBACK_FOUND
          local orig_write_error = client.write_error
          client.write_error = function(self, code, err)
            -- Suppress NO_RESULT_CALLBACK_FOUND errors (code 3)
            -- This prevents "server is shutting down" errors from appearing
            if code == 3 then
              return
            end
            return orig_write_error(self, code, err)
          end
        end
      end,
    })
  end,
}
