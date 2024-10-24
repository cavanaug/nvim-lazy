--- Add the following to your tmux.conf to enable vim-tmux-navigator as a companion
---     set -g @plugin 'christoomey/vim-tmux-navigator' # Tmux Neovim navigation integration
return {
  "mrjones2014/smart-splits.nvim",
  -- enable = false,
  lazy = false,
  keys = {
    { "<C-Up>", false },
    { "<C-Down>", false },
    { "<C-Left>", false },
    { "<C-Right>", false },
    {
      "<A-h>",
      function()
        require("smart-splits").resize_left()
      end,
      desc = "Resize split left (*)",
    },
    {
      "<A-j>",
      function()
        require("smart-splits").resize_down()
      end,
      desc = "Resize split down (*)",
    },
    {
      "<A-k>",
      function()
        require("smart-splits").resize_up()
      end,
      desc = "Resize split up (*)",
    },
    {
      "<A-l>",
      function()
        require("smart-splits").resize_right()
      end,
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
}
