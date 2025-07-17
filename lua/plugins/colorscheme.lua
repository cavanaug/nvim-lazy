return {
  ---  THEMES   ---------------------------------------------------------------------------------------------------
  { "EdenEast/nightfox.nvim", lazy = false },
  { "Mofiqul/vscode.nvim", lazy = false },
  { "aktersnurra/no-clown-fiesta.nvim" },
  { "ellisonleao/gruvbox.nvim", lazy = false },
  { "mikesmithgh/gruvsquirrel.nvim" },
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
  { "sho-87/kanagawa-paper.nvim" },
  { "projekt0n/github-nvim-theme", lazy = false, priority = 1000 },
  { "vague2k/vague.nvim", lazy = false },
  --  { "chama-chomo/grail" },
  -- { "comfysage/aki" },
  -- { "folke/tokyonight.nvim", lazy = false },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { "alexvzyl/nordic.nvim" },
  -- { "antonk52/lake.nvim" },
  -- { "behemothbucket/gruber-darker-theme.nvim" },
  -- { "carcuis/darcula.nvim" },
  -- { "delafthi/nord-nvim" },
  -- { "deparr/tairiki.nvim" },
  -- { "deviusvim/deviuspro.nvim" },
  -- { "echasnovski/mini.hues" },
  -- { "gbprod/nord.nvim" },
  -- { "gmr458/cold.nvim" },
  -- { "lewpoly/sherbet.nvim" },
  -- { "lfenzo/fusion.nvim" },
  -- { "lpuljic/nox-modus.nvim" },
  -- { "navarasu/onedark.nvim" },
  -- { "rmehri01/onenord.nvim" },
  -- { "samir-roy/shinjuku.nvim" },
  -- { "savq/melange-nvim" },
  -- { "shaunsingh/nord.nvim" },
  -- { "shawilly/ponokai" },
  -- { "starryleo/starry-vim-colorschemes" },
  -- { "steguiosaur/fullerene.nvim" },
  -- { "wittyjudge/gruvbox-material.nvim" },
  -- { "xiantang/darcula-dark.nvim" },
  -- { "zortax/three-firewatch" },

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
