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
      local api = vim.api
      local fn = vim.fn
      local hgsigns = require("hgsigns")

      hgsigns.setup(opts)

      local hl_group = api.nvim_create_augroup("hgsigns_lazyvim_highlights", { clear = true })
      local map_group = api.nvim_create_augroup("hgsigns_lazyvim_keymaps", { clear = true })
      local managed_maps = {
        { mode = "n", lhs = "]h" },
        { mode = "n", lhs = "[h" },
        { mode = "n", lhs = "]H" },
        { mode = "n", lhs = "[H" },
        { mode = "n", lhs = "<leader>ghp" },
        { mode = "n", lhs = "<leader>ghb" },
        { mode = "n", lhs = "<leader>ghB" },
        { mode = "n", lhs = "<leader>ghd" },
        { mode = "n", lhs = "<leader>ghD" },
        { mode = "n", lhs = "<leader>ghR" },
        { mode = "o", lhs = "ih" },
        { mode = "x", lhs = "ih" },
      }

      local function preferred_link(primary, fallback)
        return fn.hlexists(primary) == 1 and primary or fallback
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
          api.nvim_set_hl(0, from, { link = to })
        end
      end

      local function notify(msg, level)
        vim.notify(msg, level or vim.log.levels.INFO, { title = "hgsigns" })
      end

      local function split_lines(text)
        local lines = vim.split(text or "", "\n", { plain = true, trimempty = false })
        if lines[#lines] == "" then
          table.remove(lines)
        end
        return lines
      end

      local function attached_state(bufnr, quiet)
        local ok, state = pcall(hgsigns.manager.get, bufnr)
        if ok and state and state.attached and state.root and state.relpath then
          return state
        end

        if not quiet then
          notify("current buffer is not attached to a Mercurial file", vim.log.levels.WARN)
        end
      end

      local function run_hg(state, args)
        local argv = { "hg" }
        vim.list_extend(argv, args)
        argv[#argv + 1] = state.relpath

        local result = vim.system(argv, {
          cwd = state.root,
          text = true,
        }):wait()

        if result.code ~= 0 then
          local stderr = vim.trim(result.stderr or "")
          if stderr == "" then
            stderr = table.concat(argv, " ") .. " failed"
          end
          return nil, stderr
        end

        return split_lines(result.stdout)
      end

      local function open_scratch(title, lines, filetype)
        vim.cmd("vnew")
        local buf = api.nvim_get_current_buf()
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].swapfile = false
        vim.bo[buf].modifiable = true
        vim.bo[buf].readonly = false
        if filetype then
          vim.bo[buf].filetype = filetype
        end
        pcall(api.nvim_buf_set_name, buf, title)
        api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
        vim.bo[buf].readonly = true
        vim.bo[buf].modified = false
      end

      local function blame_line(bufnr)
        local state = attached_state(bufnr)
        if not state then
          return
        end

        local lines, err = run_hg(state, { "annotate", "-u", "-n", "-c", "-l" })
        if not lines then
          notify(err, vim.log.levels.ERROR)
          return
        end

        local lnum = api.nvim_win_get_cursor(0)[1]
        local line = lines[lnum]
        if not line then
          notify(("no annotate output for line %d"):format(lnum), vim.log.levels.WARN)
          return
        end

        notify(line)
      end

      local function blame_buffer(bufnr)
        local state = attached_state(bufnr)
        if not state then
          return
        end

        local lines, err = run_hg(state, { "annotate", "-u", "-n", "-c", "-l" })
        if not lines then
          notify(err, vim.log.levels.ERROR)
          return
        end

        open_scratch(("hgsigns://annotate/%s"):format(state.relpath), lines, "text")
      end

      local function diff_working(bufnr)
        local state = attached_state(bufnr)
        if not state then
          return
        end

        local lines, err = run_hg(state, { "diff" })
        if not lines then
          notify(err, vim.log.levels.ERROR)
          return
        end

        if #lines == 0 then
          notify("no working-copy diff for current file")
          return
        end

        open_scratch(("hgsigns://diff/%s"):format(state.relpath), lines, "diff")
      end

      local function diff_last_change(bufnr)
        local state = attached_state(bufnr)
        if not state then
          return
        end

        local lines, err = run_hg(state, { "diff", "-r", "p1()^", "-r", "p1()" })
        if not lines then
          if err:match("empty revision on one side of range") then
            notify("no previous committed Mercurial diff is available for this file yet", vim.log.levels.WARN)
          else
            notify(err, vim.log.levels.ERROR)
          end
          return
        end

        if #lines == 0 then
          notify("no previous committed diff available for current file")
          return
        end

        open_scratch(("hgsigns://diff-last/%s"):format(state.relpath), lines, "diff")
      end

      local function revert_buffer(bufnr)
        local state = attached_state(bufnr)
        if not state then
          return
        end

        local choice = fn.confirm(
          ("Revert %s from the Mercurial parent revision? This discards local changes."):format(state.relpath),
          "&Yes\n&No",
          2
        )
        if choice ~= 1 then
          return
        end

        local _, err = run_hg(state, { "revert" })
        if err then
          notify(err, vim.log.levels.ERROR)
          return
        end

        vim.cmd("edit!")
        notify("buffer reverted from Mercurial parent revision")
      end

      local function select_hunk(bufnr)
        local state = attached_state(bufnr)
        if not state then
          return
        end

        local cursor = api.nvim_win_get_cursor(0)
        local hunk = require("hgsigns.hunks").find_hunk(cursor[1], state.hunks)
        if not hunk then
          notify("no hunk under cursor", vim.log.levels.WARN)
          return
        end

        local start_lnum = hunk.added.start == 0 and 1 or hunk.added.start
        local end_lnum = math.max(hunk.vend or start_lnum, start_lnum)
        local end_line = api.nvim_buf_get_lines(bufnr, end_lnum - 1, end_lnum, false)[1] or ""
        local end_col = math.max(vim.fn.strchars(end_line) - 1, 0)

        api.nvim_win_set_cursor(0, { start_lnum, 0 })
        vim.cmd("normal! v")
        api.nvim_win_set_cursor(0, { end_lnum, end_col })
      end

      local function clear_hg_keymaps(bufnr)
        if not api.nvim_buf_is_valid(bufnr) then
          return
        end

        for _, map in ipairs(managed_maps) do
          pcall(vim.keymap.del, map.mode, map.lhs, { buffer = bufnr })
        end
        vim.b[bufnr].hgsigns_keymaps_attached = false
      end

      local function set_hg_keymaps(bufnr)
        if vim.b[bufnr].hgsigns_keymaps_attached then
          return
        end

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            hgsigns.nav_hunk("next", bufnr)
          end
        end, "Next Hunk (hg)")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            hgsigns.nav_hunk("prev", bufnr)
          end
        end, "Prev Hunk (hg)")
        map("n", "]H", function()
          hgsigns.nav_hunk("last", bufnr)
        end, "Last Hunk (hg)")
        map("n", "[H", function()
          hgsigns.nav_hunk("first", bufnr)
        end, "First Hunk (hg)")
        map("n", "<leader>ghp", function()
          hgsigns.preview_hunk(bufnr)
        end, "Preview Hunk (hg)")
        map("n", "<leader>ghb", function()
          blame_line(bufnr)
        end, "Blame Line (hg)")
        map("n", "<leader>ghB", function()
          blame_buffer(bufnr)
        end, "Blame Buffer (hg)")
        map("n", "<leader>ghd", function()
          diff_working(bufnr)
        end, "Diff This (hg)")
        map("n", "<leader>ghD", function()
          diff_last_change(bufnr)
        end, "Diff This Parent (hg)")
        map("n", "<leader>ghR", function()
          revert_buffer(bufnr)
        end, "Revert Buffer (hg)")
        map({ "o", "x" }, "ih", function()
          select_hunk(bufnr)
        end, "Mercurial Hunk (hg)")

        vim.b[bufnr].hgsigns_keymaps_attached = true
      end

      local function refresh_hg_keymaps(args)
        local bufnr = args and args.buf or api.nvim_get_current_buf()
        if not api.nvim_buf_is_valid(bufnr) then
          return
        end

        local state = attached_state(bufnr, true)
        if state and state.attached then
          set_hg_keymaps(bufnr)
        else
          clear_hg_keymaps(bufnr)
        end
      end

      apply_highlights()
      vim.schedule(apply_highlights)
      api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
        group = hl_group,
        callback = apply_highlights,
      })

      api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufFilePost", "BufWritePost" }, {
        group = map_group,
        callback = refresh_hg_keymaps,
      })
      vim.schedule(function()
        for _, bufnr in ipairs(api.nvim_list_bufs()) do
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
