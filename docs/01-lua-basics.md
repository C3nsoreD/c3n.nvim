# Lua basics for Neovim config

You don't need to "learn Lua" fully. You need to recognise ~8 patterns. Every
file in this repo is built from them.

## 1. Comments

```lua
-- single line comment
--[[ multi
     line comment ]]
```

## 2. Variables

```lua
local x = 10            -- `local` = scoped to this file/block. Always use it.
local name = "ayu"     -- strings use "double" or 'single' quotes
local on = true        -- booleans: true / false
local nothing = nil    -- nil = absence of a value
```

`local` matters: without it a variable becomes global and can clash with other
plugins. In config code, almost everything is `local`.

## 3. Tables — the one data structure

A Lua **table** is both an array and a dictionary. This is 90% of nvim config.

```lua
-- list (array) style
local langs = { "go", "rust", "lua" }
print(langs[1])        -- "go"  (Lua indexes from 1, not 0!)

-- map (dictionary) style
local opts = {
  number = true,
  shiftwidth = 2,
}
print(opts.number)     -- true
print(opts["number"])  -- same thing

-- tables can nest and mix — this is what a "plugin spec" is:
local spec = {
  "folke/which-key.nvim",     -- a positional (array) entry
  event = "VeryLazy",         -- a named (map) entry
  opts = { preset = "modern" },
}
```

Keys with special characters use brackets:

```lua
local t = { ["yaml.ansible"] = true }   -- dot in the key → must bracket+quote
```

## 4. Functions

```lua
-- named
local function add(a, b)
  return a + b
end

-- anonymous (assigned to a variable or passed as an argument)
local square = function(n) return n * n end
```

You'll constantly see functions passed **as table values** — that's how you give
a plugin behavior:

```lua
keys = {
  {
    "<leader>cf",
    function() require("conform").format() end,  -- runs when key is pressed
    desc = "Format buffer",
  },
}
```

## 5. `require` — loading other files

`require("config.options")` loads `lua/config/options.lua`. Dots = folders.
A file "returns" something (often a table), and `require` gives you that value:

```lua
-- lua/plugins/editor.lua
return { ... }                       -- this file hands back a plugin spec

-- init.lua
require("config.options")            -- runs that file for its side effects
```

The `.lua` extension and the `lua/` prefix are implied. `require("foo.bar")`
→ `lua/foo/bar.lua`.

## 6. The `vim` global — Neovim's API

`vim` is always available inside config. The parts you'll use:

| Call                         | What it does                                        |
| ---------------------------- | --------------------------------------------------- |
| `vim.opt.number = true`      | set an editor option (like `:set number`)           |
| `vim.g.mapleader = " "`      | set a global variable (leader key, plugin flags)    |
| `vim.bo.shiftwidth = 2`      | set a **buffer-local** option                        |
| `vim.keymap.set(...)`        | define a key mapping                                 |
| `vim.api.nvim_create_autocmd`| run code when an event fires                         |
| `vim.fn.expand("%")`         | call any classic Vimscript function from Lua        |
| `vim.cmd("colorscheme ayu")` | run a raw Vim command                               |

`vim.opt` vs `vim.o`: use `vim.opt` — it handles list/map options nicely
(e.g. `vim.opt.fillchars = { eob = " " }`).

## 7. Conditionals and `pcall`

```lua
if vim.bo.filetype == "go" then
  vim.bo.expandtab = false
end

-- pcall = "protected call": try something, don't crash if it errors.
-- Returns ok (bool) + the result. Used when a plugin might not be loaded yet.
local ok, cmp = pcall(require, "cmp")
if ok then
  -- safe to use cmp
end
```

## 8. String concatenation uses `..`

```lua
local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
```

---

### That's the whole language you need here

If you can read those eight sections, you can read every `.lua` file in this
repo. When you see something unfamiliar, it's almost always a **table being
passed to a plugin** — look up what that plugin expects, not new Lua syntax.

Next: **[02-nvim-config-structure.md](02-nvim-config-structure.md)**.
