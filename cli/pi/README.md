# Pi

Repo-managed configuration for [Pi coding agent](https://pi.dev) lives here and is linked into
`$PI_CODING_AGENT_DIR` (`$XDG_STATE_HOME/pi/agent`). Runtime-owned auth, sessions,
packages, and settings stay in state.

## Files

- `AGENTS.md` is linked from `ai/AGENTS.md` as Pi's global instructions.
- `models.json` registers the local OpenAI-compatible Ollama provider.
- `themes/sourdiesel.json` is the SourDiesel Pi theme used by interactive TUI sessions.

## SourDiesel Markdown/code rendering v1

The Pi theme keeps fenced command/code blocks aligned with the terminal palette:

- `mdCodeBlock` uses `BLACK_HEX` (`#cccccc`) so unclassified shell text is neutral,
  not static green.
- Syntax tokens reuse the shared SourDiesel roles (`magenta` keywords, `blue`
  functions/commands, `green` strings, `brightblack` comments, etc.).
- `mdCodeBlockBorder` uses `tmux_unfocused_pane_border` (`color237`) to match the
  unfocused tmux pane border.
- Code block sections are intended to render with straight separator lines and no
  dark fill/background.

After Pi package updates, re-test fenced `bash`, `zsh`, `python`, unknown-language,
and no-language blocks because Markdown renderer behavior is package-owned while the
colors are repo-managed here.
