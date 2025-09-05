return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for better prompt input, and required to use opencode.nvim's embedded terminal
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    config = function()
      -- opencode.nvim passes options via a global variable instead of setup() for faster startup
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see lua/opencode/config.lua
      }

      -- Required for opts.auto_reload
      vim.opt.autoread = true

      -- Recommended keymaps (using default <leader>o prefix)
      vim.keymap.set('n', '<leader>ot', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
      vim.keymap.set('n', '<leader>oA', function() require('opencode').ask() end, { desc = 'Ask opencode' })
      vim.keymap.set('n', '<leader>oa', function() require('opencode').ask('@cursor: ') end, { desc = 'Ask opencode about this' })
      vim.keymap.set('v', '<leader>oa', function() require('opencode').ask('@selection: ') end, { desc = 'Ask opencode about selection' })
      vim.keymap.set('n', '<leader>on', function() require('opencode').command('session_new') end, { desc = 'New opencode session' })
      vim.keymap.set('n', '<leader>oy', function() require('opencode').command('messages_copy') end, { desc = 'Copy last opencode response' })
      vim.keymap.set('n', '<S-C-u>', function() require('opencode').command('messages_half_page_up') end, { desc = 'Messages half page up' })
      vim.keymap.set('n', '<S-C-d>', function() require('opencode').command('messages_half_page_down') end, { desc = 'Messages half page down' })
      vim.keymap.set({ 'n', 'v' }, '<leader>os', function() require('opencode').select() end, { desc = 'Select opencode prompt' })

      -- Example: keymap for custom prompt
      vim.keymap.set('n', '<leader>oe', function() require('opencode').prompt('Explain @cursor and its context') end, { desc = 'Explain this code' })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      -- Use CopilotChat keymaps but launch CodeCompanion instead
      { "<leader>aa", "<cmd>CodeCompanionToggle<cr>", desc = "Toggle (CodeCompanion)", mode = { "n", "v" } },
      { "<leader>ax", "<cmd>CodeCompanionChat Reset<cr>", desc = "Clear (CodeCompanion)", mode = { "n", "v" } },
      {
        "<leader>aq",
        "<cmd>CodeCompanionQuickChat<cr>",
        desc = "Quick Chat (CodeCompanion)",
        mode = { "n", "v" },
      },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "Prompt Actions (CodeCompanion)", mode = { "n", "v" } },
      { "<c-s>", "<CR>", ft = "codecompanion", desc = "Submit Prompt", remap = true },

      -- Additional CodeCompanion keymaps
      { "<leader>ci", "<cmd>CodeCompanion<cr>", desc = "CodeCompanion Inline", mode = { "n", "v" } },
    },
    config = function()
      -- Function to handle quick chat with visual selection (like CopilotChat)
      local function quick_chat_with_selection()
        vim.ui.input({ prompt = "Quick Chat: " }, function(input)
          if input and input ~= "" then
            -- Check if we have a visual selection by looking at marks
            local start_line = vim.fn.line("'<")
            local end_line = vim.fn.line("'>")
            local has_selection = start_line > 0
              and end_line > 0
              and (start_line ~= end_line or vim.fn.col("'<") ~= vim.fn.col("'>"))

            if has_selection then
              -- Use range command with selection context
              local range_cmd = start_line .. "," .. end_line .. "CodeCompanionChat"
              vim.cmd(range_cmd .. " " .. vim.fn.shellescape(input))
            else
              -- No selection, just regular chat
              vim.cmd("CodeCompanionChat " .. vim.fn.shellescape(input))
            end
          end
        end)
      end

      -- Set up the plugin
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-4",
                },
              },
            })
          end,
        },
        opts = {
          log_level = "DEBUG",
        },
      })

      -- Create the quick chat command
      vim.api.nvim_create_user_command("CodeCompanionQuickChat", quick_chat_with_selection, {
        range = true,
        desc = "Quick chat with CodeCompanion including selection",
      })
    end,
  },
}
