# Fixing "autosave poorly formats my files"

This document explains why YAML (and other files) looked mangled after saving,
what was changed to fix it, and how to control formatting going forward.

## TL;DR

- There is **no autosave plugin**. Files are saved manually (`Ctrl+S` or `:w`).
- What felt like "autosave reformatting" was **format-on-save** from
  `conform.nvim` (`lua/plugins/formatting.lua`).
- For `yaml`, `json`, `markdown`, `css`, `html` the formatter is **prettier**,
  and there was **no prettier config**, so prettier applied its opinionated
  defaults on every save.
- Fix: made format-on-save conservative and deterministic, and added a portable
  `.editorconfig`. You now also have simple ways to turn it off per file or per
  project.

## Root cause (the chain of events)

1. You edit `deploy.yaml` and press `Ctrl+S`.
2. `conform.nvim` has `event = { "BufWritePre" }` and a `format_on_save`
   function — it runs **before** the write.
3. For `filetype=yaml` the configured formatter is `prettier`.
4. No `.prettierrc` / `.editorconfig` exists, so prettier uses its built-in
   defaults: it re-indents block sequences, normalizes quotes, enforces a final
   newline, trims trailing whitespace, and (for markdown) re-wraps prose.
5. The on-disk file now differs from what you typed → "it formatted it badly".

A secondary risk: the old config used `lsp_format = "fallback"` on save, which
let a language server reformat filetypes that had no explicit formatter.

## What changed

### 1. `lua/plugins/formatting.lua`

- **`lsp_format = "never"` on save.** Only the explicit formatters listed in
  `formatters_by_ft` run automatically. No language server can silently rewrite
  a filetype you didn't opt into. (Manual `<leader>cf` still uses `fallback`,
  so you can format anything on demand.)
- **Pinned prettier args:** `--prose-wrap preserve` stops markdown prose from
  being re-wrapped. Prettier still honours any project-local `.editorconfig`,
  `.prettierrc`, or `.prettierignore`.
- **Expanded skip list:** also skips `helm` and `yaml.ansible` filetypes, whose
  Go/Jinja templating prettier would break, plus the existing
  `go.mod`/`go.sum`/`go.work`.

### 2. New `.editorconfig` (repo root)

A portable rules file that nvim-adjacent tooling and prettier read
automatically: 2-space indent, LF endings, final newline, trailing-whitespace
trim — with sane per-language exceptions (Go = tabs, Markdown keeps trailing
spaces). **Copy this file into your other projects** to get identical,
deterministic formatting everywhere.

## How to control formatting from now on

| You want to…                              | Do this                                                        |
| ----------------------------------------- | -------------------------------------------------------------- |
| Turn off auto-format for the current file | `:FormatToggle!`                                               |
| Turn off auto-format globally (session)   | `:FormatToggle`                                                |
| Format right now, on demand               | `<leader>cf` (normal or visual)                                |
| See what formatter runs for a file        | `:ConformInfo`                                                 |
| Stop prettier touching specific files     | add a `.prettierignore` in that project                        |
| Lock indentation style for a project      | copy `.editorconfig` into it (edit per-language sections)      |
| Pin prettier rules for a project          | add a `.prettierrc` (e.g. `singleQuote`, `printWidth`)         |

## If YAML still looks wrong after this

Prettier is generally fine for YAML but is opinionated. If you want stricter,
more conservative YAML formatting, switch that one filetype to **`yamlfmt`**
(Google's formatter, very configurable):

1. `:Mason` → install `yamlfmt` (or add it to `ensure_installed` in
   `lua/plugins/lsp.lua`).
2. In `lua/plugins/formatting.lua`, change `yaml = { "prettier" }` to
   `yaml = { "yamlfmt" }`.
3. Optionally add a `.yamlfmt` config in your projects with
   `retain_line_breaks: true` and `indentless_arrays: true`.

Or, if you'd rather never auto-format YAML and only do it on demand, remove the
`yaml = { "prettier" }` line entirely — `<leader>cf` will still format when you
ask.

## Verifying the fix

```vim
:ConformInfo      " confirms prettier is found and which ft it applies to
:Mason            " confirms prettier/stylua/etc. are installed
```

Then edit a YAML file, save, and check `git diff` — it should only show your
intended edits plus (at most) a trailing-newline normalization.
