return {
  {
    -- Local checkout while iterating (no push / :Lazy update needed).
    -- Switch back to "cavanaug/crit-terminal.nvim" when you want the GitHub install.
    dir = "/home/cavanaug/wip_other/projects/crit-terminal.nvim",
    name = "crit-terminal.nvim",
    main = "crit",
    dependencies = { "folke/snacks.nvim" },
    opts = {},
    keys = {
      { "<leader>r", desc = "Crit Review" },
      { "<leader>rc", desc = "Crit Comment", mode = { "n", "v" } },
      { "<leader>re", desc = "Crit Edit Comment" },
      { "<leader>rx", desc = "Crit Delete Comment" },
      { "<leader>rr", desc = "Crit Refresh" },
      { "<leader>rf", desc = "Crit Finish" },
      { "<leader>rd", desc = "Crit Toggle Diff" },
    },
  },
}
