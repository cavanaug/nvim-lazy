return {
  {
    "stevearc/overseer.nvim",
    keys = {
      -- Disable default <leader>o keymaps
      { "<leader>ow", false },
      { "<leader>oo", false },
      { "<leader>oq", false },
      { "<leader>oi", false },
      { "<leader>ob", false },
      { "<leader>ot", false },
      { "<leader>oc", false },
      
      -- New <leader>O keymaps
      { "<leader>Ow", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
      { "<leader>Oo", "<cmd>OverseerRun<cr>",         desc = "Run task" },
      { "<leader>Oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
      { "<leader>Oi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
      { "<leader>Ob", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
      { "<leader>Ot", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
      { "<leader>Oc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
    },
    config = function(_, opts)
      -- Extend the taskfiles list to include lowercase variants
      local task_template = require("overseer.template.task")
      
      -- Override the taskfiles table directly
      local original_taskfiles = {
        "Taskfile.yml",
        "Taskfile.yaml",
        "Taskfile.dist.yml",
        "Taskfile.dist.yaml",
      }
      
      -- Add lowercase variants
      local extended_taskfiles = vim.list_extend(vim.deepcopy(original_taskfiles), {
        "taskfile.yml",
        "taskfile.yaml",
      })
      
      -- Replace the find_taskfile function in the cache_key
      task_template.cache_key = function(opts)
        return vim.fs.find(extended_taskfiles, { upward = true, type = "file", path = opts.dir })[1]
      end
      
      -- Also update the condition callback to use the extended list
      local original_condition = task_template.condition.callback
      task_template.condition.callback = function(opts)
        if vim.fn.executable("task") == 0 then
          return false, 'Command "task" not found'
        end
        local taskfile = vim.fs.find(extended_taskfiles, { upward = true, type = "file", path = opts.dir })[1]
        if not taskfile then
          return false, "No Taskfile found"
        end
        return true
      end
      
      -- Setup overseer with default config
      require("overseer").setup(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>o", group = "overseer", mode = "n" },
        { "<leader>O", group = "overseer", mode = "n" },
      },
    },
  },
}