-- Treesitter: fast, accurate syntax highlighting & indentation (Zed also
-- uses tree-sitter grammars under the hood).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Pin the stable `master` branch. The newer default `main` branch is a
    -- rewrite that drops the `nvim-treesitter.configs` setup API this spec
    -- relies on (ensure_installed / highlight / indent / selection).
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    -- Make the :TS* commands load the plugin on demand, so they work even
    -- from an empty start screen.
    cmd = { "TSUpdate", "TSUpdateSync", "TSInstall", "TSInstallSync", "TSInstallInfo", "TSModuleInfo" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "go", "gomod", "gowork", "gosum",
        "dart",
        "html", "css", "scss",
        "rust",
        "c", "cpp",
        "lua", "vim", "vimdoc", "query",
        "json", "yaml", "toml", "markdown", "markdown_inline",
        "bash", "regex",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
    },
  },
}
