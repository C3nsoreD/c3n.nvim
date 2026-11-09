# Troubleshooting — the commands that tell you what's wrong

When something misbehaves, don't guess — ask Neovim. These built-in commands
cover almost everything.

## General health

```vim
:checkhealth           " full diagnostic of core + every plugin
:checkhealth lazy      " just the plugin manager
:checkhealth mason     " tool installer + missing dependencies
:messages              " scrollback of notifications/errors you missed
```

## Plugins (lazy.nvim)

```vim
:Lazy                  " dashboard: what's installed, loaded, errored
:Lazy sync             " install missing + update + clean removed plugins
:Lazy reload <name>    " reload a single plugin after editing its spec
:Lazy log              " recent update log
:Lazy profile          " startup timing — find slow plugins
```

If you added a plugin file and nothing happened: run `:Lazy sync`, then restart.

## Tools (Mason)

```vim
:Mason                 " UI: install/uninstall servers & formatters (press 'i')
:MasonUpdate           " update the registry
:MasonLog              " why an install failed
```

If a formatter "isn't found", it's almost always not installed — check `:Mason`.

## LSP (language servers)

```vim
:LspInfo               " which servers are attached to THIS buffer (or :checkhealth vim.lsp)
:LspLog                " server logs when completion/diagnostics misbehave
:LspRestart            " restart the attached server(s)
```

No completion / no go-to-definition? Open a file of that language, run
`:LspInfo`. If nothing is attached, the server isn't installed (`:Mason`) or the
filetype isn't configured in `lua/plugins/lsp.lua`.

## Formatting (conform.nvim)

```vim
:ConformInfo           " which formatters apply to this file + are they found
```

File got reformatted unexpectedly on save?

1. `:ConformInfo` — see which formatter ran.
2. `:FormatToggle!` — disable auto-format for this buffer to confirm it's the cause.
3. Add a `.prettierignore` / `.editorconfig` / `.prettierrc` to the project, or
   remove the filetype from `formatters_by_ft`.
   (See **[formatting-fix-plan.md](formatting-fix-plan.md)**.)

## Treesitter (syntax highlighting / indent)

```vim
:TSUpdate               " update parsers
:checkhealth nvim-treesitter
:InspectTree            " view the syntax tree of the current buffer
```

## Keymaps

```vim
:map <key>              " what is bound to a key, e.g.  :map <leader>cf
:verbose map <key>      " ALSO shows which file defined it
```

Press `<leader>` (Space) and wait — which-key pops up the available follow-ups.

## General workflow when something breaks

1. `:messages` — did an error already print?
2. `:checkhealth` — broad scan.
3. Narrow to the subsystem: `:Lazy` / `:Mason` / `:LspInfo` / `:ConformInfo`.
4. Reproduce with auto behavior off (`:FormatToggle!`) to isolate the culprit.
5. It's a config repo under git — `git diff` / `git stash` to back out a change.

## Reset escape hatch

Because this is a git repo, you can always undo config changes:

```bash
git diff                       # see what changed
git checkout -- <file>         # discard changes to one file
git stash                      # park all changes, test a clean state
```
