# Project Template Guidance

- Before initializing or scaffolding a project, inspect `~/.local/share/templates` and reuse the matching stack template.
- Use the `bootstrap-project` skill when it is available.
- Compare template files with existing project files before applying them. Merge relevant settings and preserve project-specific configuration instead of overwriting files wholesale.
- Validate the resulting diff before considering project setup complete.

# Personal Skill Guidance

- When creating portable personal skills, default their source location to `~/.dotfiles/ai/codex/skills/<skill-name>` unless the user chooses another location.
- Use the `skill-creator` skill when available and validate every created skill.
- Dotfiles bootstrap discovers each child directory containing `SKILL.md` and links it into `$CODEX_HOME/skills`; do not duplicate the source directly in Codex runtime state.
- Preserve system, plugin, and independently installed skills outside this repo-managed source directory.
