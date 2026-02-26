return {
  "neovim/nvim-lspconfig",
  init = function()
    -- Suppress harmless LSP shutdown errors from taplo
    -- This needs to run early (in init) before LSP clients start
    local orig_notify = vim.notify
    vim.notify = function(msg, level, opts)
      -- Filter out taplo shutdown errors
      if type(msg) == "string" then
        if
          msg:match("LSP%[taplo%]:.*server is shutting down") or msg:match("LSP%[taplo%]:.*NO_RESULT_CALLBACK_FOUND")
        then
          return
        end
      end
      return orig_notify(msg, level, opts)
    end
  end,
}
