return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        dashboard = {
          enabled = true,
          preset = {
            -- Custom header with your name/theme
            header = [[
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│                                                                          │
│          ████ ██████           █████      ██                       │
│         ███████████             █████                               │
│         █████████ ███████████████████ ███   ███████████     │
│        █████████  ███    █████████████ █████ ██████████████     │
│       █████████ ██████████ █████████ █████ █████ ████ █████     │
│     ███████████ ███    ███ █████████ █████ █████ ████ █████    │
│    ██████  █████████████████████ ████ █████ █████ ████ ██████   │
│                                                                            │
│                                                                            │
│                                 LAZYVIM                                    │
└────────────────────────────────────────────────────────────────────────────┘

]],
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            { section = "startup" },
          },
        },
        recent = {
          -- Filter out certain file patterns from recent files
          filter = function(file)
            -- Exclude temporary files, logs, and other unwanted files
            local exclude_patterns = {
              "%.tmp$",
              "%.log$",
              "%.bak$",
              "%.swp$",
              "%.swo$",
              "/tmp/",
              "COMMIT_EDITMSG",
              "%.git/",
              "node_modules/",
              "%.cache/",
            }
            
            for _, pattern in ipairs(exclude_patterns) do
              if file:match(pattern) then
                return false
              end
            end
            return true
          end,
        },
        picker = {
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
