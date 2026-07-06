---
name: sourdiesel
description: Maintain and audit the SourDiesel color system in the dotfiles repo. Use when Codex needs to change palette values, add or align eva and Neovim web-devicon mappings, update a SourDiesel consumer, investigate color drift, regenerate the color inventory, or validate theme changes.
---

# SourDiesel

Keep the repo-native tool and manifest authoritative. Do not duplicate palette data or validation logic in this skill.

## Workflow

1. Work from the live dotfiles checkout, normally `~/.dotfiles`, and read its `AGENTS.md`.
2. Inspect `themes/sourdiesel/palette.toml`, the affected native consumer files, and current Git status before editing.
3. Make the smallest change that satisfies the request:
   - Change shared color values in `themes/sourdiesel/palette.toml` first, then update affected native mirrors or consumers.
   - For file or extension colors, update eva and web-devicons together when both define the mapping.
   - Add new consumers to the manifest; extend `themes/sourdiesel/tool.py` and its tests only when the existing parsers cannot represent them.
   - Add legacy exceptions only for intentional pre-existing outliers and include a concrete reason.
4. Never edit `themes/sourdiesel/README.md` by hand. Regenerate it with:

   ```sh
   python3 themes/sourdiesel/tool.py render
   ```

5. Validate the completed change:

   ```sh
   python3 -m unittest discover -s themes/sourdiesel -p 'test_*.py'
   python3 themes/sourdiesel/tool.py check
   ./bootstrap.sh --check
   git diff --check
   ```

6. Inspect the final diff and report any remaining manual verification. Do not stage, commit, or push unless the user requests it.

## Invariants

- Native application theme files remain hand-authored; the manifest governs them through validation.
- Palette mirrors in shell, WezTerm, Neovim, and Hammerspoon must match the manifest.
- eva extension colors take precedence over same-named exact-file entries when comparing with web-devicons, because web-devicons uses one override table for both.
- New or stale legacy color allowlist entries must fail validation.
- Treat the Terminal.app profile as a manual consumer because it stores archived NSColor values. Visually verify it after changing ANSI colors.
