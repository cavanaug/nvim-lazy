return {
  {
    --- My custom diffview configuration
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

      -- Set up diffview keymaps that work in any diff context
      local function setup_diff_keymaps()
        if vim.wo.diff or vim.o.foldmethod == "diff" then
          vim.keymap.set("n", "<C-n>", "]c", { buffer = true, desc = "Next change" })
          vim.keymap.set("n", "<C-p>", "[c", { buffer = true, desc = "Previous change" })
          vim.keymap.set("n", "<leader>c3", function()
            local lib = require("diffview.lib")
            local Diff3Mixed = require("diffview.scene.layouts.diff_3_mixed").Diff3Mixed
            local view = lib.get_current_view()

            if view and view.cur_entry then
              view.cur_entry:convert_layout(Diff3Mixed)
              view:set_file(view.cur_entry, false)
            end
          end, { buffer = true, desc = "Switch to diff3_mixed layout" })
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

      -- Apply keymaps when entering buffers
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        callback = setup_diff_keymaps,
      })
    end,
  },
  {
    -- Under evaluation diff viewer that integrates with Difi for a more interactive experience
    -- brew install difi
    "oug-t/difi.nvim",
    event = "VeryLazy",
    keys = {
      -- Context-aware: Syncs with CLI target (e.g. main) or defaults to HEAD
      { "<leader>df", ":Difi<CR>", desc = "Toggle Difi" },
    },
  },
}
