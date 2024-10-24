if true then
  return {}
end
--- Im not sure any of this is really working on windows with wsl & tmux.  I will keep it here for now.
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

if vim.env.WAYLAND_DISPLAY and vim.fn.executable("wl-copy") and vim.fn.executable("wl-paste") then
  vim.g.clipboard = {
    name = "wl-copy",
    copy = {
      ["+"] = { "wl-copy", "--type", "text/plain" },
      ["*"] = { "wl-copy", "--primary", "--type", "text/plain" },
    },
    paste = {
      ["+"] = { "wl-paste", "--no-newline" },
      ["*"] = { "wl-paste", "--no-newline", "--primary" },
    },
    cache_enabled = 0,
  }
end

-- if vim.fn.has "wsl" == 1 and vim.fn.executable "wsl-copy" and vim.fn.executable "wsl-paste" then
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "wsl-copy",
    copy = {
      ["+"] = { "wsl-copy" },
      ["*"] = { "wsl-copy", "--primary" },
    },
    paste = {
      ["+"] = { "wsl-paste", "--no-newline" },
      ["*"] = { "wsl-paste", "--no-newline", "--primary" },
    },
    cache_enabled = 0,
  }
end

return {}
