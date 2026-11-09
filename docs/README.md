# term_zed docs

Learning material and reference for this Neovim config, written so you can
change things yourself without starting from scratch each time.

## Read in this order

1. **[01-lua-basics.md](01-lua-basics.md)** — just enough Lua to read and edit
   every file in this repo (tables, functions, `require`, the `vim.*` API).
2. **[02-nvim-config-structure.md](02-nvim-config-structure.md)** — how the
   config is wired: `init.lua` → `lua/config/` → `lua/plugins/`, and how
   lazy.nvim loads plugins.
3. **[03-formatting-and-lsp.md](03-formatting-and-lsp.md)** — how
   format-on-save, conform, Mason, and LSP actually work here.
4. **[04-cheatsheet.md](04-cheatsheet.md)** — copy/paste recipes for the common
   tasks (add a plugin, add a formatter/LSP, add a keymap, per-language indent).
5. **[05-troubleshooting.md](05-troubleshooting.md)** — the commands to diagnose
   anything (`:checkhealth`, `:Lazy`, `:Mason`, `:LspInfo`, `:ConformInfo`).

## Also here

- **[formatting-fix-plan.md](formatting-fix-plan.md)** — why saves were
  reformatting your YAML badly and exactly what was changed to fix it.

## The 10-second mental model

```
init.lua                      -- entry point; sets leader key, loads the rest
└─ lua/config/
   ├─ options.lua             -- vim settings (numbers, indent, search, …)
   ├─ keymaps.lua             -- global key mappings
   ├─ autocmds.lua            -- "when X happens, do Y" rules
   └─ lazy.lua                -- bootstraps the plugin manager
└─ lua/plugins/*.lua          -- one file per topic; each returns a plugin spec
```

Everything in `lua/plugins/` is auto-discovered by lazy.nvim. To add a feature
you usually add or edit **one file** there.
