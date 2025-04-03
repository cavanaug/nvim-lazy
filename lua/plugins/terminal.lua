--- Terminal settings
--- @type LazyPluginSpec[]

-- Terminal Mapping
vim.keymap.set("t", "<C-Space>", "<C-\\><C-N>", { noremap = true, silent = true })

-- Terminal Plugins
return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            open_mapping = [[<m-,>]],
            -- open_mapping = [[<C-n>]],
        },
    },
}
