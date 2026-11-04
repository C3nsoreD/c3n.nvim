-- LSP setup for Go, HTML, CSS, Rust and C (Dart/Flutter is handled by
-- flutter-tools.lua). Mason auto-installs the servers; nvim-lspconfig wires
-- them up. Keymaps attach per-buffer when a server connects.
return {
  -- Mason: installer for language servers, formatters, linters.
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      -- Completion capabilities source (see completion.lua).
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Pretty diagnostic signs in the gutter.
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Capabilities advertised to servers (adds completion support).
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Buffer-local keymaps when a language server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          local function m(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc, silent = true })
          end
          -- Zed Cmd+click / F12 → go to definition
          m("gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
          m("gr", "<cmd>Telescope lsp_references<cr>", "References")
          m("gI", "<cmd>Telescope lsp_implementations<cr>", "Go to implementation")
          m("gy", "<cmd>Telescope lsp_type_definitions<cr>", "Type definition")
          m("gD", vim.lsp.buf.declaration, "Go to declaration")
          -- Zed hover (Cmd+hover) → K
          m("K", vim.lsp.buf.hover, "Hover docs")
          -- Zed Cmd+. → code actions
          m("<leader>.", vim.lsp.buf.code_action, "Code action")
          m("<leader>ca", vim.lsp.buf.code_action, "Code action")
          -- Zed F2 → rename symbol
          m("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = event.buf, desc = "LSP: Rename", silent = true })
          -- Signature help in insert mode
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = event.buf, silent = true })
        end,
      })

      -- Servers and their per-server settings.
      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              usePlaceholders = true,
              analyses = { unusedparams = true, nilness = true, unusedwrite = true },
              staticcheck = true,
              hints = {
                parameterNames = true,
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        html = { filetypes = { "html" } },
        cssls = {},
        emmet_language_server = { filetypes = { "html", "css", "scss" } },
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
        },
        -- rust_analyzer is configured by rustaceanvim (rust.lua); don't let
        -- mason-lspconfig auto-setup it here to avoid double attach.
      }

      -- Ask Mason to install the servers + formatting tools we rely on.
      require("mason-tool-installer").setup({
        ensure_installed = {
          "gopls", "html-lsp", "css-lsp", "emmet-language-server", "clangd",
          "rust-analyzer",
          -- formatters (used by conform.nvim)
          "gofumpt", "goimports", "prettier", "clang-format", "stylua",
        },
        run_on_start = true,
      })

      -- Wire up each server. (mason-lspconfig only drives installation of the
      -- LSPs; setup is explicit here for clarity.)
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        -- We enable servers explicitly below, so don't let mason-lspconfig
        -- auto-enable installed ones (that would double-attach rust_analyzer,
        -- which rustaceanvim owns).
        automatic_enable = false,
      })

      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end

      -- Inlay hints on by default (Neovim 0.10+), like Zed.
      if vim.lsp.inlay_hint then
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            pcall(vim.lsp.inlay_hint.enable, true, { bufnr = args.buf })
          end,
        })
      end
    end,
  },
}
