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
  },
}
