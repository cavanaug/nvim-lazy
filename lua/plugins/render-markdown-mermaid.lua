return {
  {
    "cavanaug/render-markdown-mermaid.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    build = ":TSUpdate markdown markdown_inline",
    opts = {
      mode = "unicode",
      placement = "above",
      replace = true, -- visually replace the fence in normal mode when not editing that block
      render_markdown = {
        latex = { enabled = false },
      },
    },
  },
}
