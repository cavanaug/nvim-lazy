-- Terminal Mapping
vim.keymap.set("t", "<C-Space>", "<C-\\><C-N>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-N>", { noremap = true, silent = true })

-- Terminal Plugins
return {
  {
    "akinsho/toggleterm.nvim",
    enabled = false,
    version = "*",
    opts = {
      open_mapping = [[<M-,>]],
      -- open_mapping = [[<C-n>]],
    },
  },
}
