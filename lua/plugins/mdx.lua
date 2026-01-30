-- MDX Support Configuration
-- Extends LazyVim's markdown extra to provide full MDX support

-- Set up filetype detection for MDX files
-- LazyVim's markdown extra already does this, but we ensure it's set early
vim.filetype.add({
  extension = {
    mdx = "markdown.mdx",
  },
})

return {
  -- TreeSitter: Ensure required parsers are installed
  -- MDX files use markdown + TSX parsers (no dedicated MDX parser exists yet)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "tsx",
        "typescript",
      },
    },
  },

  -- LSP: Configure mdx_analyzer
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Get TypeScript SDK path
      local home = vim.env.HOME or vim.fn.expand("~")
      local tsdk = home
        .. "/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"

      -- Ensure servers table exists
      opts.servers = opts.servers or {}

      -- Get existing mdx_analyzer config or create new
      local mdx_config = opts.servers.mdx_analyzer or {}

      -- Merge our configuration
      opts.servers.mdx_analyzer = vim.tbl_deep_extend("force", mdx_config, {
        mason = true, -- Install via Mason
        filetypes = { "mdx", "markdown.mdx" },
        settings = {},
        init_options = {
          typescript = {
            tsdk = tsdk,
          },
        },
      })

      return opts
    end,
  },

  -- Extend vtsls (TypeScript LSP) to support MDX files
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.vtsls = opts.servers.vtsls or {}

      -- Extend vtsls filetypes to include MDX
      local vtsls_filetypes = opts.servers.vtsls.filetypes
        or {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        }

      -- Add MDX filetypes if not already present
      for _, ft in ipairs({ "mdx", "markdown.mdx" }) do
        if not vim.tbl_contains(vtsls_filetypes, ft) then
          table.insert(vtsls_filetypes, ft)
        end
      end

      opts.servers.vtsls.filetypes = vtsls_filetypes

      return opts
    end,
  },

  -- Mason: Ensure mdx-analyzer is installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "mdx-analyzer",
      },
    },
  },

  -- Formatting: Remove prettier, keep only markdownlint-cli2 and markdown-toc
  -- "markdown.mdx" is already handled by the markdown.lua config
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        mdx = { "markdownlint-cli2", "markdown-toc" },
        -- "markdown.mdx" is already handled by the markdown extra
      },
    },
  },

  -- Linting: Configure for MDX files
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        mdx = { "markdownlint-cli2" },
        -- "markdown.mdx" can be added if needed
      },
    },
  },

  -- Enable render-markdown for MDX files
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = { "mdx", "markdown.mdx" },
  },

  -- MDX-specific editor settings
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "mdx", "markdown.mdx" },
        callback = function()
          -- Editor settings for MDX files
          vim.opt_local.conceallevel = 0 -- Disable concealment
          vim.opt_local.spell = true -- Enable spell check
          vim.opt_local.wrap = true -- Enable word wrap
          vim.opt_local.linebreak = true -- Break at word boundaries
          vim.opt_local.textwidth = 80 -- Text width for formatting
          vim.opt_local.commentstring = "{/* %s */}" -- JSX-style comments
        end,
      })
    end,
  },
}
