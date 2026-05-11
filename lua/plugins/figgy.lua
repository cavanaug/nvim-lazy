return {
  {
    "cavanaug/figgy.nvim",
    lazy = false,
    opts = {
      -- Ordered list: first font that exists on this system is used as the default.
      -- Falls back to "banner" if none are found.
      default_fonts = { "ANSI Shadow", "Big", "Slant", "Banner3" },
      filter = "border",
      -- Filter presets cycled in the picker with <C-n>/<C-p>. Border variants only —
      -- ANSI color filters (gay, metal) produce escape codes that corrupt buffer text.
      filters = { "border", "" },
      -- Include user font collection; also auto-detected via $FIGLET_FONTDIR when set in shell
      font_dirs = { vim.fn.expand("~/.local/share/figlet") },
    },
  },
}
