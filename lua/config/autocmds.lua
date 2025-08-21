-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

---------------------------------------------------------------
--- Original vim.cmd autocmds for filetype settings
---    Im not sure lua is better here, look how dense & simple this is
---------------------------------------------------------------
-- vim.cmd([[
--       augroup user_filetype_settings
--       autocmd!
--       autocmd BufNewFile,BufRead .envrc setfiletype sh
--       autocmd BufNewFile,BufRead *.shrc setfiletype bash
--       autocmd BufNewFile,BufRead *.avsc setfiletype json
--       autocmd BufNewFile,BufRead *.rss *.atom setfiletype xml
--       autocmd BufNewFile,BufRead *.json setfiletype jsonc
--       autocmd FileType markdown,text,gitcommit setlocal spell
--       autocmd BufWritePost tmux.conf execute ':!tmux source-file %'
--       autocmd FileType help if winwidth("%")>4.5*winheight("%") | wincmd L | else | wincmd K | endif
--       augroup END
--       tnoremap <Esc><Esc> <C-\><C-n>
-- ]])
-- "autocmd bufwritepost tmux.conf execute ':!tmux-refresh all'
-- "autocmd FileType help if winwidth("%")>4.5*winheight("%") | echo "wincmd L" | else | echo "wincmd K" | endif
-- "autocmd FileType man if winwidth("%")>4.5*winheight("%") | wincmd L | else | wincmd K | endif
-- "autocmd FileType help if winnr('$') > 2 && winwidth("%")> 2.2*winheight("%")  | wincmd K | else | wincmd L | endif
-- "autocmd BufNewFile,BufRead *.json set filetype=jsonc

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

-----------------------------------------------------------------------------
-- Attempt to fix concealment for HTML comments in Markdown
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Turn off concealment level for HTML comments
    vim.treesitter.query.set("markdown", "html", [[ (comment) @comment ]])

    -- Optionally, change color to ensure visibility
    vim.api.nvim_set_hl(0, "@comment.html", { fg = "#888888", bold = true })
  end,
})

-----------------------------------------------------------------------------
-- Save/Restore fold markers views for markdown files
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.md",
  callback = function()
    vim.cmd("silent! loadview")
  end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*.md",
  callback = function()
    vim.cmd("silent! mkview")
  end,
})
-----------------------------------------------------------------------------
-- Per file specific customizations
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/_*_todo.md",
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt_local.showmode = true
    vim.opt.signcolumn = "no"
    vim.opt.laststatus = 0 -- There are some race conditions here with the lualine plugin, ensure that it is not loaded lazily
  end,
})
