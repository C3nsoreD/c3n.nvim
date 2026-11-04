-- Flutter / Dart. flutter-tools.nvim drives the `dartls` language server that
-- ships with the Flutter SDK (so no Mason install needed — it uses your local
-- `flutter`/`dart` on PATH) and adds hot-reload, device selection, etc.
return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- nice UI for device/command selection
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter: run", ft = "dart" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter: hot restart", ft = "dart" },
      { "<leader>Fh", "<cmd>FlutterReload<cr>", desc = "Flutter: hot reload", ft = "dart" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter: devices", ft = "dart" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter: emulators", ft = "dart" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter: quit", ft = "dart" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: widget outline", ft = "dart" },
    },
    config = function()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok and cmp_lsp.default_capabilities() or nil

      require("flutter-tools").setup({
        ui = { border = "rounded" },
        decorations = {
          statusline = { app_version = true, device = true },
        },
        lsp = {
          capabilities = capabilities,
          color = { enabled = true }, -- highlight color literals in the gutter
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
          on_attach = function(_, bufnr)
            -- reuse the same navigation keymaps defined in the LspAttach
            -- autocmd (lsp.lua); nothing extra needed here.
            local _ = bufnr
          end,
        },
        dev_log = { enabled = true, open_cmd = "botright 15split" },
        widget_guides = { enabled = true },
      })
    end,
  },
}
