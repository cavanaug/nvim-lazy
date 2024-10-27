-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.del("n", "<C-'>")
vim.keymap.set("n", "<C-n>", "<cmd>Telescope colorscheme<CR>", { desc = "Change colorscheme (*)" })
vim.keymap.set("n", "<leader>c", "<cmd>close<cr>", { desc = "Close pane (*)" })
vim.keymap.set("n", "<C-Space>", "za", { desc = "Toggle fold under cursor (*)" })
-- note sure if this is useful
vim.keymap.set("n", "<C-Enter>", "", { desc = "Step into topic (*)" })
vim.keymap.set("n", "<C-BS>", "", { desc = "Step out of topic (*)" })

if true then
  return {}
end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--                 v = {
--                     --
--                     -- Clipboard Mappings
--                     --
--                     ["<leader>Y"] = { '"+y', desc = "Yank to system clipboard (*)" },
--                     ["<leader>P"] = { '"+p', desc = "Paste from system clipboard (*)" },
--                 },
--                 n = {
--                     -- Improved
--                     ["<Leader>C"] = { function() require("astrocore.buffer").close() end, desc = "Close buffer (*)" },
--                     ["<Leader>c"] = { "<cmd>close<cr>", desc = "Close pane (*)" },
--                     ["<C-C>"] = { function() require("astrocore.buffer").close(0, true) end, desc = "Close buffer (FORCE) (*)" },
--                     --
--                     -- Git/Goto mappings
--                     ["g"] = { name = "Go..." },
--                     ["gf"] = { "<cmd>wincmd F<cr>", desc = "Go to file:line under cursor (*)" },
--
--                     -- Support my old surround muscle memory
--                     -- ["<leader>s"] = { "gzaiw", desc = "Surround <nextchar>", remap = true },
--
--                     ["<C-Enter>"] = { "", desc = "Step into topic (*)" },
--                     ["<C-BS>"] = { "", desc = "Step out of topic (*)" },
--                     --
--                     --   Merge/Diff Mappings
--                     --
--                     -- Note: This is entirely predicated on a 3-way merge as I use for git/mercurial
--                     --       It assumes a model of  LOCAL | BASE | OTHER   on top with the MERGED on the bottom
--                     --       It also assumes that   LOCAL | BASE | OTHER   are RO, and that only MERGED IS RW
--                     --
--                     -- .gitconfig settings
--                     --     [merge]
--                     --     tool = nvimdiff
--                     --     #conflictstyle = diff3
--                     -- .hgrc settings
--                     --     [merge-tools]
--                     --     vimdiff.executable = nvimdiff
--                     --     vimdiff.args = -f -d $output -M $local $base $other -c "wincmd J" -c "set modifiable" -c "set write"
--                     --     vimdiff.premerge = keep
--
--                     ["<leader>m"] = { name = " Merge/Diff (*)" },
--                     ["<leader>mr"] = { "<cmd>diffget REMOTE<cr>", desc = "Merge <REMOTE> diff" },
--                     ["<leader>ml"] = { "<cmd>diffget LOCAL<cr>", desc = "Merge <LOCAL> diff" },
--                     ["<leader>mb"] = { "<cmd>diffget BASE<cr>", desc = "Merge <BASE>  diff" },
--                     ["<leader>mp"] = { "<cmd>diffput<cr>", desc = "Merge <this> diff" },
--                     ["<leader>mc"] = { "<cmd>wincmd j<cr>wqa<cr>", desc = "Merge complete..." },
--                     ["<leader>mq"] = { "<cmd>cq!<cr>", desc = "Merge quit/abandon..." },
--
--                     -- AI Mappings
--                     ["<leader>a"] = { name = "󰧑 AI/ChatGPT (*)" },
--                     ["<leader>aa"] = { "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
--                     ["<leader>ad"] = { "<cmd>ChatGPTRun docstring<CR>", desc = "GPT Docstring" },
--                     ["<leader>ae"] = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "GPT Edit with instruction" },
--                     ["<leader>af"] = { "<cmd>ChatGPTRun fix_bugs<CR>", desc = "GPT Fix Bugs" },
--                     ["<leader>ag"] = { "<cmd>ChatGPTRun grammar_correction<CR>", desc = "GPT Grammar Correction" },
--                     ["<leader>ak"] = { "<cmd>ChatGPTRun keywords<CR>", desc = "GPT Keywords" },
--                     ["<leader>al"] = {
--                         "<cmd>ChatGPTRun code_readability_analysis<CR>",
--                         desc = "GPT Code Readability Analysis",
--                     },
--                     ["<leader>ao"] = { "<cmd>ChatGPTRun optimize_code<CR>", desc = "GPT Optimize Code" },
--                     ["<leader>ar"] = { "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "GPT Roxygen Edit" },
--                     ["<leader>as"] = { "<cmd>ChatGPTRun summarize<CR>", desc = "GPT Summarize" },
--                     ["<leader>at"] = { "<cmd>ChatGPTRun translate<CR>", desc = "GPT Translate" },
--                     ["<leader>ax"] = { "<cmd>ChatGPTRun explain_code<CR>", desc = "GPT Explain Code" },
--                 },
--
--                 --
--                 -- Terminal Window Maps
--                 --
--                 --  JUST USE TMUX...
--                 t = {
--                     -- Reserved these for tmux, use <leader>jr for hydra resize
--                     -- ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Exit TERM mode" },
--                     -- ["<C-Space>"] = { "<C-><C-n>", desc = "Exit TERM mode" },
--                 },
--             },
--         },
--     },
-- }
