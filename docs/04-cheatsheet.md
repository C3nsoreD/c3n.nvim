# Cheatsheet — common changes, copy/paste ready

Every recipe tells you the file to edit and the exact snippet. After editing,
restart Neovim or run `:Lazy sync` when a recipe adds a plugin.

## Add a plugin

Create or edit a file in `lua/plugins/`. Minimal spec:

```lua
-- lua/plugins/myplugin.lua
return {
  {
    "owner/repo",
    event = "VeryLazy",          -- or ft = {...} / cmd = "..." / keys = {...}
    opts = {},                   -- options passed to the plugin's setup()
  },
}
```

Then `:Lazy sync` to install.

## Add a formatter for a filetype

Edit `lua/plugins/formatting.lua` → `formatters_by_ft`:

```lua
formatters_by_ft = {
  -- …existing…
  python = { "ruff_format" },    -- a list runs in order
  sh = { "shfmt" },
}
```

If the tool isn't installed yet, add it to `ensure_installed` in
`lua/plugins/lsp.lua`, then `:Mason`.

## Stop a filetype from auto-formatting

Edit the `skip` table in `lua/plugins/formatting.lua`:

```lua
local skip = {
  gomod = true, gosum = true, gowork = true,
  helm = true, ["yaml.ansible"] = true,
  markdown = true,              -- ← add this to stop markdown auto-format
}
```

Or remove its line from `formatters_by_ft` entirely (still formats with
`<leader>cf`).

## Add a language server (LSP)

1. `lua/plugins/lsp.lua` → add the Mason package to `ensure_installed`
   (e.g. `"pyright"` / `"lua-language-server"`).
2. Add it to the `servers` table:

```lua
local servers = {
  -- …existing…
  pyright = {},                          -- empty = defaults
  lua_ls = {                             -- with settings
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
}
```

(The `for name, cfg in pairs(servers)` loop enables them automatically.)

## Add or change a keymap

Global maps → `lua/config/keymaps.lua`:

```lua
local map = vim.keymap.set
map("n", "<leader>x", "<cmd>echo 'hi'<cr>", { desc = "Say hi", silent = true })
```

- First arg: mode — `"n"` normal, `"i"` insert, `"v"` visual, or a list
  `{ "n", "v" }`.
- `<leader>` is Space (set in `init.lua`). `<cr>` = Enter, `<cmd>…<cr>` runs a
  command without leaving your mode.
- Always add `desc = "..."` — which-key shows it in the popup.

Plugin-specific keymaps live in that plugin's file under `keys = {...}`.

## Change indentation for a language

Edit `lua/config/autocmds.lua`. There are two groups already — add your
filetype to the right one:

```lua
-- 2-space languages:
pattern = { "html", "css", "scss", "dart", "json", "yaml", "lua", "python" },

-- or a new rule for 4-space tabs:
autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
  end,
})
```

Better yet: set it in `.editorconfig` so every tool agrees (see repo root).

## Change the theme

`lua/plugins/colorscheme.lua`. To try a different one, add its plugin and set
`vim.cmd("colorscheme <name>")`.

## Change an editor option

`lua/config/options.lua`:

```lua
vim.opt.relativenumber = false   -- e.g. turn off relative line numbers
vim.opt.scrolloff = 10
```

## Run something automatically on an event

`lua/config/autocmds.lua`:

```lua
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.sh" },
  callback = function() vim.notify("Saved a shell script") end,
})
```

Common events: `BufReadPost`, `BufWritePre`, `BufWritePost`, `InsertEnter`,
`FileType`, `TextYankPost`, `LspAttach`.

Next: **[05-troubleshooting.md](05-troubleshooting.md)**.
