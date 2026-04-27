-- Place this in a markdown.lua (or relevant file for Markdown)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Disable concealment for the entire filetype (markdown)
    vim.opt_local.conceallevel = 0
    vim.opt_local.textwidth = 140

    -- Force Tree-sitter to not conceal HTML comments
    vim.treesitter.query.set("markdown", "html", [[ (comment) @comment ]])

    -- Optional: Set a visible highlight for HTML comments
    vim.api.nvim_set_hl(0, "@comment.html", { fg = "#888888", bold = true })

    -- Keymap: zg adds word to both Neovim spellfile and project cspell dictionary
    vim.keymap.set("n", "zg", function()
      local word = vim.fn.expand("<cword>")
      -- Add to Neovim's spellfile
      vim.cmd.spellgood({ word })

      -- Also add to project cspell dictionary if one exists
      local cspell_config = vim.fs.find(
        { "cspell.config.yaml", "cspell.config.yml", "cspell.json", ".cspell.json" },
        { upward = true, path = vim.fn.expand("%:p:h") }
      )[1]
      if not cspell_config then
        vim.notify("Added '" .. word .. "' to spellfile (no cspell config found)", vim.log.levels.INFO)
        return
      end
      if cspell_config:match("%.yaml$") or cspell_config:match("%.yml$") then
        local lines = vim.fn.readfile(cspell_config)
        local insert_idx = nil
        for i, line in ipairs(lines) do
          if line:match("^words:") then
            insert_idx = i
          elseif insert_idx and not line:match("^%s+-") then
            break
          elseif insert_idx then
            insert_idx = i
          end
        end
        if insert_idx then
          table.insert(lines, insert_idx + 1, "  - " .. word)
          vim.fn.writefile(lines, cspell_config)
          vim.notify(
            "Added '" .. word .. "' to spellfile + " .. vim.fn.fnamemodify(cspell_config, ":~:."),
            vim.log.levels.INFO
          )
          require("lint").try_lint()
        else
          vim.notify("Added '" .. word .. "' to spellfile (no 'words:' section in cspell config)", vim.log.levels.WARN)
        end
      end
    end, { buffer = true, desc = "Add word to spellfile + cspell dictionary" })
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
  -- Disable markdownlint-cli2 linter; use cspell for spell checking (rumdl LSP handles markdown linting)
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = { "cspell" }
      opts.linters_by_ft["markdown.mdx"] = { "cspell" }
    end,
  },
}
