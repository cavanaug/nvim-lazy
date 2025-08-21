-- Clipboard configuration for Wayland using wl-copy and wl-paste
vim.g.clipboard = {
  name = "WaylandClipboard",
  copy = {
    ["+"] = "wl-copy", -- Copy to clipboard using wl-copy
    ["*"] = "wl-copy", -- Copy to primary selection using wl-copy
  },
  paste = {
    ["+"] = "win-paste --no-newline", -- Paste from clipboard using wl-paste
    ["*"] = "win-paste --no-newline", -- Paste from primary selection using wl-paste
  },
  cache_enabled = 0, -- Disable clipboard cache
}

return {
  {
    "gbprod/yanky.nvim", -- Yanky plugin URL
    config = function()
      -- Yanky.nvim setup
      require("yanky").setup({
        ring = {
          sync_with_numbered_registers = true, -- Sync with numbered registers (0-9)
          sync_with_clipboard = true, -- Sync with system clipboard (+ register)
          history_length = 100, -- Adjust history length
          storage = "shada", -- Store yank history in shada
          ignore_empty = true, -- Ignore empty yanks
        },
      })
    end,
  },
}
