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
  -- plus extra commands for wider rendering than the stock narrow column.
  --
  -- Background: the preview's reading column is hard-capped at 900px by the
  -- plugin's bundled `app/_static/page.css` (#page-ctn { max-width: 900px }).
  -- There is no native option for this, but `g:mkdp_markdown_css` lets us serve
  -- a custom stylesheet in place of the bundled `markdown.css`, which is loaded
  -- *after* page.css and can therefore override the cap. The plugin re-reads
  -- `g:mkdp_markdown_css` on every HTTP request (see app/server.js), so swapping
  -- the value and (re)opening the preview is enough to apply a new width.
  --
  -- Commands:
  --   :MarkdownPreview      stock command -> normal width (900px)
  --   :MarkdownPreviewWide  wider fixed column (1400px)
  --   :MarkdownPreviewFlex  scales with the browser window (90vw)
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_theme = "light"
    end,
    config = function()
      -- Width presets. The value is dropped straight into CSS `max-width`.
      local widths = {
        normal = "900px", -- GitHub default (stock :MarkdownPreview)
        wide = "1400px", -- fixed wider column
        flex = "90vw", -- scales with the browser window
      }

      -- Resolve the plugin's bundled markdown.css via lazy's plugin dir so we
      -- inherit upstream GitHub styling and only append a width override. This
      -- avoids vendoring a full copy of the stylesheet (which would drift).
      local function bundled_css()
        local ok, lazy_config = pcall(require, "lazy.core.config")
        if not ok then
          return nil
        end
        local plug = lazy_config.plugins["markdown-preview.nvim"]
        if not plug then
          return nil
        end
        return plug.dir .. "/app/_static/markdown.css"
      end

      -- Generate (or reuse) a temp stylesheet for the given mode and return its
      -- path. The file is base GitHub CSS + a #page-ctn max-width override.
      local generated = {}
      local function css_for(mode)
        if generated[mode] then
          return generated[mode]
        end
        local base_path = bundled_css()
        local base = ""
        if base_path and vim.fn.filereadable(base_path) == 1 then
          base = table.concat(vim.fn.readfile(base_path), "\n")
        end
        local override = ([[

/* >>> width mode injected by nvim config (mode: %s) <<< */
#page-ctn {
  max-width: %s !important;
}
]]):format(mode, widths[mode])
        local out = vim.fn.tempname() .. "-mkdp-" .. mode .. ".css"
        vim.fn.writefile(vim.split(base .. override, "\n"), out)
        generated[mode] = out
        return out
      end

      -- Point g:mkdp_markdown_css at the right file, then open the preview. If a
      -- preview is already open we stop first so the browser refetches the new
      -- CSS (the plugin reuses an existing tab otherwise, keeping the old width).
      local function preview_with(mode)
        vim.g.mkdp_markdown_css = css_for(mode)

        -- :MarkdownPreview* are buffer-local and only exist in markdown buffers.
        if vim.fn.exists(":MarkdownPreview") ~= 2 then
          vim.notify("MarkdownPreview is not available in this buffer", vim.log.levels.WARN)
          return
        end

        pcall(vim.cmd, "MarkdownPreviewStop")
        vim.defer_fn(function()
          vim.cmd("MarkdownPreview")
        end, 100)
      end

      -- Default to normal so a bare :MarkdownPreview renders at stock width.
      vim.g.mkdp_markdown_css = css_for("normal")

      vim.api.nvim_create_user_command("MarkdownPreviewWide", function()
        preview_with("wide")
      end, { desc = "MarkdownPreview with a wider column (1400px)" })

      vim.api.nvim_create_user_command("MarkdownPreviewFlex", function()
        preview_with("flex")
      end, { desc = "MarkdownPreview that scales with the window (90vw)" })
    end,
  },
}
