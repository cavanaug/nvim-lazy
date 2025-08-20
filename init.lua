-- Check if PWD is Neovide's problematic directory and change to $HOME
local cwd = vim.fn.getcwd()
if cwd == "/mnt/c/Program Files/Neovide" then
  local home = vim.env.HOME or "~"
  vim.cmd("cd " .. home)
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
