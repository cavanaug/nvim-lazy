-- Place this in a markdown.lua (or relevant file for Markdown)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mdx", "markdown.mdx" },
  callback = function()
    -- Disable concealment for the entire filetype (markdown)
    vim.opt_local.conceallevel = 0
    vim.opt_local.textwidth = 140

    -- Force Tree-sitter to not conceal HTML comments
    vim.treesitter.query.set("markdown", "html", [[ (comment) @comment ]])

    -- Optional: Set a visible highlight for HTML comments
    vim.api.nvim_set_hl(0, "@comment.html", { fg = "#888888", bold = true })
  end,
})
local rumdl_config = vim.fn.stdpath("config") .. "/rumdl.toml"
return {
  -- Configure rumdl LSP server with custom config path
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rumdl = {
          cmd = { "rumdl", "server", "--config", rumdl_config },
        },
      },
    },
  },
  -- Use rumdl fmt as the markdown formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "rumdl", "markdown-toc" },
        ["markdown.mdx"] = { "rumdl", "markdown-toc" },
      },
      formatters = {
        rumdl = {
          command = "rumdl",
          args = { "fmt", "--config", rumdl_config, "-" },
          stdin = true,
        },
      },
    },
  },
  -- Browser preview: force light theme (default follows system prefers-color-scheme)
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_theme = "light"
    end,
  },
}
