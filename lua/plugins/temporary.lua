return {
  {
    "saghen/blink.cmp",
    enabled = false,
    optional = true,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        providers = {
          path = {
            enabled = function()
              return vim.bo.filetype ~= "copilot-chat"
            end,
          },
        },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
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
        mode = { "n", "v" } 
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
            local has_selection = start_line > 0 and end_line > 0 and (start_line ~= end_line or vim.fn.col("'<") ~= vim.fn.col("'>"))
            
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
        desc = "Quick chat with CodeCompanion including selection"
      })
    end,
  },
}
