return {
  "stevearc/overseer.nvim",
  opts = function(_, opts)
    -- Override taskfiles to include case variants
    local task_provider = require("overseer.template.task")
    local original_taskfiles = {
      "Taskfile.yml",
      "Taskfile.yaml", 
      "Taskfile.dist.yml",
      "Taskfile.dist.yaml",
    }
    
    -- Add lowercase variants
    local taskfiles = vim.list_extend(original_taskfiles, {
      "taskfile.yml",
      "taskfile.yaml",
    })
    
    -- Override the find_taskfile function
    local original_find_taskfile = task_provider.cache_key
    task_provider.cache_key = function(search_opts)
      return vim.fs.find(taskfiles, { upward = true, type = "file", path = search_opts.dir })[1]
    end
    
    return opts
  end,
}