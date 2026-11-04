-- General editor options tuned to feel like Zed.
local opt = vim.opt

-- UI
opt.number = true             -- line numbers
opt.relativenumber = true     -- relative numbers for quick motions
opt.cursorline = true         -- highlight current line
opt.signcolumn = "yes"        -- always show sign column (no text shift)
opt.termguicolors = true      -- 24-bit colors (needed for Ayu)
opt.showmode = false          -- mode is shown in the statusline instead
opt.scrolloff = 8             -- keep context around the cursor
opt.sidescrolloff = 8
opt.wrap = false              -- no soft wrap, like Zed's default
opt.fillchars = { eob = " " } -- hide the ~ on empty lines
opt.laststatus = 3            -- single global statusline
opt.cmdheight = 1
opt.pumheight = 12            -- max items in completion popup
opt.splitright = true         -- new vertical splits go right
opt.splitbelow = true         -- new horizontal splits go below

-- Indentation (Zed defaults: 4 spaces, auto-detected per language later)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files / performance
opt.undofile = true           -- persistent undo
opt.swapfile = false
opt.backup = false
opt.updatetime = 200          -- faster diagnostics / CursorHold
opt.timeoutlen = 400          -- which-key popup delay
opt.autoread = true

-- Behavior
opt.mouse = "a"               -- mouse support, like a GUI editor
opt.clipboard = "unnamedplus" -- share clipboard with the OS
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true            -- ask instead of failing on unsaved changes

-- Diagnostics display (inline, Zed-style)
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})
