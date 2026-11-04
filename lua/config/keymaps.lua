-- Keymaps mirroring Zed's defaults as closely as a terminal allows.
-- Zed's modifier is Cmd on macOS; terminals usually can't send Cmd, so the
-- primary bindings use Ctrl + <leader> (Space). Where your terminal *can*
-- forward Cmd (e.g. Kitty/WezTerm/Ghostty with a keymap), the <D-...> maps
-- below also fire. See README for details.

local map = vim.keymap.set

local function nmap(lhs, rhs, desc)
  map("n", lhs, rhs, { desc = desc, silent = true })
end

-- ── File & window management ──────────────────────────────────────────
-- Save (Zed: Cmd+S)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file", silent = true })
map("n", "<D-s>", "<cmd>w<cr>", { desc = "Save file", silent = true })

-- Close buffer (Zed: Cmd+W)
nmap("<leader>w", "<cmd>bdelete<cr>", "Close buffer")
map("n", "<D-w>", "<cmd>bdelete<cr>", { desc = "Close buffer", silent = true })

-- Move between buffers / tabs (Zed: Cmd+Shift+[ / ])
nmap("<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
nmap("<S-l>", "<cmd>bnext<cr>", "Next buffer")

-- Split navigation (Zed: Cmd+K then arrows; here plain Ctrl+hjkl)
nmap("<C-h>", "<C-w>h", "Go to left window")
nmap("<C-j>", "<C-w>j", "Go to lower window")
nmap("<C-k>", "<C-w>k", "Go to upper window")
nmap("<C-l>", "<C-w>l", "Go to right window")

-- Splits
nmap("<leader>\\", "<cmd>vsplit<cr>", "Split right")
nmap("<leader>-", "<cmd>split<cr>", "Split down")

-- ── Editing niceties (Zed-style) ──────────────────────────────────────
-- Move lines up/down (Zed: Alt+Up / Alt+Down)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down", silent = true })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up", silent = true })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up", silent = true })

-- Indent and keep selection
map("v", "<", "<gv", { desc = "Indent left", silent = true })
map("v", ">", ">gv", { desc = "Indent right", silent = true })

-- Clear search highlight
nmap("<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

-- Comment toggle (Zed: Cmd+/) handled by Comment.nvim ('gcc'); add alias
map("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<C-_>", "gc", { desc = "Toggle comment", remap = true })
map("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })

-- Diagnostics navigation
nmap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
nmap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
nmap("<leader>e", vim.diagnostic.open_float, "Line diagnostics")

-- Note: LSP, Telescope, Neo-tree and terminal keymaps are defined next to
-- their plugin specs in lua/plugins/ so they only load when relevant.
