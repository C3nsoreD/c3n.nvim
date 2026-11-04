-- ╭──────────────────────────────────────────────────────────╮
-- │  Zed-like Neovim configuration                             │
-- │  Theme: Ayu Darker · LSP: Go, Dart/Flutter, HTML, CSS,     │
-- │         Rust, C                                            │
-- ╰──────────────────────────────────────────────────────────╯

-- Leader keys must be set before plugins load.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
