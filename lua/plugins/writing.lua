--- TODO: Need to confirm spell checking support
return {
  { -- Markdown preview
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  { -- Obsidian notes support
    "epwalsh/obsidian.nvim",
    enabled = false, -- not using this yet
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { -- Vim pencil support
    "preservim/vim-pencil",
  },
  { -- Zen mode
    "folke/zen-mode.nvim",
  },
}
