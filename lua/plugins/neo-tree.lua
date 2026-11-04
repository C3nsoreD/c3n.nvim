-- Neo-tree = Zed's Project Panel (the file explorer on the left).
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    -- Disable netrw entirely and open neo-tree when nvim is launched on a
    -- directory (e.g. `nvim .`), so it behaves like Zed opening a project.
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      if vim.fn.argc(-1) == 1 then
        local arg = vim.fn.argv(0)
        local stat = (vim.uv or vim.loop).fs_stat(arg)
        if stat and stat.type == "directory" then
          require("lazy").load({ plugins = { "neo-tree.nvim" } })
        end
      end
    end,
    keys = {
      -- Zed Cmd+B toggles the project panel; Cmd+Shift+E reveals current file.
      { "<C-b>", "<cmd>Neotree toggle<cr>", desc = "Toggle project panel" },
      { "<leader>t", "<cmd>Neotree toggle<cr>", desc = "Toggle project panel" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal current file" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        -- Take over directory buffers (so `nvim .` lands in neo-tree, not netrw).
        hijack_netrw_behavior = "open_current",
        bind_to_cwd = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        width = 32,
        mappings = {
          ["<cr>"] = "open",
          ["<Esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
        git_status = {
          symbols = {
            added = "+", modified = "~", deleted = "✗", renamed = "➜",
            untracked = "?", ignored = "◌", unstaged = "✗", staged = "✓", conflict = "!",
          },
        },
      },
    },
  },
}
