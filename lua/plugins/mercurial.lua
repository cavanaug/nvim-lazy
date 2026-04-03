return {
  {
    "cavanaug/hgsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      preview_config = {
        border = "single",
        row = 0,
        col = 1,
      },
      on_attach = function(buffer)
        local hs = package.loaded.hgsigns

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc, silent = true })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            hs.nav_hunk("next")
          end
        end, "Next Hunk (hg)")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            hs.nav_hunk("prev")
          end
        end, "Prev Hunk (hg)")
        map("n", "]H", function()
          hs.nav_hunk("last")
        end, "Last Hunk (hg)")
        map("n", "[H", function()
          hs.nav_hunk("first")
        end, "First Hunk (hg)")
        map("n", "<leader>ghp", hs.preview_hunk, "Preview Hunk (hg)")
        map("n", "<leader>ghb", function()
          hs.blame_line({ full = true })
        end, "Blame Line (hg)")
        map("n", "<leader>ghB", hs.blame, "Blame Buffer (hg)")
        map("n", "<leader>ghd", hs.diffthis, "Diff This (hg)")
        map("n", "<leader>ghD", function()
          hs.diffthis("~")
        end, "Diff This Parent (hg)")
        map("n", "<leader>ghR", hs.reset_buffer, "Reset Buffer (hg)")
        map({ "o", "x" }, "ih", hs.select_hunk, "Mercurial Hunk (hg)")
      end,
    },
  },
}
