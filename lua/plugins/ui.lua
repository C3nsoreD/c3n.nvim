-- Statusline, buffer tabs, breadcrumbs and git signs — the chrome that makes
-- Neovim look and feel like Zed.
return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "ayu_dark",
        globalstatus = true,
        component_separators = "",
        section_separators = "",
        disabled_filetypes = { statusline = { "neo-tree" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Buffer tabs along the top (Zed's editor tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        show_buffer_close_icons = true,
        offsets = {
          { filetype = "neo-tree", text = "Project", highlight = "Directory", separator = true },
        },
      },
    },
  },

  -- Breadcrumbs / symbol path in the winbar (Zed's breadcrumb bar)
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = { theme = "auto", show_modified = true },
  },

  -- Git signs in the gutter (Zed's git diff indicators)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function m(l, r, desc)
          vim.keymap.set("n", l, r, { buffer = bufnr, desc = desc, silent = true })
        end
        m("]h", gs.next_hunk, "Next git hunk")
        m("[h", gs.prev_hunk, "Previous git hunk")
        m("<leader>gp", gs.preview_hunk, "Preview hunk")
        m("<leader>gb", gs.blame_line, "Blame line")
        m("<leader>gr", gs.reset_hunk, "Reset hunk")
        m("<leader>gs", gs.stage_hunk, "Stage hunk")
      end,
    },
  },
}
