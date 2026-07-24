-- Cross-machine MRU via ~/Sync/nvim/mru.<hostname> (Syncthing).
-- ponytail: vim.v.oldfiles order is unreliable; we own the list instead of fighting shada.

local MRU_MAX = 100
local SYNC_DIR = vim.fn.expand("~/Sync/nvim")

local function recent_files_filter(file)
  local exclude_patterns = {
    "^/tmp/",
    "^/dev/shm/",
    "COMMIT_EDITMSG$",
    "%.tmp$",
    "%.log$",
    "%.bak$",
    "%.swp$",
    "%.swo$",
    "%.git/",
    "%.cache/",
    "/%.cursor/",
    "/Sync/nvim/mru%.",
    "/Sync/nvim/user%.",
  }
  for _, pattern in ipairs(exclude_patterns) do
    if file:match(pattern) then
      return false
    end
  end
  return true
end

local function host_mru_path()
  return SYNC_DIR .. "/mru." .. vim.fn.hostname()
end

---@return {ts:integer, path:string}[]
local function read_mru_file(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or not lines then
    return {}
  end
  local entries = {}
  for _, line in ipairs(lines) do
    local ts, p = line:match("^(%d+)\t(.+)$")
    if ts and p then
      entries[#entries + 1] = { ts = tonumber(ts), path = p }
    end
  end
  return entries
end

local function write_mru_file(path, entries)
  vim.fn.mkdir(SYNC_DIR, "p")
  local lines = {}
  for i = 1, math.min(MRU_MAX, #entries) do
    lines[#lines + 1] = entries[i].ts .. "\t" .. entries[i].path
  end
  vim.fn.writefile(lines, path)
end

--- Merge all mru.* hosts: max timestamp per path, exists locally, filtered.
---@return {ts:integer, path:string}[]
local function merged_mru()
  local best = {} ---@type table<string, integer>
  for _, file in ipairs(vim.fn.glob(SYNC_DIR .. "/mru.*", false, true)) do
    for _, e in ipairs(read_mru_file(file)) do
      if not best[e.path] or e.ts > best[e.path] then
        best[e.path] = e.ts
      end
    end
  end

  local list = {}
  for path, ts in pairs(best) do
    if recent_files_filter(path) and vim.uv.fs_stat(path) then
      list[#list + 1] = { path = path, ts = ts }
    end
  end
  table.sort(list, function(a, b)
    return a.ts > b.ts
  end)
  return list
end

local function touch_mru(path)
  path = vim.fs.normalize(path)
  if path == "" or not recent_files_filter(path) or not vim.uv.fs_stat(path) then
    return
  end

  local host_file = host_mru_path()
  local out = { { ts = os.time(), path = path } }
  for _, e in ipairs(read_mru_file(host_file)) do
    if e.path ~= path then
      out[#out + 1] = e
    end
  end
  write_mru_file(host_file, out)
end

-- One-shot seed from legacy user.* path lists + frecency DB if host mru is missing.
local function bootstrap_mru_if_needed()
  local host_file = host_mru_path()
  if vim.uv.fs_stat(host_file) then
    return
  end

  local best = {} ---@type table<string, integer>
  for _, file in ipairs(vim.fn.glob(SYNC_DIR .. "/user.*", false, true)) do
    local ok, lines = pcall(vim.fn.readfile, file)
    if ok and lines then
      for _, path in ipairs(lines) do
        if path:match("^/") and recent_files_filter(path) then
          local st = vim.uv.fs_stat(path)
          if st then
            local ts = st.mtime.sec
            if not best[path] or ts > best[path] then
              best[path] = ts
            end
          end
        end
      end
    end
  end

  local list = {}
  for path, ts in pairs(best) do
    list[#list + 1] = { path = path, ts = ts }
  end
  table.sort(list, function(a, b)
    return a.ts > b.ts
  end)
  if #list > 0 then
    write_mru_file(host_file, list)
  end
end

local function recent_section(config)
  return function()
    local limit = config.limit or 5
    local ret = {}
    for i, e in ipairs(merged_mru()) do
      if i > limit then
        break
      end
      if not config.filter or config.filter(e.path) then
        ret[#ret + 1] = {
          file = e.path,
          icon = "file",
          action = ":e " .. vim.fn.fnameescape(e.path),
          autokey = true,
        }
      end
    end
    return ret
  end
end

-- Finder setup runs on the main thread; the returned cb runs in a fast/async
-- context (must not call nvim_buf_get_name / vim.fn there).
---@param _opts snacks.picker.Config
---@param ctx snacks.picker.finder.ctx
local function mru_finder(_opts, ctx)
  local current = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local items = merged_mru()
  ---@async
  ---@param cb async fun(item: snacks.picker.finder.Item)
  return function(cb)
    for _, e in ipairs(items) do
      if e.path ~= current and ctx.filter:match({ file = e.path, text = e.path }) then
        cb({ file = e.path, text = e.path, recent = true })
      end
    end
  end
end

return {
  {
    "folke/snacks.nvim",
    init = function()
      bootstrap_mru_if_needed()
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("user_sync_mru", { clear = true }),
        callback = function(ev)
          if vim.bo[ev.buf].buftype ~= "" or not vim.bo[ev.buf].buflisted then
            return
          end
          touch_mru(vim.api.nvim_buf_get_name(ev.buf))
        end,
      })
    end,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        dashboard = {
          enabled = true,
          preset = {
            -- Custom header with your name/theme
            header = [[
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                             │
│                                                                                           │
│                  ████ ██████           █████      ██                                │
│                 ███████████             █████                                        │
│                 █████████ ███████████████████ ███   ███████████              │
│                █████████  ███    █████████████ █████ ██████████████              │
│               █████████ ██████████ █████████ █████ █████ ████ █████              │
│             ███████████ ███    ███ █████████ █████ █████ ████ █████             │
│            ██████  █████████████████████ ████ █████ █████ ████ ██████            │
│                                                                                             │
│                                                                                             │
│                                          LAZYVIM                                            │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
]],
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            {
              icon = " ",
              title = "Recent Files",
              indent = 2,
              padding = 1,
              recent_section({ filter = recent_files_filter }),
            },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            { section = "startup" },
          },
        },
        picker = {
          sources = {
            recent = {
              finder = mru_finder,
              format = "file",
              filter = {
                paths = {
                  [vim.fn.stdpath("data")] = false,
                  [vim.fn.stdpath("cache")] = false,
                  [vim.fn.stdpath("state")] = false,
                },
                filter = function(item)
                  return recent_files_filter(item.file)
                end,
              },
            },
          },
          win = {
            input = {
              keys = {
                -- Allow for selecting files with Ctrl-Space in any snacks picker
                ["<C-Space>"] = { "select_and_next", mode = { "i", "n" } },
              },
            },
          },
        },
      })
    end,
    keys = {
      {
        "<leader>fs",
        function()
          -- Create a list of all bash config files
          local files = {}
          local home = vim.fn.expand("~")

          -- Use vim.fn.glob to find bash files
          local bash_files = vim.fn.glob(home .. "/.bash*", false, true)
          for _, file in ipairs(bash_files) do
            if vim.fn.isdirectory(file) == 1 then
              -- If it's a directory, find all files inside
              local dir_files = vim.fn.glob(file .. "/**", false, true)
              for _, df in ipairs(dir_files) do
                if vim.fn.isdirectory(df) == 0 then
                  table.insert(files, { file = df, text = vim.fn.fnamemodify(df, ":~") })
                end
              end
            else
              table.insert(files, { file = file, text = vim.fn.fnamemodify(file, ":~") })
            end
          end

          -- Use picker with list source
          require("snacks").picker.pick({
            source = "list",
            items = files,
            prompt = "> ",
          })
        end,
        desc = "Find Files (Shell configs) (*)",
      },
      {
        "<leader>fx",
        function()
          require("snacks").picker.files({ cwd = vim.fn.expand("~/.config") })
        end,
        desc = "Find Files (XDG Config) (*)",
      },
    },
  },
}
