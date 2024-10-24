return {
  "Mofiqul/vscode.nvim",
  {
    -- Prettier indent markers
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      opts.indent = { char = "┆" }
      -- opts.indent = { char = "" }
      -- opts.indent = { char = "╎" }
      -- opts.indent = { char = "┃" }
    end,
  },
  {
    -- Faster than esc for me
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        timeout = vim.o.timeoutlen,
        default_mappings = false,
        mappings = {
          i = { k = { j = "<Esc>" } },
          c = { k = { j = "<Esc>" } },
          -- t = { k = { j = "<Esc>", }, },
          -- v = { k = { j = "<Esc>", }, },
          s = { k = { j = "<Esc>" } },
        },
      })
    end,
  },
}
