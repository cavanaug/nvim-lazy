return {
  ---  THEMES   ---------------------------------------------------------------------------------------------------
  { "EdenEast/nightfox.nvim", lazy = false },
  { "Mofiqul/vscode.nvim", lazy = false },
  { "aktersnurra/no-clown-fiesta.nvim", lazy = false },
  { "ellisonleao/gruvbox.nvim", lazy = false },
  { "mikesmithgh/gruvsquirrel.nvim", lazy = false },
  { "nalexpear/spacegray.nvim", lazy = false },
  { "rebelot/kanagawa.nvim", lazy = false },
  { "rose-pine/neovim", lazy = false },
  { 
    "sainnhe/sonokai", 
    lazy = false,
    config = function()
      vim.g.sonokai_style = 'default'
      vim.g.sonokai_disable_italic_comment = 1
      
      -- Set diagnostic virtual text to italic
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "sonokai",
        callback = function()
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { italic = true, bold = true, fg = "#a8485c" })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { italic = true, bold = true, fg = "#a8485c" })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { italic = true, bold = true, fg = "#808080" })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { italic = true, bold = true, fg = "#808080" })
        end,
      })
    end,
  },
  { "sho-87/kanagawa-paper.nvim", lazy = false },
  { "projekt0n/github-nvim-theme", lazy = false, priority = 1000 },
  { "vague2k/vague.nvim", lazy = false },
  --  { "chama-chomo/grail", lazy = false },
  -- { "comfysage/aki", lazy = false },
  -- { "folke/tokyonight.nvim", lazy = false },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
  -- { "alexvzyl/nordic.nvim", lazy = false },
  -- { "antonk52/lake.nvim", lazy = false },
  -- { "behemothbucket/gruber-darker-theme.nvim", lazy = false },
  -- { "carcuis/darcula.nvim", lazy = false },
  -- { "delafthi/nord-nvim", lazy = false },
  -- { "deparr/tairiki.nvim", lazy = false },
  -- { "deviusvim/deviuspro.nvim", lazy = false },
  -- { "echasnovski/mini.hues", lazy = false },
  -- { "gbprod/nord.nvim", lazy = false },
  -- { "gmr458/cold.nvim", lazy = false },
  -- { "lewpoly/sherbet.nvim", lazy = false },
  -- { "lfenzo/fusion.nvim", lazy = false },
  -- { "lpuljic/nox-modus.nvim", lazy = false },
  -- { "navarasu/onedark.nvim", lazy = false },
  -- { "rmehri01/onenord.nvim", lazy = false },
  -- { "samir-roy/shinjuku.nvim", lazy = false },
  -- { "savq/melange-nvim", lazy = false },
  -- { "shaunsingh/nord.nvim", lazy = false },
  -- { "shawilly/ponokai", lazy = false },
  -- { "starryleo/starry-vim-colorschemes", lazy = false },
  -- { "steguiosaur/fullerene.nvim", lazy = false },
  -- { "wittyjudge/gruvbox-material.nvim", lazy = false },
  -- { "xiantang/darcula-dark.nvim", lazy = false },
  -- { "zortax/three-firewatch", lazy = false },

  ---  THEME PREVIEW  ---------------------------------------------------------------------------------------------
  --     I dont this actually works when themery is loaded
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "gruvbox",
      -- colorscheme = "vscode",
      -- colorscheme = "catppuccin",
      -- colorscheme = "github_dark_default",
      -- colorscheme = "slate",
      colorscheme = "sonokai",
    },
  },
  ---  THEME PREVIEW  ---------------------------------------------------------------------------------------------
  {
    "zaldih/themery.nvim",
    enabled = false, -- set to `true` to enable themery, this will override the colorscheme in LazyVim
    lazy = false,
    config = function()
      require("themery").setup({
        themes = vim.fn.getcompletion("", "color"),
      })
      require("themery").setThemeByName("kanagawa", true)
    end,
  },
}
