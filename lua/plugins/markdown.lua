-- Place this in a markdown.lua (or relevant file for Markdown)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mdx", "markdown.mdx" },
  callback = function()
    -- Disable concealment for the entire filetype (markdown)
    vim.opt_local.conceallevel = 0
    vim.opt_local.textwidth = 125 -- match rumdl line-length

    -- Force Tree-sitter to not conceal HTML comments
    vim.treesitter.query.set("markdown", "html", [[ (comment) @comment ]])

    -- Optional: Set a visible highlight for HTML comments
    vim.api.nvim_set_hl(0, "@comment.html", { fg = "#888888", bold = true })
  end,
})
local rumdl_config = vim.fn.stdpath("config") .. "/rumdl.toml"
return {
  -- rumdl LSP: hide MD013 (line-length) diagnostics. rumdl uses pull diagnostics
  -- (textDocument/diagnostic), not publishDiagnostics. Reflow still happens on save
  -- via conform (`rumdl fmt` keeps MD013 + reflow in rumdl.toml).
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rumdl = {
          cmd = { "rumdl", "server", "--config", rumdl_config },
          handlers = {
            ["textDocument/diagnostic"] = function(err, result, ctx, config)
              if result and result.items then
                result.items = vim.tbl_filter(function(diag)
                  return diag.code ~= "MD013"
                end, result.items)
              end
              vim.lsp.diagnostic.on_diagnostic(err, result, ctx, config)
            end,
          },
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
  --   :MarkdownPreview       default preview -> wide column (1400px)
  --   :MarkdownPreviewNormal  stock GitHub width (900px)
  --   :MarkdownPreviewWide    wider fixed column (1400px, same as default)
  --   :MarkdownPreviewFlex    scales with the browser window (90vw)
  {
    "iamcco/markdown-preview.nvim",
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
      "MarkdownPreviewNormal",
      "MarkdownPreviewWide",
      "MarkdownPreviewFlex",
    },
    init = function()
      vim.g.mkdp_theme = "light"
      -- Reuse one preview tab across markdown buffers; refresh on buffer switch.
      -- auto_close must be off or the tab closes when leaving a buffer.
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_combine_preview_auto_refresh = 1
      vim.g.mkdp_auto_close = 0
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
      local function ensure_preview_commands()
        -- Buffer-local :MarkdownPreview is registered by mkdp's FileType autocmd.
        -- After lazy-load that autocmd may not have fired yet (LazyVim's extra used
        -- to run `do FileType` here; we must do the same or the command is missing).
        if vim.fn.exists(":MarkdownPreview") ~= 2 then
          vim.cmd("doautocmd FileType")
        end
      end

      local function open_preview(mode)
        vim.g.mkdp_markdown_css = css_for(mode)
        ensure_preview_commands()

        if vim.fn.exists(":MarkdownPreview") ~= 2 then
          vim.notify("MarkdownPreview is not available in this buffer", vim.log.levels.WARN)
          return
        end

        pcall(vim.fn["mkdp#util#stop_preview"])
        vim.defer_fn(function()
          vim.fn["mkdp#util#open_preview_page"]()
        end, 100)
      end

      -- :MarkdownPreview is registered by mkdp as buffer-local; replace it so the
      -- stock command name opens wide while :MarkdownPreviewNormal keeps 900px.
      local function override_markdown_preview()
        if not vim.tbl_contains({ "markdown", "markdown.mdx" }, vim.bo.filetype) then
          return
        end
        pcall(vim.cmd, "delcommand! MarkdownPreview")
        vim.api.nvim_buf_create_user_command(0, "MarkdownPreview", function()
          open_preview("wide")
        end, { desc = "MarkdownPreview (wide, 1400px)" })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "markdown.mdx" },
        callback = override_markdown_preview,
      })

      -- Default CSS when the preview server reads g:mkdp_markdown_css.
      vim.g.mkdp_markdown_css = css_for("wide")

      vim.api.nvim_create_user_command("MarkdownPreviewNormal", function()
        open_preview("normal")
      end, { desc = "MarkdownPreview at stock GitHub width (900px)" })

      vim.api.nvim_create_user_command("MarkdownPreviewWide", function()
        open_preview("wide")
      end, { desc = "MarkdownPreview with a wider column (1400px)" })

      vim.api.nvim_create_user_command("MarkdownPreviewFlex", function()
        open_preview("flex")
      end, { desc = "MarkdownPreview that scales with the window (90vw)" })

      ensure_preview_commands()
      override_markdown_preview()
    end,
  },
}
