# How this config is structured

## The load order

When Neovim starts it runs **`init.lua`**, which does only five things:

```lua
vim.g.mapleader = " "            -- 1. leader key BEFORE plugins load (required)
vim.g.maplocalleader = " "
require("config.options")        -- 2. editor settings
require("config.keymaps")        -- 3. global keymaps
require("config.autocmds")       -- 4. event-driven behavior
require("config.lazy")           -- 5. bootstrap plugin manager + load plugins
```

Order matters: the leader key must be set before plugins define
`<leader>`-based mappings, and `lazy` is loaded last because it pulls in
everything else.

## `lua/config/` — your settings (no plugins)

| File           | Owns                                                                 |
| -------------- | ------------------------------------------------------------------- |
| `options.lua`  | `vim.opt.*` — numbers, indent defaults, search, undo, clipboard.    |
| `keymaps.lua`  | global `vim.keymap.set` mappings (save, window nav, move lines).    |
| `autocmds.lua` | `vim.api.nvim_create_autocmd` rules (yank highlight, per-ft indent).|
| `lazy.lua`     | downloads lazy.nvim if missing, then `require("lazy").setup(...)`.  |

## `lua/plugins/` — one file per topic

Each file **returns a table** describing one or more plugins. lazy.nvim imports
the whole folder (`{ import = "plugins" }` in `lazy.lua`), so **adding a file
here automatically registers its plugins** — no central list to update.

Current files:

```
colorscheme.lua   completion.lua   editor.lua    flutter.lua
formatting.lua     lsp.lua          neo-tree.lua  rust.lua
telescope.lua      terminal.lua     treesitter.lua  ui.lua
```

## Anatomy of a plugin spec

A "spec" is a table lazy.nvim understands. The most common keys:

```lua
return {
  {
    "owner/repo",                 -- [1] GitHub shorthand = which plugin
    event = "VeryLazy",           -- WHEN to load (lazy-loading trigger)
    ft = { "html", "xml" },       -- or: load only for these filetypes
    cmd = "Mason",                -- or: load when this command is first used
    keys = { ... },               -- or: load when these keys are pressed
    dependencies = { "a/b" },     -- load these first
    opts = { ... },               -- passed to the plugin's setup() for you
    config = function() ... end,  -- custom setup code (use instead of opts)
    init = function() ... end,    -- runs BEFORE the plugin loads
  },
}
```

### `opts` vs `config`

- **`opts = {...}`** — the simple path. lazy.nvim calls the plugin's
  `setup(opts)` for you. Use this whenever you just need to pass options.
- **`config = function() ... end`** — the full-control path. You call `setup()`
  yourself and can run extra code. `lsp.lua` uses this because it wires up
  multiple servers and autocommands.

### Lazy-loading (`event`, `ft`, `cmd`, `keys`)

Plugins don't all load at startup — they load on a trigger, which keeps Neovim
fast. Common triggers seen in this repo:

- `event = "VeryLazy"` — shortly after startup (UI niceties like which-key).
- `event = { "BufReadPost", "BufNewFile" }` — when you open/create a file.
- `event = "BufWritePre"` — just before saving (that's how conform formats).
- `event = "InsertEnter"` — when you start typing (autopairs).
- `ft = {...}` — only for certain filetypes (flutter, autotag).
- `cmd = "..."` — only when you run that command (`:Mason`).
- `keys = {...}` — only when you press that key.

## Where things live (quick map)

| I want to change…           | File                               |
| --------------------------- | ---------------------------------- |
| An editor setting           | `lua/config/options.lua`           |
| A keybinding (global)       | `lua/config/keymaps.lua`           |
| "On event X do Y"           | `lua/config/autocmds.lua`          |
| Format-on-save behavior     | `lua/plugins/formatting.lua`       |
| Language servers            | `lua/plugins/lsp.lua`              |
| Theme                       | `lua/plugins/colorscheme.lua`      |
| Fuzzy finder keymaps        | `lua/plugins/telescope.lua`        |
| File tree                   | `lua/plugins/neo-tree.lua`         |

Next: **[03-formatting-and-lsp.md](03-formatting-and-lsp.md)**.
