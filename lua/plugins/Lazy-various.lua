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
  },
  {
    "fei6409/log-highlight.nvim",
    opts = {},
  },
  -- {
  --   -- Prettier indent markers
  --   "lukas-reineke/indent-blankline.nvim",
  --   enabled = false, -- Enable this plugin by default
  --   opts = function(_, opts)
  --     opts.indent = { char = "┆" }
  --     -- opts.indent = { char = "" }
  --     -- opts.indent = { char = "╎" }
  --     -- opts.indent = { char = "┃" }
  --   end,
  -- },
}
