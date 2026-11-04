# Zed-like Neovim Config

A Neovim configuration that aims to feel like the [Zed](https://zed.dev) editor:
fast startup, a clean **Ayu Darker** theme, fuzzy file finder, command palette,
project panel, integrated terminal, inline diagnostics, autocomplete and
format-on-save — with language servers for **Go, Dart/Flutter, HTML, CSS, Rust
and C** wired up out of the box.

---

## Requirements

| Tool | Why | Install |
|------|-----|---------|
| **Neovim ≥ 0.11** | Uses the modern `vim.lsp.config` / `vim.lsp.enable` API | <https://github.com/neovim/neovim/releases> |
| **git** | Plugin manager clones plugins | your package manager |
| **A C compiler + `make`** | Builds Treesitter parsers & `fzf-native` | `build-essential` / `xcode-select --install` |
| **`ripgrep`** | Powers project-wide search (`live_grep`) | `brew install ripgrep` / `apt install ripgrep` |
| **`fd`** (optional) | Faster file finding | `brew install fd` / `apt install fd-find` |
| **A Nerd Font** | Icons in the UI (set it in your terminal) | run `./install-font.sh` (JetBrainsMono NL) |
| **Node.js** | Needed by `prettier` (HTML/CSS) and some LSPs | <https://nodejs.org> |

### Language toolchains

The language **servers** are installed automatically by [Mason](https://github.com/williamboman/mason.nvim)
on first launch (gopls, html, cssls, emmet, clangd, rust-analyzer) — but you
still need the underlying toolchains for them to be useful:

- **Go** — install Go: <https://go.dev/dl/>
- **Rust** — install via rustup (`rustup component add rust-analyzer clippy rustfmt`): <https://rustup.rs>
- **C** — a compiler + `clangd` (clangd is auto-installed by Mason)
- **Flutter / Dart** — install the Flutter SDK and make sure `flutter` and
  `dart` are on your `PATH`: <https://docs.flutter.dev/get-started/install>.
  The Dart language server (`dartls`) ships *with* the SDK, so it is **not**
  installed by Mason — `flutter-tools.nvim` finds it automatically.
- **HTML/CSS** — `prettier` (formatting) is auto-installed by Mason; it needs Node.js.

---

## Installation

Neovim loads its config from `$XDG_CONFIG_HOME/nvim` (usually `~/.config/nvim`).

### Option A — use this folder directly

```bash
# Back up any existing config first!
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# Symlink this folder in as your Neovim config
ln -s "$(pwd)" ~/.config/nvim

# Launch — plugins and language servers install on first run
nvim
```

### Option B — copy it in

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
cp -r . ~/.config/nvim
nvim
```

### Install the icon font

The UI uses Nerd Font glyphs. Install the JetBrainsMono NL Nerd Font with the
bundled script, then select it as your terminal's font:

```bash
./install-font.sh
```

It uses Homebrew on macOS when available, otherwise downloads the font from the
Nerd Fonts release and installs it to the right place for your OS (and refreshes
the font cache on Linux). The script prints how to set the font per terminal.

### First launch

On first launch, `lazy.nvim` bootstraps itself, downloads all plugins, then
Mason installs the language servers and formatters. Give it a minute, then
restart Neovim. Run `:checkhealth` to confirm everything is happy, and
`:Mason` to see installed tools.

> **Isolated test run** (doesn't touch your real config):
> ```bash
> NVIM_APPNAME=zednvim ln -s "$(pwd)" ~/.config/zednvim && NVIM_APPNAME=zednvim nvim
> ```

---

## Keybindings

**Leader key = `Space`.** Below, `<Space>` means tap the spacebar. Zed's real
shortcuts use **Cmd**, which most terminals can't send — so the primary
bindings here use `Space` / `Ctrl`, with the Zed equivalent noted. If your
terminal forwards Cmd (Ghostty/WezTerm/Kitty), the `<D-…>` maps (`<D-s>`,
`<D-w>`) also fire.

> **Discoverability:** press **`Space`** and wait — the which-key popup lists
> every binding under it. `<Space>k` opens a fuzzy, searchable list of *all*
> keymaps. `:checkhealth` verifies the setup.

### Files & navigation
| Key | Action | Zed |
|-----|--------|-----|
| `Ctrl-p` / `<Space>p` / `<Space><Space>` | Find files (fuzzy) | `Cmd+P` |
| `<Space>P` | Command palette | `Cmd+Shift+P` |
| `<Space>f` | Search across project (grep) | `Cmd+Shift+F` |
| `<Space>/` | Fuzzy-search current buffer | `Cmd+F` |
| `<Space>b` | List / switch open buffers | `Ctrl+Tab` |
| `<Space>r` | Recent files | |
| `<Space>h` | Search help docs | |
| `<Space>k` | Search all keymaps | |
| `Ctrl-b` / `<Space>t` | Toggle project panel | `Cmd+B` |
| `<Space>E` | Reveal current file in panel | `Cmd+Shift+E` |

### Project panel (neo-tree, when focused)
| Key | Action |
|-----|--------|
| `Enter` / `l` | Open file / expand folder |
| `h` | Collapse folder |
| `a` · `d` · `r` | Add · delete · rename |
| `P` | Toggle floating preview |
| `?` | Show all panel mappings |

### Buffers, windows & splits
| Key | Action | Zed |
|-----|--------|-----|
| `Shift-h` / `Shift-l` | Previous / next buffer | `Cmd+Shift+[ / ]` |
| `<Space>1` / `<Space>2` / `<Space>3` | Go to buffer 1 / 2 / 3 | |
| `<Space>w` | Close buffer | `Cmd+W` |
| `Ctrl-s` | Save | `Cmd+S` |
| `<Space>\` | Split right (vertical) | |
| `<Space>-` | Split down (horizontal) | |
| `Ctrl-h/j/k/l` | Move between splits | |

### Editing
| Key | Action | Zed |
|-----|--------|-----|
| `Alt-j` / `Alt-k` | Move line / selection down / up | `Alt+↓ / Alt+↑` |
| `gcc` / `Ctrl-/` | Toggle comment (line) | `Cmd+/` |
| `gc` (visual) | Toggle comment (selection) | `Cmd+/` |
| `Ctrl-d` | Add cursor at next occurrence | `Cmd+D` |
| `<` / `>` (visual) | Indent left / right, keep selection | |
| `Ctrl-Space` | Grow Treesitter selection | |
| `Backspace` | Shrink Treesitter selection | |
| `Esc` | Clear search highlight | |

### Autocomplete (insert mode)
| Key | Action |
|-----|--------|
| `Ctrl-Space` | Trigger completion |
| `Tab` / `Shift-Tab` | Next / previous item · jump snippet |
| `Enter` | Confirm selection |
| `Ctrl-e` | Dismiss popup |
| `Ctrl-f` / `Ctrl-b` | Scroll docs |
| `Ctrl-k` | Signature help |

### Code intelligence (LSP)
| Key | Action | Zed |
|-----|--------|-----|
| `gd` | Go to definition | `Cmd+Click` / `F12` |
| `gD` | Go to declaration | |
| `gr` | Find references | |
| `gI` | Go to implementation | |
| `gy` | Go to type definition | |
| `K` | Hover documentation | hover |
| `<Space>.` / `<Space>ca` | Code actions | `Cmd+.` |
| `<F2>` / `<Space>rn` | Rename symbol | `F2` |
| `<Space>cf` | Format buffer | `Cmd+Shift+I` |
| `<Space>o` | Document symbols (outline) | `Cmd+Shift+O` |
| `<Space>s` | Workspace symbols | `Cmd+T` |
| `<Space>d` | Project diagnostics list | |
| `<Space>e` | Line diagnostics (float) | |
| `[d` / `]d` | Previous / next diagnostic | |

> Formatting also runs **automatically on save**. Toggle it with
> `:FormatToggle` (global) or `:FormatToggle!` (current buffer only).

### Git
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous changed hunk |
| `<Space>gp` | Preview hunk |
| `<Space>gb` | Blame current line |
| `<Space>gs` / `<Space>gr` | Stage / reset hunk |

### Flutter (in `.dart` files)
| Key | Action |
|-----|--------|
| `<Space>Fr` | Run app |
| `<Space>Fh` | Hot reload |
| `<Space>FR` | Hot restart |
| `<Space>Fd` | Pick device |
| `<Space>Fe` | Pick emulator |
| `<Space>Fo` | Toggle widget outline |
| `<Space>Fq` | Quit running app |

### Rust (in `.rs` files)
| Key | Action |
|-----|--------|
| `<Space>rr` | Runnables |
| `<Space>rd` | Debuggables |

### Terminal
| Key | Action | Zed |
|-----|--------|-----|
| `Ctrl-\` / `<Space>j` | Toggle integrated terminal | `Ctrl+\`` |

---

## Project structure

```
.
├── init.lua                  # Entry point: sets leader, loads config modules
├── lua/
│   ├── config/
│   │   ├── options.lua        # Editor options (numbers, indent, diagnostics…)
│   │   ├── keymaps.lua        # Global, non-plugin keymaps
│   │   ├── autocmds.lua       # Autocommands (yank highlight, per-ft indent…)
│   │   └── lazy.lua           # Bootstraps lazy.nvim + loads lua/plugins
│   └── plugins/
│       ├── colorscheme.lua    # Themes: ayu-darker / pitch-black / monochrome + switcher
│       ├── treesitter.lua     # Syntax highlighting / indentation
│       ├── telescope.lua      # Fuzzy finder: files, grep, symbols, palette
│       ├── neo-tree.lua       # Project panel (file explorer)
│       ├── lsp.lua            # Mason + LSP: go, html, css, emmet, clangd
│       ├── rust.lua           # rustaceanvim (rust-analyzer)
│       ├── flutter.lua        # flutter-tools (dartls, hot reload)
│       ├── completion.lua     # nvim-cmp + LuaSnip autocomplete
│       ├── formatting.lua     # conform.nvim format-on-save
│       ├── ui.lua             # Statusline, tabs, breadcrumbs, git signs
│       ├── editor.lua         # which-key, comments, autopairs, multi-cursor…
│       └── terminal.lua       # toggleterm integrated terminal
└── README.md
```

### How it fits together

- **`lazy.nvim`** is the plugin manager. It reads every file in `lua/plugins/`,
  where each file returns a plugin spec (or a list of specs). Plugins are
  lazy-loaded on events/keys/filetypes for fast startup.
- **`mason.nvim`** + **`mason-tool-installer`** install the language servers and
  formatters automatically. See/trigger installs with `:Mason`.
- **`nvim-lspconfig`** connects the servers; keymaps attach per-buffer on the
  `LspAttach` event (defined in `lua/plugins/lsp.lua`).
- **`conform.nvim`** formats on save (toggle with `:FormatToggle`, or
  `:FormatToggle!` for just the current buffer).

---

## Customizing

- **Switch themes:** three are built in — **`ayu-darker`** (default),
  **`pitch-black`** (true `#000000` background, OLED-friendly) and
  **`monochrome`** (grayscale). Press **`<Space>ut`** for a picker, or run
  `:Theme pitch-black` / `:Theme monochrome` / `:Theme ayu-darker`. Your choice
  is remembered across restarts (stored in `stdpath('state')/theme.txt`).
- **Tweak a theme:** edit `lua/plugins/colorscheme.lua`. The Ayu-based themes
  share the `apply_ayu(bg, bg_float, cursorline, linenr)` helper — change those
  hex values, or set `mirage = true` for the lighter "Ayu Mirage" palette. Add
  your own entry to the `THEMES` table to register a new named theme.
- **Add a language server:** add it to the `servers` table and the
  `ensure_installed` list in `lua/plugins/lsp.lua`.
- **Add a formatter:** add it under `formatters_by_ft` in
  `lua/plugins/formatting.lua` (and to Mason's `ensure_installed` if needed).
- **Change keymaps:** global ones live in `lua/config/keymaps.lua`; plugin
  keymaps live in each plugin's `keys = { ... }` spec.

---

## Troubleshooting

- **`:checkhealth`** — the first thing to run; flags missing dependencies.
- **Icons look like boxes** — set a Nerd Font in your terminal profile.
- **`live_grep` finds nothing** — install `ripgrep`.
- **Treesitter / fzf-native fail to build** — install a C compiler and `make`.
- **Dart/Flutter server not starting** — ensure `flutter` is on your `PATH`
  (`flutter doctor`); `dartls` comes from the SDK, not Mason.
- **A server won't install** — open `:Mason`, find it, press `i` to install
  manually and read any error shown.
- **Reset plugins** — delete `~/.local/share/nvim/lazy` and relaunch.
