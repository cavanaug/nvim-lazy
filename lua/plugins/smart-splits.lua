--- Add the following to your tmux.conf to enable vim-tmux-navigator as a companion
---     set -g @plugin 'christoomey/vim-tmux-navigator' # Tmux Neovim navigation integration
return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      { "<C-Up>", false },
      { "<C-Down>", false },
      { "<C-Left>", false },
      { "<C-Right>", false },
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move cursor left (*)",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move cursor right (*)",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move cursor down (*)",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move cursor up (*)",
      },
      {
        "<A-h>",
        function()
          require("smart-splits").resize_left()
        end,
        mode = { "n", "v", "t" },
        desc = "Resize split left (*)",
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
        mode = { "n", "v", "t" },
        desc = "Resize split down (*)",
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
        mode = { "n", "v", "t" },
        desc = "Resize split up (*)",
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
        mode = { "n", "v", "t" },
        desc = "Resize split right (*)",
      },
      {
        "<leader><leader>h",
        function()
          require("smart-splits").swap_buf_left()
        end,
        desc = "Swap left (*)",
      },
      {
        "<leader><leader>j",
        function()
          require("smart-splits").swap_buf_down()
        end,
        desc = "Swap below (*)",
      },
      {
        "<leader><leader>k",
        function()
          require("smart-splits").swap_buf_up()
        end,
        desc = "Swap above (*)",
      },
      {
        "<leader><leader>l",
        function()
          require("smart-splits").swap_buf_right()
        end,
        desc = "Swap right (*)",
      },
    },
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
  },
}
