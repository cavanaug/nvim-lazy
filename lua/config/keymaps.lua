-- Keymaps are automatically loaded on the VeryLazy event
-- Add any additional keymaps here
local map = vim.keymap.set

-- --------------------------------------------------------------------------------------------------------------------
-- GLOBAL MAPPINGS
--     -- General maps only here
--     -- Things that are domain specific should put in the specific plugin area (ie. terminal/toggleterm)
-- --------------------------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------------------------
-- NORMAL MODE MAPPING
-- --------------------------------------------------------------------------------------------------------------------

-- map("n", "H", "<cmd>bprev<cr>", { noremap = true }) -- Not needed in LazyVim
-- map("n", "L", "<cmd>bnext<cr>", { noremap = true }) -- Not needed in LazyVim

map("n", "P", '"+p', { noremap = true }) -- Paste from windows clipboard
map("n", "Y", '"+y', { noremap = true }) -- Yank to windows clipboard

map("n", "<M-,>", "<cmd>ToggleTerm<cr>", { noremap = true }) -- Shortcut to toggle terminal (if using ToggleTerm)

-- map("n", "<C-Space>", "za", { desc = "Toggle fold under cursor (*)" })

-- An attempt at a way to use nvim docs as a sort of browser with simpler control navigation
-- map("n", "<C-Enter>", "", { desc = "Step into topic (*)" })
-- map("n", "<C-BS>", "", { desc = "Step out of topic (*)" })

----------------------------------------
--- Close current buffer
---    Previously "<leader>c" in astrovim
----------------------------------------
map("n", "<C-C>", function()
  local buffer_count = 0
  for _, bufinfo in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    buffer_count = buffer_count + 1
  end
  if buffer_count == 1 then
    vim.cmd("q")
  else
    vim.cmd("bd")
  end
end, { desc = "Close pane (*)" })

----------------------------------------
--- Toogle Window Split Orientation
----------------------------------------
map("n", "<C-e>", function()
  local win1 = vim.api.nvim_list_wins()[1]
  local win2 = vim.api.nvim_list_wins()[2]
  -- Ensure exactly two windows exist
  if not win1 or not win2 then
    print("There must be exactly two windows to toggle orientation.")
    return
  end
  -- Get window positions
  local win1_pos = vim.api.nvim_win_get_position(win1)
  local win2_pos = vim.api.nvim_win_get_position(win2)
  -- Determine if the windows are arranged horizontally or vertically
  local is_horizontal = win1_pos[1] == win2_pos[1] -- Same row means it's horizontal
  -- Toggle orientation using `wincmd H` (vertical) and `wincmd K` (horizontal)
  if is_horizontal then
    vim.cmd("wincmd K") -- Move the second window to be stacked (horizontal)
  else
    vim.cmd("wincmd H") -- Move the second window to be side-by-side (vertical)
  end
end, { desc = "Exchange window split orientation", noremap = true })

-- --------------------------------------------------------------------------------------------------------------------
-- VISUAL MODE MAPPING
-- --------------------------------------------------------------------------------------------------------------------
map("v", "<leader>)", "gsa)", { remap = true })
map("v", "<leader>}", "gsa}", { remap = true })
map("v", "<leader>]", "gsa]", { remap = true })
map("v", '<leader>"', 'gsa"', { remap = true })
map("v", "<leader>'", "gsa'", { remap = true })

if true then
  return {}
end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--                 n = {
--                     -- Improved
--                     --
--                     -- Git/Goto mappings
--                     ["gf"] = { "<cmd>wincmd F<cr>", desc = "Go to file:line under cursor (*)" },
--
--                     -- Support my old surround muscle memory
--                     -- ["<leader>s"] = { "gzaiw", desc = "Surround <nextchar>", remap = true },
--
--                     ["<C-Enter>"] = { "", desc = "Step into topic (*)" },
--                     ["<C-BS>"] = { "", desc = "Step out of topic (*)" },
--
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
