return {
  {
    -- diffview.nvim: Single-tab diff viewer for Git diffs and merge conflicts.
    -- Uses a personal fork (cavanaug/diffview.nvim) of sindrets/diffview.nvim.
    --
    -- Merge tool defaults to "diff3_mixed" layout (3-way: LOCAL | REMOTE over BASE | MERGED).
    -- Untracked files are excluded from :DiffviewOpen by default.
    --
    -- Custom keymaps (active only in diff buffers):
    --   <C-n>       - Jump to next change (remaps ]c)
    --   <C-p>       - Jump to previous change (remaps [c)
    --   <leader>c3  - Switch current merge entry to diff3_mixed layout (LOCAL | REMOTE / MERGED)
    --   <leader>c4  - Switch current merge entry to diff4_mixed layout (LOCAL | BASE | REMOTE / MERGED)
    --
    -- Keymaps are applied via BufEnter/WinEnter autocmds and only activate when
    -- the window is in diff mode (vim.wo.diff) or using diff foldmethod.
    "cavanaug/diffview.nvim",
    config = function()
      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
        default_args = {
          DiffviewOpen = { "--untracked-files=false" },
        },
      })

      -- Set up diffview keymaps that work in any diff context.
      -- Only binds when the current window is actually showing a diff,
      -- preventing interference with normal buffer navigation.
      local function setup_diff_keymaps()
        if vim.wo.diff or vim.o.foldmethod == "diff" then
          vim.keymap.set("n", "<C-n>", "]c", { buffer = true, desc = "Next change" })
          vim.keymap.set("n", "<C-p>", "[c", { buffer = true, desc = "Previous change" })

          -- Switch to diff3_mixed: 3-way merge layout showing LOCAL | REMOTE on top,
          -- MERGED on bottom. Useful for simpler conflicts where BASE isn't needed.
          vim.keymap.set("n", "<leader>c3", function()
            local lib = require("diffview.lib")
            local Diff3Mixed = require("diffview.scene.layouts.diff_3_mixed").Diff3Mixed
            local view = lib.get_current_view()

            if view and view.cur_entry then
              view.cur_entry:convert_layout(Diff3Mixed)
              view:set_file(view.cur_entry, false)
            end
          end, { buffer = true, desc = "Switch to diff3_mixed layout" })

          -- Switch to diff4_mixed: 4-way merge layout showing LOCAL | BASE | REMOTE on top,
          -- MERGED on bottom. Provides the most context for complex conflicts.
          vim.keymap.set("n", "<leader>c4", function()
            local lib = require("diffview.lib")
            local Diff4Mixed = require("diffview.scene.layouts.diff_4_mixed").Diff4Mixed
            local view = lib.get_current_view()

            if view and view.cur_entry then
              view.cur_entry:convert_layout(Diff4Mixed)
              view:set_file(view.cur_entry, false)
            end
          end, { buffer = true, desc = "Switch to diff4_mixed layout" })
        end
      end

      -- Apply keymaps when entering buffers via autocmd so they activate dynamically
      -- whenever a diff view is opened, including when switching between entries.
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        callback = setup_diff_keymaps,
      })
    end,
  },
  {
    -- difi.nvim: GitHub-style inline diff overlay for Neovim (official companion for the difi CLI).
    -- Shows additions (+) and deletions (-) directly in the buffer with color highlighting,
    -- avoiding cramped split views. Diffs are interactive: accept/reject changes by editing
    -- the buffer text, then toggle off to finalize.
    --
    -- Requires the `difi` CLI tool (pixel-perfect terminal diff viewer):
    --   https://github.com/oug-t/difi
    --
    -- Usage:
    --   :Difi          - Toggle diff against HEAD
    --   :Difi main     - Toggle diff against the main branch
    --   :Difi HEAD~1   - Compare against the previous commit
    --
    -- CLI workflow (recommended): Run `difi` in terminal, navigate to a file,
    -- press `e` to open in Neovim with the diff overlay already active.
    "oug-t/difi.nvim",
    enabled = false,
    event = "VeryLazy",
    build = "command -v difi >/dev/null 2>&1 || brew install difi",
    keys = {
      -- Context-aware: Syncs with CLI target (e.g. main) or defaults to HEAD
      { "<leader>df", ":Difi<CR>", desc = "Toggle Difi" },
    },
  },
}
