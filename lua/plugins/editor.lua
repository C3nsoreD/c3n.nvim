-- Editing enhancements that give Zed-like ergonomics.
return {
  -- Which-key: popup that shows available keybindings (Zed's command hints).
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>F", group = "flutter" },
        { "<leader>r", group = "rust / rename / recent" },
        { "<leader>u", group = "ui / theme" },
      },
    },
  },

  -- Comment toggling (Zed Cmd+/): gcc / gc in visual mode.
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Auto-close brackets, quotes, tags.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
      -- integrate with nvim-cmp so pairs are added on confirm
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
      end
    end,
  },

  -- Auto-rename/close HTML tags (handy for html/css work).
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml" },
    opts = {},
  },

  -- Indent guides (Zed shows indent scope lines).
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "▏" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  -- Highlight TODO/FIXME/NOTE comments.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Multi-cursor editing (Zed Cmd+D to select next occurrence).
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>", -- Zed Cmd+D equivalent
      }
    end,
  },
}
