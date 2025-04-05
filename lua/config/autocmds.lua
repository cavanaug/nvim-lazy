-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

---------------------------------------------------------------
-- User filetype settings
---------------------------------------------------------------
vim.api.nvim_create_augroup("user_filetype_settings", { clear = true })

---------------------------------------------------------------
-- Set filetypes for specific files
---------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = ".envrc",
  command = "setfiletype sh",
  group = "user_filetype_settings",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.shrc",
  command = "setfiletype bash",
  group = "user_filetype_settings",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.avsc",
  command = "setfiletype json",
  group = "user_filetype_settings",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.rss", "*.atom" },
  command = "setfiletype xml",
  group = "user_filetype_settings",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.json",
  command = "setfiletype jsonc",
  group = "user_filetype_settings",
})

---------------------------------------------------------------
-- Set spell for certain filetypes
---------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  command = "setlocal spell",
  group = "user_filetype_settings",
})

---------------------------------------------------------------
-- Automatically source tmux.conf after writing it
---------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "tmux.conf",
  command = ":!tmux source-file %",
  group = "user_filetype_settings",
})

---------------------------------------------------------------
-- Automatically Adjust help window split
---------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    if vim.fn.winwidth(0) > 4.5 * vim.fn.winheight(0) then
      vim.cmd("wincmd L")
    else
      vim.cmd("wincmd K")
    end
  end,
  group = "user_filetype_settings",
})

---------------------------------------------------------------
-- Attempt to fix concealment for HTML comments in Markdown
---------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Turn off concealment level for HTML comments
    vim.treesitter.query.set("markdown", "html", [[ (comment) @comment ]])

    -- Optionally, change color to ensure visibility
    vim.api.nvim_set_hl(0, "@comment.html", { fg = "#888888", bold = true })
  end,
})
