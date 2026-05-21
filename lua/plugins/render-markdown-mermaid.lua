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
      render_markdown = {
        latex = { enabled = false },
      },
    },
  },
}
