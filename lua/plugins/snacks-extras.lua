-- vim.v.oldfiles (shada) can end up alphabetically sorted instead of MRU; sort by
-- mtime ourselves for dashboard, and use snacks frecency (mtime-seeded) for the picker.
local function recent_mtime(file)
  local stat = vim.uv.fs_stat(file)
  return stat and stat.mtime.sec or 0
end

local function recent_section(config)
  return function()
    local limit = config.limit or 5
    local candidates = {}
    for file in require("snacks.dashboard").oldfiles() do
      if (not config.filter or config.filter(file)) and vim.uv.fs_stat(file) then
        candidates[#candidates + 1] = { file = file, mtime = recent_mtime(file) }
      end
    end
    table.sort(candidates, function(a, b)
      return a.mtime > b.mtime
    end)

    local ret = {}
    for i = 1, math.min(limit, #candidates) do
      local file = candidates[i].file
      ret[#ret + 1] = {
        file = file,
        icon = "file",
        action = ":e " .. vim.fn.fnameescape(file),
        autokey = true,
      }
    end
    return ret
  end
end

-- Helper function to filter out unwanted files from recent files lists
local function recent_files_filter(file)
  local exclude_patterns = {
    "^/tmp/", -- /tmp directory
    "COMMIT_EDITMSG$", -- git/hg commit messages
    "%.tmp$",
    "%.log$",
    "%.bak$",
    "%.swp$",
    "%.swo$",
    "%.git/",
    "%.cache/",
  }
  for _, pattern in ipairs(exclude_patterns) do
    if file:match(pattern) then
      return false
    end
  end
  return true
end

return {
  {
    "folke/snacks.nvim",
    init = function()
      vim.schedule(function()
        pcall(require("snacks.picker.core.frecency").setup)
      end)
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
            -- Apply filter to picker's recent files source
            recent = {
              matcher = {
                frecency = true,
                sort_empty = true,
              },
              sort = { fields = { "frecency:desc", "idx" } },
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
