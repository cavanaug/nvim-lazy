return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      -- Prefer OpenCode by making it easy to access
      tools = {
        opencode = {
          cmd = { "opencode" },
          -- HACK: https://github.com/sst/opencode/issues/445
          env = { OPENCODE_THEME = "system" },
        },
      },
    },
  },
  keys = {
    -- Override <leader>aa to default to OpenCode
    {
      "<leader>aa",
      function()
        -- Try to toggle existing OpenCode session, or create new one
        require("sidekick.cli").toggle({ name = "opencode", focus = true })
      end,
      desc = "Sidekick Toggle OpenCode",
    },
    -- Keep the original select functionality on a different key
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      desc = "Select CLI Tool",
    },
    -- Quick access to OpenCode specifically
    {
      "<leader>ao",
      function()
        require("sidekick.cli").toggle({ name = "opencode", focus = true })
      end,
      desc = "Sidekick Toggle OpenCode",
    },
  },
}
