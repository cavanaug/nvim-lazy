return {
  { "AndrewRadev/bufferize.vim" }, -- Most items in lazyvim already do this, but still nice to have
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        mappings = {
          -- i for insert, other modes are the first letter too
          i = {
            -- map kj to exit insert mode
            k = { j = "<Esc>" },
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
