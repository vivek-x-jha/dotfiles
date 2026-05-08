# Neovim

This is a personal Neovim configuration managed from `~/.dotfiles/editors/nvim`
and symlinked to `~/.config/nvim` by `bootstrap.sh`.

It uses Neovim's native `vim.pack`, a local statusline module, SourDiesel theme
integration, and XDG state paths.

## Startup Flow

`init.lua` is the startup orchestrator:

1. Set `NVIM_LOG_FILE` for interactive and headless launches.
2. Select `vim.g.ui_colorscheme`.
3. Load core options from `lua/opts.lua`.
4. Configure diagnostics and language servers through `lua/lsp.lua`.
5. Register plugin sources with `vim.pack.add`.
6. Configure plugins inline and through `lua/plugins/`.
7. Register autocommands from `lua/autocmds.lua`.
8. Register user commands from `lua/usercmds.lua`.
9. Initialize the local statusline.
10. Apply the selected UI colorscheme and local highlights.
11. Defer keymaps from `lua/keymaps.lua` to the next event loop.

## Layout

| Path | Purpose |
| --- | --- |
| `init.lua` | Startup order and plugin source registration |
| `lua/opts.lua` | Core editor options |
| `lua/lsp.lua` | LSP server enablement and shared LSP behavior |
| `lsp/*.lua` | Per-server LSP settings |
| `lua/autocmds.lua` | Autocommands |
| `lua/usercmds.lua` | Custom user commands |
| `lua/keymaps.lua` | Keymaps |
| `lua/ui/statusline.lua` | Local statusline implementation |
| `lua/ui/icons.lua` | Shared icon table |
| `lua/ui/highlights/init.lua` | Active palette selector, colorscheme apply helper, and highlight groups |
| `lua/ui/highlights/sourdiesel.lua` | SourDiesel palette |
| `lua/ui/dashboard.lua` | Local dashboard implementation |
| `lua/ui/terminal.lua` | Local terminal helper |
| `colors/sourdiesel.lua` | Standard Neovim colorscheme entrypoint |
| `lua/types.lua` | LuaLS-only type annotations |
| `lua/plugins/*.lua` | Plugin-specific configuration |
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
- `vim.g.ui_colorscheme` as the selected palette and colorscheme name
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

`init.lua` sets `NVIM_LOG_FILE` early so headless launches, including agent-run
checks, do not create stray `nvim.log` files in project directories.

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
