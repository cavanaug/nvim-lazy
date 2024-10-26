return {
    -- change some telescope options and a keymap to browse plugin files
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            -- add a keymap to browse plugin files
            -- stylua: ignore
            {
                "<leader>fp",
                function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
                desc = "Find Plugin File",
            },
        },
        -- change some options
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
            },
        },
    },
    -- add telescope-fzf-native
    {
        "telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                require("telescope").load_extension("fzf")
            end,
        },
    },
    --                     -- Telescope Mappings
    --                     ["<leader>fC"] = false,
    --                     ["<leader>fp"] = {
    --                         function() require("telescope").extensions.projects.projects {} end,
    --                         desc = "Find project repos (*)",
    --                     },
    --                     ["<leader>fe"] = { function() require("telescope.builtin").commands() end, desc = "Find ex commands (*)" },
    --
    --                     ["<leader>fA"] = {
    --                         function()
    --                             local cwd = vim.fn.stdpath "data" .. "/astronvim-v4/"
    --                             require("telescope.builtin").find_files {
    --                                 prompt_title = "Astrovnim-v4 Plugin Files",
    --                                 cwd = cwd,
    --                                 follow = true,
    --                             } -- call telescope
    --                         end,
    --                         desc = "Find Astronvim-v4 Plugin Files (*)",
    --                     },
    --                     ["<leader>fa"] = {
    --                         function()
    --                             local cwd = vim.fn.stdpath "config"
    --                             require("telescope.builtin").find_files {
    --                                 prompt_title = "Astrovim-v4 User Files",
    --                                 cwd = cwd,
    --                                 follow = true,
    --                             } -- call telescope
    --                         end,
    --                         desc = "Find Astronvim-v4 User Config files (*)",
    --                     },
    --                     ["<leader>fl"] = {
    --                         function()
    --                             local cwd = vim.fn.stdpath "data" .. "/lazy/astronvim-v4/"
    --                             require("telescope.builtin").find_files {
    --                                 prompt_title = "Astrovim-v4 Plugin Files",
    --                                 cwd = cwd,
    --                                 follow = true,
    --                             } -- call telescope
    --                         end,
    --                         desc = "Find words in Astrovim-v4 plugin files (*)",
    --                     },
    --                     ["<leader>fL"] = {
    --                         function()
    --                             local cwd = vim.fn.stdpath "data" .. "/lazy/"
    --                             -- local cwd = vim.fn.stdpath "data" .. "/lazy/"
    --                             require("telescope.builtin").find_files {
    --                                 prompt_title = "Find words in Neovim Plugin Files",
    --                                 cwd = cwd,
    --                                 follow = false,
    --                             } -- call telescope
    --                         end,
    --                         desc = "Find words in Neovim Lazy plugin files (*)",
    --                     },
}
