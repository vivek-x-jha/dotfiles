# Pi

Repo-managed configuration for [Pi coding agent](https://pi.dev) lives here and is linked into
`$PI_CODING_AGENT_DIR` (`$XDG_STATE_HOME/pi/agent`). Runtime-owned auth, sessions,
packages, and settings stay in state.

## Files

- `keybindings.json` adds Ctrl+N/P menu navigation and Ctrl+Alt session-picker toggles.
- `models.json` registers the local OpenAI-compatible Ollama provider.
- `themes/sourdiesel.json` is the SourDiesel Pi theme used by interactive TUI sessions.
- `extensions/statusline.ts` is the custom SourDiesel statusline/turn-UI extension.
- `extensions/thread-title.ts` keeps the terminal and Herdr pane title aligned with
  the current Pi session name.
- `extensions/herdr-agent-state.ts` is the tracked copy of Herdr's managed Pi
  integration. `herdr integration install pi` updates it through the runtime symlink.
- `extensions/web-search.ts` enables OpenAI's native Responses `web_search` tool for
  `openai-codex` models and asks models to cite sources and distrust web content.
- `skills/handoff/` creates goal-focused session handoffs and copies the suggested
  first message to the clipboard when a supported clipboard command is available.
- `extensions/handoff-alias.ts` exposes that skill as `/handoff <goal>` in addition
  to Pi's standard `/skill:handoff <goal>` command.
- `prompts/ship.md` exposes `/ship [scope or instructions]` to verify, commit, and
  push the intended changes without including unrelated dirty work.
- Ponytail is installed as a Pi runtime package rather than vendored here. It reads the
  shared `$XDG_CONFIG_HOME/ponytail/config.json` seeded from `ai/ponytail/config.json`,
  and its status is rendered by the custom footer through Pi's extension-status API.

Bootstrap links Pi's runtime `$PI_CODING_AGENT_DIR/AGENTS.md` directly to
`../../../../.dotfiles/ai/AGENTS.md` from the agent dir; no harness-specific copy lives here.

## Chat navigation

The statusline/turn-UI extension selects one jump-to-latest shortcut by Pi's host
platform, and Pi's jump label shows only that shortcut:

| Platform | Shortcut |
| --- | --- |
| macOS | Ctrl+Option+G |
| Windows / Linux (including WSL) | Ctrl+End |

This jumps to the latest message and follows new output in fullscreen mode.
Clicking the label also works. Run `/reload` to apply changes to an active session.
The extension updates the action's default, so JSON reloads retain the platform
choice without writing platform-specific values into the shared `keybindings.json`.
Platform means where Pi runs: an SSH session on Linux uses Ctrl+End even from a Mac.

## Menu keybindings

| Shortcut | Action |
| --- | --- |
| Ctrl+N / Down | Move selection down |
| Ctrl+P / Up | Move selection up |
| Ctrl+Alt+P | Toggle paths in the session picker |
| Ctrl+Alt+N | Toggle named-only sessions in the session picker |

These also apply to the startup `pi -r` picker. Navigation uses Pi's shared menu
selection actions; existing editor/model shortcuts are otherwise unchanged.
Run `/reload` for an active session, or reopen `pi -r`. On macOS, Alt is Option.
These toggle shortcuts avoid Ctrl+Shift+N/P, which WezTerm intercepts. Control+Option
is also VoiceOver's default modifier, so choose other toggle keys if using VoiceOver.

Check the bindings with `node ai/pi/tests/keybindings.mjs` from the dotfiles root.

## SourDiesel Markdown/code rendering v2

Markdown presentation is automatic and inline, while replies stream and after they
finish. Run `/reload` once in an existing session to pick up changes; no reader
command, pager, Glow dependency, or Pi package-file patch is needed. The existing
`extensions/statusline.ts` extension owns the rendering changes:

- All six heading levels render without source `#` markers; H1 remains underlined.
- Code panels show a muted language caption and blank footer instead of backtick
  fences. Literal backticks, hashes, and Markdown examples **inside** code stay intact.
- Assistant lists use bullets and task checkboxes with aligned continuation lines.
  Submitted user lists retain their explicitly typed numbering/markers.
- Tables keep Pi's grid when it fits; very narrow panes show stacked labeled fields
  instead of falling back to raw Markdown pipes.
- Completed final answers get the same muted horizontal separator as tool calls,
  followed by a subtly lighter `#2e3045` background across the answer's full width,
  including blank lines and margins. Code/tool surfaces retain `#27283a` (or the
  existing `NVIM_STATUSLINE_HEX` override), including code nested inside the answer.
  Thinking stays outside the panel. The panel appears only
  after a successful, tool-free response completes; streaming commentary, tool turns,
  aborted/error/truncated replies, and empty answers do not get a final-answer panel.
- Native emphasis, inline code, links, quotes, rules, syntax highlighting, and
  supported math remain intact. Resizing, theme changes, and resumed messages use
  the same renderer; no final-answer duplication or extra model call occurs.

Only the display changes: message text, session history, model context, and cached
Markdown tokens remain original. Selecting terminal text copies the rendered view,
not necessarily the source Markdown. This is still terminal rendering, not a browser:
fonts stay fixed-size and arbitrary HTML/CSS or unsupported math keep Pi's native
fallback behavior.

The extension decorates Pi's internal token/list renderer **in memory**, alongside
its existing UI patches, because Pi has no supported assistant-renderer replacement
API. Reloads do not stack these decorators. Re-test after Pi upgrades (last verified
with Pi 1.4.0 on 2026-11-01); disabling/removing the extension requires restarting Pi
to clear its prototype patches. `/statusline off` toggles only the footer.

The Pi theme keeps Markdown headings and command/code blocks aligned with the
terminal palette:

- Markdown headings use `mdHeading: cyan`. Pi 1.2.0 rejects unsupported color
  keys such as `mdHeading1`–`mdHeading6`, preventing the entire theme from loading.
  Keep only Pi-supported tokens under `colors`; put reusable custom colors in `vars`.
- `mdCodeBlock` uses `BLACK_HEX` (`#cccccc`) so unclassified shell text is neutral,
  not static green.
- Syntax tokens reuse the shared SourDiesel roles (`magenta` keywords, `blue`
  functions/commands, `green` strings, `brightblack` comments, etc.).
- `mdCodeBlockBorder` uses `brightblack` for the code panel's language caption.
- Tool headers and intermediate turn sections remain unfilled with muted separators;
  completed final-answer text uses its distinct, lighter surface.
- Fenced code blocks use the SourDiesel `nvim_statusline` surface (`#27283a`, from
  `NVIM_STATUSLINE_HEX` when set). The background fills the code area, including
  language captions, wrapped lines, blank code lines, and right padding; surrounding
  prose and message margins remain transparent except in completed final-answer
  panels. Syntax foreground colors are
  unchanged. This is a Markdown token-renderer patch, not an unsupported theme key.
- The same surface shades write-file previews, expanded read-file contents, edit
  diffs, and the entire command/script preview in Bash calls, regardless of language.
  Native components retain their syntax/diff colors, preview limits, expansion
  controls, and caches. Tool headers, truncation hints, errors, image captions, and
  Bash stdout/stderr stay unfilled. These decorators depend on Pi's native preview
  layout, so rerun the tool-surface tests after Pi package updates.
- Submitted user messages use a brightblue `>>>` prompt and neutral black text;
  continuation lines align under the message, without a rail or user icon.
- Bash calls use Pi's renderer API so multiline commands are fully styled, without
  leftover copies of the native command preview. Python heredocs and literal
  `python -c` / `python3 -c` bodies use the active theme's Python syntax colors.
  Ordinary shell text keeps its shell/path colors; stdout/stderr and execution are
  unchanged. Complex heredoc redirects, concatenated shell quotes, and inline code
  with shell expansions fall back to shell styling rather than guessing.
- Bash tool previews and fenced `bash`, `sh`, and `shell` blocks break after parsed
  `&&`, `||`, `|`, and `|&` operators, with two-space continuation indentation.
  This changes display only: execution arguments, Markdown source/cached tokens,
  file previews, stdout/stderr, quoted text, substitutions, and heredoc contents
  are preserved. Existing line breaks/continuations and pending heredoc headers
  retain their layout. The formatter uses the already-managed `shfmt` parser, not
  shell execution or regex replacement. Results are cached and parsing is bounded;
  missing `shfmt`, incomplete/invalid syntax, or oversized input keeps the original
  preview rather than blocking or guessing.

After Pi package updates, re-test fenced `bash`, `zsh`, `python`, unknown-language,
and no-language blocks because Markdown renderer behavior is package-owned while the
colors are repo-managed here.

Run these rendering checks from the dotfiles root against the globally installed Pi:

```sh
node ai/pi/tests/user-message.mjs
node ai/pi/tests/bash-python.mjs
node ai/pi/tests/code-blocks.mjs
node ai/pi/tests/markdown-presentation.mjs
node ai/pi/tests/tool-code-surfaces.mjs
node ai/pi/tests/shell-preview.mjs
```

They cover wrapping, colors, narrow widths, shell-integration markers, reload safety,
Python heredocs/inline code, fallback cases, unchanged output, code-block backgrounds,
nested/streamed fences, literal Markdown in code, all heading levels, task-list
indentation, narrow tables, complete streamed responses, source preservation,
tool preview backgrounds, final-answer separators/surfaces, unchanged thinking click
targets, distinct answer/code colors, migration from the original panel on `/reload`,
ANSI resets, and theme changes.
The shell-preview suite also checks unchanged shell syntax trees, UTF-8 offsets,
protected syntax, fallback/caching, and display-only formatting; it requires `shfmt`.
Fixtures are rendered/parsed only; Python and shell fixture commands are never executed.
