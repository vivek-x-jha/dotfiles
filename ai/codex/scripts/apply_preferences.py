#!/usr/bin/env python3
"""Apply repo-managed Codex UI preference keys without replacing config.toml."""

from __future__ import annotations

import re
import sys
from pathlib import Path


SECTION_RE = re.compile(r"^\s*\[([^\]]+)\]\s*(?:#.*)?$")
KEY_RE = re.compile(r"^\s*([A-Za-z0-9_-]+)\s*=")


def parse_fragment(path: Path) -> tuple[list[str], dict[str, list[str]], dict[str, set[str]]]:
    section = ""
    order: list[str] = []
    lines_by_section: dict[str, list[str]] = {}
    keys_by_section: dict[str, set[str]] = {}

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.rstrip()
        match = SECTION_RE.match(line)
        if match:
            section = match.group(1)
            if section not in lines_by_section:
                order.append(section)
                lines_by_section[section] = []
                keys_by_section[section] = set()
            continue

        key_match = KEY_RE.match(line)
        if section and key_match:
            lines_by_section[section].append(line)
            keys_by_section[section].add(key_match.group(1))

    return order, lines_by_section, keys_by_section


def apply_preferences(config_path: Path, fragment_path: Path) -> bool:
    order, managed_lines, managed_keys = parse_fragment(fragment_path)
    source_lines = (
        config_path.read_text(encoding="utf-8").splitlines()
        if config_path.exists()
        else []
    )

    output: list[str] = []
    seen_sections: set[str] = set()
    inserted_sections: set[str] = set()
    current_section = ""

    def flush(section: str) -> None:
        if section in managed_lines and section not in inserted_sections:
            if output and output[-1] != "" and not SECTION_RE.match(output[-1]):
                output.append("")
            output.extend(managed_lines[section])
            inserted_sections.add(section)

    for line in source_lines:
        section_match = SECTION_RE.match(line)
        if section_match:
            flush(current_section)
            current_section = section_match.group(1)
            seen_sections.add(current_section)
            output.append(line)
            continue

        if (
            current_section in managed_lines
            and current_section not in inserted_sections
            and line.strip() == ""
            and output
            and SECTION_RE.match(output[-1])
        ):
            continue

        key_match = KEY_RE.match(line)
        if (
            current_section in managed_keys
            and key_match
            and key_match.group(1) in managed_keys[current_section]
        ):
            continue

        output.append(line)

    flush(current_section)

    for section in order:
        if section in seen_sections:
            continue
        if output and output[-1] != "":
            output.append("")
        output.append(f"[{section}]")
        output.extend(managed_lines[section])

    new_text = "\n".join(output).rstrip() + "\n"
    old_text = config_path.read_text(encoding="utf-8") if config_path.exists() else ""
    if new_text == old_text:
        return False

    config_path.parent.mkdir(parents=True, exist_ok=True)
    tmp_path = config_path.with_suffix(config_path.suffix + ".tmp")
    tmp_path.write_text(new_text, encoding="utf-8")
    tmp_path.replace(config_path)
    return True


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: apply_preferences.py <config.toml> <preferences-fragment.toml>", file=sys.stderr)
        return 2

    config_path = Path(sys.argv[1]).expanduser()
    fragment_path = Path(sys.argv[2]).expanduser()

    changed = apply_preferences(config_path, fragment_path)
    print(("updated" if changed else "unchanged") + f": {config_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
