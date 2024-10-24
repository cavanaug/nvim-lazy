return {
  {
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
}
