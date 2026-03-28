return {
  {
    "cavanaug/hgsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
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
    config = function(_, opts)
      local hgsigns = require("hgsigns")
      hgsigns.setup(opts)

      local hl_group = vim.api.nvim_create_augroup("hgsigns_lazyvim_highlights", { clear = true })

      local function preferred_link(primary, fallback)
        return vim.fn.hlexists(primary) == 1 and primary or fallback
      end

      local function apply_highlights()
        local links = {
          HgsignsAdd = preferred_link("GitSignsAdd", "DiffAdd"),
          HgsignsChange = preferred_link("GitSignsChange", "DiffChange"),
          HgsignsDelete = preferred_link("GitSignsDelete", "DiffDelete"),
          HgsignsTopdelete = preferred_link("GitSignsTopdelete", "DiffDelete"),
          HgsignsChangedelete = preferred_link("GitSignsChangedelete", "DiffDelete"),
          HgsignsPreviewAddInline = preferred_link("GitSignsAddInline", "DiffAdd"),
          HgsignsPreviewDeleteInline = preferred_link("GitSignsDeleteInline", "DiffDelete"),
        }

        for from, to in pairs(links) do
          vim.api.nvim_set_hl(0, from, { link = to })
        end
      end

      apply_highlights()
      vim.schedule(apply_highlights)
      vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
        group = hl_group,
        callback = apply_highlights,
      })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.statuscolumn = opts.statuscolumn or {}
      opts.statuscolumn.git = opts.statuscolumn.git or {}

      -- LazyVim/Snacks puts git signs in a dedicated statuscolumn slot based on
      -- highlight/sign-name patterns. Add Hgsigns so Mercurial signs render in
      -- the same slot as gitsigns instead of the generic sign slot.
      local patterns = vim.deepcopy(opts.statuscolumn.git.patterns or { "GitSign", "MiniDiffSign" })
      if not vim.tbl_contains(patterns, "Hgsigns") then
        patterns[#patterns + 1] = "Hgsigns"
      end
      opts.statuscolumn.git.patterns = patterns

      return opts
    end,
  },
}
