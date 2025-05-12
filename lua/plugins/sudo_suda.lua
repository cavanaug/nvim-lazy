-- This file is for items related to file permissions and sudo access.
return {
  {
    "lambdalisue/vim-suda",
    -- Optional: Add configuration for vim-suda here if needed
    -- For example, to enable smart edit mode:
    config = function()
      vim.g.suda_smart_edit = 1
    end,
  },
}
