return {
  "folke/noice.nvim",
  opts = {
    views = {
      mini = {
        timeout = 9000, -- Change from 2000ms (2s)
      },
      cmdline_popup = {
        timeout = 9000, -- Change from 2000ms (2s)
      },
      notify = {
        timeout = 9000, -- Change from 2000ms (2s)
      },
    },
    -- Override the messages configuration to use a longer timeout
    messages = {
      view = "notify", -- ensure it uses notify view
    },
    routes = {
      {
        -- Disable this useless message
        filter = {
          event = "msg_show",
          find = "Authenticated as GitHub user:",
        },
        opts = { skip = true },
      },
    },
  },
}
