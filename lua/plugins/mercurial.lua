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
    },
    config = function(_, opts)
      local hgsigns = require("hgsigns")
      hgsigns.setup(opts)

      local hl_group = vim.api.nvim_create_augroup("hgsigns_lazyvim_highlights", { clear = true })
      local map_group = vim.api.nvim_create_augroup("hgsigns_lazyvim_keymaps", { clear = true })
      local managed_lhs = { "]h", "[h", "]H", "[H", "<leader>ghp" }

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

      local function clear_hg_keymaps(bufnr)
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        for _, lhs in ipairs(managed_lhs) do
          pcall(vim.keymap.del, "n", lhs, { buffer = bufnr })
        end
        vim.b[bufnr].hgsigns_keymaps_attached = false
      end

      local function set_hg_keymaps(bufnr)
        if vim.b[bufnr].hgsigns_keymaps_attached then
          return
        end

        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        map("]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            hgsigns.nav_hunk("next", bufnr)
          end
        end, "Next Hunk")
        map("[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            hgsigns.nav_hunk("prev", bufnr)
          end
        end, "Prev Hunk")
        map("]H", function()
          hgsigns.nav_hunk("last", bufnr)
        end, "Last Hunk")
        map("[H", function()
          hgsigns.nav_hunk("first", bufnr)
        end, "First Hunk")
        map("<leader>ghp", function()
          hgsigns.preview_hunk(bufnr)
        end, "Preview Hunk")

        vim.b[bufnr].hgsigns_keymaps_attached = true
      end

      local function refresh_hg_keymaps(args)
        local bufnr = args and args.buf or vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local ok, state = pcall(hgsigns.manager.get, bufnr)
        if ok and state and state.attached then
          set_hg_keymaps(bufnr)
        else
          clear_hg_keymaps(bufnr)
        end
      end

      apply_highlights()
      vim.schedule(apply_highlights)
      vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
        group = hl_group,
        callback = apply_highlights,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufFilePost", "BufWritePost" }, {
        group = map_group,
        callback = refresh_hg_keymaps,
      })
      vim.schedule(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          refresh_hg_keymaps({ buf = bufnr })
        end
      end)
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
