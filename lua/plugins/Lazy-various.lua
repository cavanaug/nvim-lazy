--
-- Collection of various plugins that don't fit anywhere else and dont deserve their own file
--
return {
  { "AndrewRadev/bufferize.vim" }, -- Most items in lazyvim already do this, but still nice to have
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        mappings = {
          i = {
            k = { j = "<Esc>" }, -- map kj to exit insert mode
          },
        },
      })
    end,
  },
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    cmd = "Nerdy",
    opts = {
      max_recents = 30, -- Configure recent icons limit
      copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
      copy_register = "+", -- Register to use for copying (if `copy_to_clipboard` is true)
    },
    keys = {
      { "<leader>in", ":Nerdy list<CR>", desc = "Browse nerd icons" },
      { "<leader>iN", ":Nerdy recents<CR>", desc = "Browse recent nerd icons" },
    },
  },
  {
    "fei6409/log-highlight.nvim",
    opts = {},
  },
}
