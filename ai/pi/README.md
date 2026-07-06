# Pi

Repo-managed configuration for [Pi coding agent](https://pi.dev) lives here and is linked into
`$PI_CODING_AGENT_DIR` (`$XDG_STATE_HOME/pi/agent`). Runtime-owned auth, sessions,
packages, and settings stay in state.

## Files

- `models.json` registers the local OpenAI-compatible Ollama provider.
- `themes/sourdiesel.json` is the SourDiesel Pi theme used by interactive TUI sessions.
- `extensions/statusline.ts` is the custom SourDiesel statusline/turn-UI extension.

Bootstrap links Pi's runtime `$PI_CODING_AGENT_DIR/AGENTS.md` directly to
`../../../../.dotfiles/ai/AGENTS.md` from the agent dir; no harness-specific copy lives here.

## SourDiesel Markdown/code rendering v1

The Pi theme keeps Markdown headings and fenced command/code blocks aligned with the
terminal palette:

- Markdown heading colors mirror Neovim `render-markdown.nvim` and Glow's SourDiesel
  style: H1 `cyan`, H2 `magenta`, H3 `blue`, H4 `brightwhite`, H5 `BLACK_HEX`,
  and H6 `brightblack`. If render-markdown and Glow ever diverge, prefer
  render-markdown.
- `mdCodeBlock` uses `BLACK_HEX` (`#cccccc`) so unclassified shell text is neutral,
  not static green.
- Syntax tokens reuse the shared SourDiesel roles (`magenta` keywords, `blue`
  functions/commands, `green` strings, `brightblack` comments, etc.).
- `mdCodeBlockBorder` uses `brightblack` so fenced code renders as a single muted
  separator line.
- Turn sections and code blocks are intended to render with straight separator
  lines and no dark fill/background.

After Pi package updates, re-test fenced `bash`, `zsh`, `python`, unknown-language,
and no-language blocks because Markdown renderer behavior is package-owned while the
colors are repo-managed here.
