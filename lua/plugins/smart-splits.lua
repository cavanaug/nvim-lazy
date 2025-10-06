--- ----------------------------------------------------------------------------------------
--- TMUX
--- Add the following to your tmux.conf to enable vim-tmux-navigator as a companion
---     set -g @plugin 'christoomey/vim-tmux-navigator' # Tmux Neovim navigation integration
---
--- Zellij
--- Add to your config.kdl to enable zellij-navigator as a companion plugin
--- load_plugins {
---     "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm"
--- }
--- ----------------------------------------------------------------------------------------

--- mini.move is installed via lazy extras, config for visual mode only, disable the normal mode
--- smart-splits is the active mappings when not in visual mode
return {
  {
    "nvim-mini/mini.move",
    opts = {
      -- Disable normal mode mappings to avoid conflict with smart-splits
      mappings = {
        line_left = "",
        line_right = "",
        line_down = "",
        line_up = "",
      },
    },
  },
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
        mode = { "n", "t" },
        desc = "Resize split left (*)",
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
        mode = { "n", "t" },
        desc = "Resize split down (*)",
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
        mode = { "n", "t" },
        desc = "Resize split up (*)",
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
        mode = { "n", "t" },
        desc = "Resize split right (*)",
      },
      {
        "<leader>mh",
        function()
          require("smart-splits").swap_buf_left()
        end,
        desc = "Swap left (*)",
      },
      {
        "<leader>mj",
        function()
          require("smart-splits").swap_buf_down()
        end,
        desc = "Swap below (*)",
      },
      {
        "<leader>mk",
        function()
          require("smart-splits").swap_buf_up()
        end,
        desc = "Swap above (*)",
      },
      {
        "<leader>ml",
        function()
          require("smart-splits").swap_buf_right()
        end,
        desc = "Swap right (*)",
      },
      { "<leader>mK", "<C-w>K", desc = "Move Top (*)" },
      { "<leader>mJ", "<C-w>J", desc = "Move Bottom (*)" },
      { "<leader>mH", "<C-w>H", desc = "Move FarLeft (*)" },
      { "<leader>mL", "<C-w>L", desc = "Move FarRight (*)" },
      { "<leader>md", "<C-w><C-r>", desc = "Rotate Down/Right (*)" },
      { "<leader>mu", "<C-w>R", desc = "Rotate Up/Left (*)" },
    },
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
      zellij_move_focus_or_tab = false,
      move_cursor_same_row = true,
      disable_multiplexer_nav_when_zoomed = true,
    },
  },
}
