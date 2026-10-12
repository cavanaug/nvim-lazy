--- ----------------------------------------------------------------------------------------
--- Herdr navigation uses the wrapper below with the vim-herdr-navigation Herdr plugin.
--- Herdr pane resizing uses its native resize mode; Alt+h/j/k/l resize Neovim windows only.
--- No smart-splits backend is needed for this workflow.
--- Tmux/Zellij integration in smart-splits v3 requires a separate backend plugin and opts.mux.backend.
--- ----------------------------------------------------------------------------------------

--- mini.move is installed via lazy extras, config for visual mode only, disable the normal mode
--- smart-splits is the active mappings when not in visual mode
local function in_herdr()
  return vim.env.HERDR_PANE_ID ~= nil and vim.env.HERDR_PANE_ID ~= ""
end

local function move_with_context(wincmd, dir, fallback)
  return function()
    if not in_herdr() then
      fallback()
      return
    end

    local prev = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. wincmd)
    if vim.api.nvim_get_current_win() ~= prev then
      return
    end

    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--current" })
  end
end

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
    "smart-splits-nvim/smart-splits.nvim",
    lazy = false,
    keys = {
      { "<C-Up>", false },
      { "<C-Down>", false },
      { "<C-Left>", false },
      { "<C-Right>", false },
      {
        "<C-h>",
        move_with_context("h", "left", function()
          require("smart-splits").move_cursor_left()
        end),
        desc = "Move cursor left (*)",
      },
      {
        "<C-l>",
        move_with_context("l", "right", function()
          require("smart-splits").move_cursor_right()
        end),
        desc = "Move cursor right (*)",
      },
      {
        "<C-j>",
        move_with_context("j", "down", function()
          require("smart-splits").move_cursor_down()
        end),
        desc = "Move cursor down (*)",
      },
      {
        "<C-k>",
        move_with_context("k", "up", function()
          require("smart-splits").move_cursor_up()
        end),
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
      move = {
        same_row = true,
      },
    },
  },
}
