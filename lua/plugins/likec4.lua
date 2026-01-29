-- LikeC4 Support Configuration
-- Architecture-as-Code DSL with LSP integration

return {
  -- LikeC4.nvim Plugin
  -- Provides syntax highlighting and LSP integration for .c4 files
  {
    "likec4/likec4.nvim",
    ft = "likec4", -- Load only for .c4 files
    -- Install language server and required peer dependencies
    -- Note: The peer dependencies are marked as optional in the package but are actually required
    build = table.concat({
      "npm install -g @likec4/language-server",
      "npm install -g @modelcontextprotocol/sdk@^1.25.3",
      "npm install -g bundle-require@^5.1.0",
    }, " && "),
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- The plugin automatically sets up:
      -- - Filetype detection for .c4 files
      -- - LSP client configuration (runs: likec4-language-server --stdio)
      -- - Syntax highlighting
      
      -- LSP Features available:
      -- - Real-time validation and diagnostics
      -- - Code completion (Ctrl-Space)
      -- - Go to definition (gd)
      -- - Find references (gr)
      -- - Hover documentation (K)
      -- - Safe renames (leader+cr)
      
      -- No additional configuration needed - it works out of the box!
      -- The language server will activate when you open a .c4 file
      -- in a directory with a likec4.config.json or .git folder
    end,
  },

  -- Optional: Ensure TreeSitter has required parsers
  -- LikeC4 may benefit from generic syntax support
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      -- Add any related parsers if needed
      -- Currently LikeC4 uses its own LSP-based highlighting
      return opts
    end,
  },
}
