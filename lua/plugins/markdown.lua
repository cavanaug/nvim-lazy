-- Place this in a markdown.lua (or relevant file for Markdown)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Disable concealment for the entire filetype (markdown)
    vim.opt.conceallevel = 0

    -- Force Tree-sitter to not conceal HTML comments
    vim.treesitter.query.set("markdown", "html", [[ (comment) @comment ]])

    -- Optional: Set a visible highlight for HTML comments
    vim.api.nvim_set_hl(0, "@comment.html", { fg = "#888888", bold = true })
  end,
})
local HOME = os.getenv("HOME")
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", HOME .. "/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}
