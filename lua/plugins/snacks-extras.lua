return {
  {
    "folke/snacks.nvim",
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
        desc = "Find Files (Bash config)",
      },
    },
  },
}
