-- Rust: rustaceanvim gives a richer rust-analyzer integration than plain
-- lspconfig (runnables, expand macro, etc.). It configures the LSP itself.
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false, -- plugin handles its own filetype lazy-loading
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = { command = "clippy" },
              procMacro = { enable = true },
              inlayHints = { lifetimeElisionHints = { enable = "always" } },
            },
          },
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, { buffer = bufnr, desc = "Rust: runnables", silent = true })
            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, { buffer = bufnr, desc = "Rust: debuggables", silent = true })
          end,
        },
      }
    end,
  },
}
