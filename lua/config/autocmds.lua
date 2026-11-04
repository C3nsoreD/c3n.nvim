-- Autocommands for quality-of-life behavior.
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight text briefly when you yank it (Zed highlights copied regions).
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Return to the last cursor position when reopening a file.
autocmd("BufReadPost", {
  group = augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Language-specific indentation to match common conventions.
autocmd("FileType", {
  group = augroup("indent_by_ft", { clear = true }),
  pattern = { "go" },
  callback = function()
    vim.bo.expandtab = false -- Go uses tabs
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

autocmd("FileType", {
  group = augroup("indent_two_space", { clear = true }),
  pattern = { "html", "css", "scss", "dart", "json", "yaml", "lua" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})

-- Close some utility buffers with just `q`.
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "notify" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
