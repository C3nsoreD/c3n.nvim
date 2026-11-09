# Formatting, LSP, and Mason — how they fit together

Three separate systems cooperate here. Knowing which one does what makes
problems obvious.

```
Mason      → installs the tools (language servers + formatters) onto your machine
nvim-lspconfig → connects Neovim to language servers (completion, diagnostics, go-to-def)
conform.nvim   → runs formatters (prettier, stylua, gofumpt…) on your code
```

## Mason — the tool installer

`lua/plugins/lsp.lua` lists everything Mason should install under
`mason-tool-installer` → `ensure_installed`:

```lua
ensure_installed = {
  "gopls", "html-lsp", "css-lsp", "emmet-language-server", "clangd",
  "rust-analyzer",
  -- formatters (used by conform.nvim)
  "gofumpt", "goimports", "prettier", "clang-format", "stylua",
},
```

Add a tool name here and it auto-installs on next start. Browse/install manually
with `:Mason`.

## LSP — language intelligence

A **Language Server** gives you completion, diagnostics, hover docs, rename, and
go-to-definition. `lua/plugins/lsp.lua`:

1. Advertises completion capabilities to servers.
2. On `LspAttach` (a server connecting to a buffer) sets the buffer-local
   keymaps: `gd` (definition), `gr` (references), `K` (hover), `<leader>rn`
   (rename), `<leader>ca` (code action), etc.
3. Defines each server's settings in the `servers` table, then enables them.

Note: `rust_analyzer` is intentionally **not** set up here — `rust.lua`
(rustaceanvim) owns it, so lsp.lua disables auto-enable to avoid attaching it
twice.

## Formatting — conform.nvim (the file you cared about)

`lua/plugins/formatting.lua`. Two pieces:

### a) Which formatter per filetype

```lua
formatters_by_ft = {
  go = { "goimports", "gofumpt" },   -- a list runs in sequence
  rust = { "rustfmt" },
  yaml = { "prettier" },
  lua = { "stylua" },
  -- …
}
```

### b) When it runs — `format_on_save`

It's a function returning options (or `nil` to skip). The important settings:

- **`lsp_format = "never"`** (on save) — only the formatters above run. A
  language server can't silently reformat a filetype you didn't configure.
  (`<leader>cf` uses `"fallback"` so manual formatting can still use the LSP.)
- **`timeout_ms = 2000`** — give external tools time to run.
- **the `skip` table** — filetypes we never auto-format (`gomod`, `helm`,
  `yaml.ansible`, …) because a formatter would corrupt them.

### Controlling it

| Action                               | Command                     |
| ------------------------------------ | --------------------------- |
| Toggle auto-format for this buffer   | `:FormatToggle!`            |
| Toggle auto-format globally          | `:FormatToggle`             |
| Format on demand                     | `<leader>cf`                |
| See the active formatter for a file  | `:ConformInfo`              |

### Project-level control (no nvim edits needed)

- `.editorconfig` — indentation/whitespace rules; prettier & others obey it.
  A starter one lives at this repo's root; copy it into your projects.
- `.prettierrc` — prettier-specific rules (`singleQuote`, `printWidth`, …).
- `.prettierignore` — files prettier must not touch.

## "LSP formatting" vs "conform formatting" — why both exist

Some language servers can format too (e.g. `gopls`). We prefer conform's
dedicated formatters because they're explicit and deterministic, and we set
`lsp_format = "never"` on save so the two can't fight. The LSP is still fully
used for completion/diagnostics/rename — just not for auto-formatting.

Next: **[04-cheatsheet.md](04-cheatsheet.md)**.
