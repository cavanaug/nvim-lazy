return {
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    -- Only load when running in a terminal that supports image rendering
    cond = function()
      local term_program = (vim.env.TERM_PROGRAM or ""):lower()
      -- Terminals with kitty graphics protocol support
      if term_program == "kitty" then
        return true
      end
      if term_program == "wezterm" then
        return true
      end
      if term_program == "ghostty" then
        return true
      end
      -- Disable for unsupported terminals (SSH sessions, basic terminals, tmux without passthrough, etc.)
      return false
    end,
    opts = {
      processor = "magick_cli",
    },
  },
}
