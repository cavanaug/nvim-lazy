return {
  --------------------------------------------------------------------------------------
  { --- Markdown syntax highlighting
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
      -- configuration here or empty for defaults
    },
  },
  --------------------------------------------------------------------------------------
  { --- Markdown inline view
    "MeanderingProgrammer/render-markdown.nvim",

    opts = {
      -- render_modes = { "n", "c" },
      render_modes = true,
      code = {
        sign = true,
        width = "block",
        right_pad = 1,
      },
      heading = {
        enabled = true,
        sign = false,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
  --------------------------------------------------------------------------------------
  { --- Markdown preview
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  --------------------------------------------------------------------------------------
  { --- Vim pencil support
    "preservim/vim-pencil",
    enabled = false,
  },
  --------------------------------------------------------------------------------------
  { --- Zen mode
    "folke/zen-mode.nvim",
    enabled = false,
  },
  --------------------------------------------------------------------------------------
  { --- Spell check as warnings
    "ravibrock/spellwarn.nvim",
    enabled = false,
    event = "VeryLazy",
    config = true,
    opts = {
      event = { -- event(s) to refresh diagnostics on
        "CursorHold",
        "InsertLeave",
        "TextChanged",
        "TextChangedI",
        "TextChangedP",
        "TextChangedT",
        "FileAppendCmd", -- To detect a zg add to spellfile
      },
    },
  },
  --------------------------------------------------------------------------------------
  { --- Classic bullets
    "bullets-vim/bullets.vim",
    eanabled = false,
  },
}
