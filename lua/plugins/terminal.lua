-- Integrated terminal (Zed's Cmd+J / Ctrl+` bottom panel).
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { [[<C-\>]], desc = "Toggle terminal" },
      { "<leader>j", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      size = 14,
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Make living inside the terminal comfortable:
      --   jk / <Esc><Esc> → leave terminal (insert) mode to normal mode
      --   <C-h/j/k/l>     → jump straight to another window
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function()
          local o = { buffer = 0, silent = true }
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], o)
          vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], o)
          vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], o)
          vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], o)
          vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], o)
          vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], o)
        end,
      })
    end,
  },
}
