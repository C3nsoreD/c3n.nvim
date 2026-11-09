-- Format-on-save (Zed's "format on save" default) via conform.nvim.
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        dart = { "dart_format" },
        lua = { "stylua" },
      },
      -- Format automatically on save.
      --
      -- On save we use `lsp_format = "never"`: only the explicit formatters in
      -- `formatters_by_ft` above run. This stops a language server from
      -- silently reformatting a filetype we never opted in to (a common source
      -- of "my file got mangled on save"). The manual `<leader>cf` map still
      -- uses `lsp_format = "fallback"` so you can format anything on demand.
      format_on_save = function(bufnr)
        -- Global/per-buffer kill switch: `:FormatToggle` or `:FormatToggle!`
        -- (also `:let b:disable_autoformat = 1`).
        if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
          return
        end
        -- Never auto-format these — they're managed by their own tooling and
        -- a formatter rewrite can corrupt them:
        --   * go.mod/go.sum/go.work   → maintained by the `go mod` commands
        --   * helm / ansible YAML     → contain Go/Jinja templates that
        --                               prettier reindents and breaks
        --   * env / gitignore-likes   → whitespace/order is meaningful
        local skip = {
          gomod = true,
          gosum = true,
          gowork = true,
          helm = true,
          ["yaml.ansible"] = true,
        }
        if skip[vim.bo[bufnr].filetype] then
          return
        end
        return { timeout_ms = 2000, lsp_format = "never" }
      end,
      formatters = {
        -- Keep prettier's output deterministic and close to what you typed.
        -- `--prose-wrap preserve` stops markdown prose from being re-wrapped,
        -- and prettier still honours any `.editorconfig`, `.prettierrc`, or
        -- `.prettierignore` it finds in the project being edited.
        prettier = {
          prepend_args = { "--prose-wrap", "preserve" },
        },
        dart_format = {
          command = "dart",
          args = { "format" },
          stdin = true,
        },
      },
    },
    init = function()
      -- Toggle autoformat on/off.
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
      end, { bang = true, desc = "Toggle autoformat (!: current buffer only)" })
    end,
  },
}
