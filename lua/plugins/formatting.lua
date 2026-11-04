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
      -- Format automatically on save, falling back to the LSP formatter
      -- when no external tool is configured (e.g. dart uses dartls).
      format_on_save = function(bufnr)
        -- allow disabling per-buffer: `:let b:disable_autoformat = 1`
        if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
      formatters = {
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
