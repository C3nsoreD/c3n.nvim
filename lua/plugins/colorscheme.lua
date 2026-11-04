-- Themes. Default is Ayu Darker; "pitch-black" and "monochrome" are also
-- available. Switch with <leader>ut (or `:Theme <name>`); the choice is
-- remembered across restarts.
--
-- Available theme names: "ayu-darker", "pitch-black", "monochrome".

-- Where the last-used theme is remembered.
local THEME_FILE = vim.fn.stdpath("state") .. "/theme.txt"
local DEFAULT_THEME = "ayu-darker"

-- Apply the Ayu palette with a given background (used for both the default
-- "darker" look and the "pitch-black" variant).
local function apply_ayu(bg, bg_float, cursorline, linenr)
  require("ayu").setup({
    mirage = false, -- dark (darker) palette, not mirage
    terminal = true,
    overrides = function()
      return {
        Normal = { bg = bg },
        NormalNC = { bg = bg },
        NormalFloat = { bg = bg_float },
        SignColumn = { bg = bg },
        LineNr = { fg = linenr },
        CursorLineNr = { fg = "#e6b450", bold = true },
        CursorLine = { bg = cursorline },
        ColorColumn = { bg = cursorline },
        VertSplit = { fg = cursorline },
        WinSeparator = { fg = cursorline },
        Pmenu = { bg = bg_float },
        PmenuSel = { bg = "#1b2733" },
      }
    end,
  })
  vim.cmd.colorscheme("ayu")
end

-- Theme registry: name -> function that activates it.
local THEMES = {
  ["ayu-darker"] = function()
    apply_ayu("#0b0e14", "#0d1017", "#11151c", "#3d4752")
  end,
  ["pitch-black"] = function()
    -- True black background, OLED-friendly.
    apply_ayu("#000000", "#000000", "#0a0a0a", "#303030")
  end,
  ["monochrome"] = function()
    -- monochrome.nvim is lazy; make sure it's loaded before selecting it.
    pcall(function() require("lazy").load({ plugins = { "monochrome.nvim" } }) end)
    vim.cmd.colorscheme("monochrome")
  end,
}

local function set_theme(name, persist)
  local fn = THEMES[name]
  if not fn then
    vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.WARN)
    return
  end
  fn()
  if persist ~= false then
    pcall(function()
      local f = io.open(THEME_FILE, "w")
      if f then f:write(name); f:close() end
    end)
  end
end

local function read_saved_theme()
  local f = io.open(THEME_FILE, "r")
  if not f then return DEFAULT_THEME end
  local name = (f:read("*l") or ""):gsub("%s+", "")
  f:close()
  return THEMES[name] and name or DEFAULT_THEME
end

return {
  -- Ayu is the base (also powers "pitch-black"). Loads first so the UI is
  -- themed immediately at startup.
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      -- Apply whichever theme was last chosen (defaults to Ayu Darker).
      set_theme(read_saved_theme(), false)

      -- :Theme [name]  → with no arg, opens a picker.
      vim.api.nvim_create_user_command("Theme", function(opts)
        if opts.args ~= "" then
          set_theme(opts.args)
        else
          vim.ui.select(vim.tbl_keys(THEMES), { prompt = "Theme:" }, function(choice)
            if choice then set_theme(choice) end
          end)
        end
      end, {
        nargs = "?",
        complete = function() return vim.tbl_keys(THEMES) end,
        desc = "Switch colorscheme",
      })

      -- <leader>ut → theme picker
      vim.keymap.set("n", "<leader>ut", "<cmd>Theme<cr>", { desc = "Switch theme", silent = true })
    end,
  },

  -- Monochrome (grayscale) theme. Lazy-loaded; activated via the switcher.
  {
    "kdheepak/monochrome.nvim",
    lazy = true,
  },
}
