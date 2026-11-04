-- Telescope = Zed's Cmd+P file finder, Cmd+Shift+P command palette and
-- Cmd+Shift+F project search, all in one fuzzy finder.
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native fzf sorter for speed (requires `make`, falls back gracefully).
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function()
        return vim.fn.executable("make") == 1
      end },
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      -- Zed Cmd+P  → find files
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      -- Zed Cmd+Shift+P → command palette
      { "<leader>P", "<cmd>Telescope commands<cr>", desc = "Command palette" },
      -- Zed Cmd+Shift+F → project-wide search
      { "<leader>f", "<cmd>Telescope live_grep<cr>", desc = "Search in project" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
      -- Zed Ctrl+Tab → recent / open buffers
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Open buffers" },
      -- Zed Cmd+T → project symbols
      { "<leader>s", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>o", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols (outline)" },
      -- Extras
      { "<leader>d", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics list" },
      { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>h", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>k", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    },
    -- opts is a function so `require("telescope.actions")` runs at load time,
    -- not while lazy.nvim is first collecting specs at startup.
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
            horizontal = { preview_width = 0.55 },
          },
          file_ignore_patterns = {
            "%.git/", "node_modules/", "%.dart_tool/", "build/", "target/", "%.o$",
          },
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
