# Neovim

This is a personal Neovim configuration managed from `~/.dotfiles/editors/nvim`
and symlinked to `~/.config/nvim` by `bootstrap.sh`.

It uses Neovim's native `vim.pack`, a local statusline module, SourDiesel theme
integration, and XDG state paths.

## Startup Flow

`init.lua` is the startup orchestrator:

1. Read the inherited `NVIM_LOG_FILE` from the launch environment.
2. Select `vim.g.ui_theme`.
3. Configure core options, diagnostics, and language servers inline.
4. Register plugin sources with `vim.pack.add`.
5. Configure plugins inline and through `lua/plugins/`.
6. Register autocommands from `lua/autocmds.lua`.
7. Register user commands from `lua/usercmds.lua`.
8. Initialize the local statusline.
9. Apply the selected UI colorscheme and local highlights.
10. Defer keymaps from `lua/keymaps.lua` to the next event loop.

## Layout

| Path | Purpose |
| --- | --- |
| `init.lua` | Startup order, core options, LSP setup, and plugin source registration |
| `lsp/*.lua` | Per-server LSP settings; `tsgo.lua` uses TypeScript 7's native LSP and `eslint.lua` uses `vscode-eslint-language-server` for JS/TS/React files |
| `after/syntax/{sh,zsh}.vim` | Shell syntax extensions for commands, control keywords, config builtins, and paths |
| `lua/autocmds.lua` | Autocommands |
| `lua/usercmds.lua` | Custom user commands |
| `lua/keymaps.lua` | Keymaps |
| `lua/workspace.lua` | Project-buffer discovery and root `Session.vim` synchronization |
| `lua/ui/statusline.lua` | Local statusline implementation |
| `lua/ui/icons.lua` | Shared icon table |
| `lua/ui/highlights/init.lua` | Active palette selector, colorscheme apply helper, and highlight groups |
| `lua/ui/highlights/sourdiesel.lua` | SourDiesel palette |
| `lua/ui/dashboard.lua` | Local dashboard implementation |
| `lua/ui/terminal.lua` | Local terminal helper |
| `colors/sourdiesel.lua` | Standard Neovim colorscheme entrypoint |
| `lua/types.lua` | LuaLS-only type annotations |
| `lua/plugins/` | Plugin configuration and custom `fzf-lua` pickers |
| `.luarc.json` | LuaLS workspace and diagnostics settings |
| `.stylua.toml` | StyLua formatting rules |
| `nvim-pack-lock.json` | Native `vim.pack` lockfile |

## Plugin Management

Plugins are registered directly in `init.lua` with `vim.pack.add`.

Common commands:

```vim
:lua vim.pack.update()
:lua vim.pack.del({ 'plugin-name' })
:PackList
:PackListInactive
```

Rules:

- Remove a plugin from `vim.pack.add` before deleting it with `vim.pack.del`.
- Keep plugin configuration in `lua/plugins/<plugin>.lua` when the file configures
  one plugin, for example `plugins/gitsigns.lua`.
- Use a broader module name only when it coordinates multiple plugins, for example
  `plugins/noice.lua` or `plugins/tree.lua`.

## Language Servers

`init.lua` enables every Lua config under `lsp/`. Bootstrap installs editor
tooling in `bootstrap/lib/tooling.sh`, including `typescript@7`, `eslint`,
`prettier`, and `vscode-langservers-extracted` through npm. Neovim launches
TypeScript 7's native `typescript-go` language server with `tsc --lsp --stdio`,
so the legacy `tsserver` bridge is not required.

The JS/TS stack is:

- `lsp/tsgo.lua` for native TypeScript/JavaScript language intelligence.
- `lsp/eslint.lua` for ESLint diagnostics and code actions.
- `conform.nvim` with `prettier` for JS/TS/React/JSON format-on-save.

## Completion

Completion is handled by `blink.cmp` in `lua/plugins/blink.lua`.

`blink.cmp` v2 requires both:

- `saghen/blink.cmp`
- `saghen/blink.lib`

The config calls:

```lua
blink.build():wait(60000)
```

and `lua/autocmds.lua` includes a `PackChanged` hook that rebuilds the native
fuzzy matcher after `blink.cmp` or `blink.lib` installs/updates.

## Workspace And Sessions

`lua/workspace.lua` keeps the root `Session.vim` aligned with the text files
that `edit-all` would load. It uses `fd` for discovery, `file` for MIME checks,
adds newly discovered files as buffers, and removes unmodified buffers whose
files were deleted.

Session synchronization is debounced after file writes, deletes, focus changes,
shell commands, and relevant `nvim-tree` filesystem events. Use `<leader>oo` to
run an immediate synchronization. `Session.vim` is intentionally ignored by Git.

## Shell Syntax Overrides

Files under `after/syntax/` extend Neovim's built-in shell syntax after the
standard syntax scripts load:

- `after/syntax/sh.vim` distinguishes command names, shell control keywords,
  and path-like values.
- `after/syntax/zsh.vim` additionally distinguishes Zsh configuration builtins
  such as `autoload`, `bindkey`, `zstyle`, and `zmodload`.
- `after/syntax/typescriptreact.vim` distinguishes TSX callables from ordinary
  identifiers so calls can match bat's blue callable styling without making
  every variable read blue.

The matching highlight groups are defined by the local SourDiesel theme. Files
without shell extensions that still use shell syntax, such as `cli/fzf/config`,
are assigned filetypes in `lua/autocmds.lua` so highlighting and shell LSPs stay
aligned with bat preview mappings.

## Dashboard

Blank startup is owned by the local dashboard in `lua/ui/dashboard.lua`.
`lua/autocmds.lua` skips opening `nvim-tree` for an empty unnamed buffer so the
dashboard can fill the initial window by itself. Dashboard buffers use window-
local chrome suppression for line numbers, relative numbers, signs, statuscolumn,
foldcolumn, wrapping, list chars, cursorline, and colorcolumn; the guard is
reapplied on dashboard filetype/window events to keep terminal-workspace startup
clean.

Dashboard content is rendered with virtual text and is centered against the
current window dimensions as closely as practical, including narrower split panes
created during terminal workspace setup.

## Statusline

The statusline is local to this repo in `lua/ui/statusline.lua`.

It is initialized from `init.lua` with:

```lua
vim.o.statusline = "%!v:lua.require('ui.statusline').setup()"
```

Do not add a separate statusline plugin unless there is a clear reason to make it
reusable outside this dotfiles repo.

## Theme And Icons

The visual system is split across:

- `colors/sourdiesel.lua` as the standard Neovim colorscheme entrypoint
- `vim.g.ui_theme` as the selected palette and colorscheme name
- `lua/ui/highlights/init.lua` as the active palette selector and local highlight applier
- `lua/ui/highlights/sourdiesel.lua` for the SourDiesel palette
- `nvim-web-devicons` overrides in `lua/plugins/webdevicons.lua`
- `nvim-tree` renderer settings in `lua/plugins/tree.lua`
- shared icon names in `lua/ui/icons.lua`

For icon/color consistency, treat `nvim-tree` as the visual source of truth and
make path-based pickers such as `fzf-lua` match that behavior where practical.

## Logs And State

The main Neovim log is standardized to:

```text
~/.local/state/nvim/nvim.log
```

Shell and macOS launch environments set `NVIM_LOG_FILE` before Neovim starts.
Agent-run headless commands must also pass it explicitly so core startup logs
stay under `$XDG_STATE_HOME/nvim/nvim.log`.

Other plugin logs may also exist under `~/.local/state/nvim/`.

## Troubleshooting

If `blink.cmp` warns that the Rust fuzzy matcher is unavailable:

```vim
:lua require('blink.cmp').build():wait(60000)
```

If a removed plugin still exists on disk:

```vim
:PackListInactive
:lua vim.pack.del({ 'plugin-name' })
```

If headless Neovim checks fail in a sandbox with `serverstart()` or ShaDa write
errors, verify the config with format/static checks first. Those errors usually
come from runtime directory or state-path restrictions, not from Lua syntax.
