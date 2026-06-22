#!/usr/bin/env python3
"""Render and validate the SourDiesel palette inventory."""

from __future__ import annotations

import argparse
import re
import sys
import tomllib
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable


THEME_DIR = Path(__file__).resolve().parent
REPO_ROOT = THEME_DIR.parents[1]
MANIFEST_PATH = THEME_DIR / "palette.toml"
REPORT_PATH = THEME_DIR / "README.md"

HEX_RE = re.compile(r"#[0-9a-fA-F]{6}(?:[0-9a-fA-F]{2})?")
LUA_VALUE_RE = re.compile(r"^\s*([a-z][a-z0-9_]*)\s*=\s*['\"]([^'\"]+)['\"]")
LUA_THEME_RE = re.compile(r"\bthm\.([a-z][a-z0-9_]*)\b")
SHELL_HEX_RE = re.compile(r"^\s*export\s+([A-Z][A-Z0-9_]*)_HEX=['\"]([^'\"]+)['\"]")
ENV_HEX_RE = re.compile(r"\b([A-Z][A-Z0-9_]*)_HEX\b")
WEBDEVICON_RE = re.compile(
    r"^\s*\[['\"](.+?)['\"]\]\s*=.*?\bname\s*=\s*['\"](.+?)['\"]"
    r".*?\bcolor\s*=\s*thm\.([a-z][a-z0-9_]*)"
)
ANSI_NAMES = (
    "brightblack",
    "brightred",
    "brightgreen",
    "brightyellow",
    "brightblue",
    "brightmagenta",
    "brightcyan",
    "brightwhite",
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
)
ANSI_TOKEN_RE = re.compile(
    r"(?<![A-Za-z])("
    + "|".join(ANSI_NAMES)
    + r"|bright-(?:black|red|green|yellow|blue|magenta|cyan|white))(?![A-Za-z])",
    re.IGNORECASE,
)

MIRROR_ALIASES = {
    "terminal_surface": "wezterm_bg",
    "nvim_background": "nvim_bg",
}


@dataclass(frozen=True)
class Color:
    name: str
    hex: str
    role: str
    kind: str
    index: int | None = None


@dataclass(frozen=True)
class Usage:
    color: str
    role: str


@dataclass
class Inventory:
    usages: dict[str, dict[str, list[str]]]
    legacy: dict[str, set[str]]
    mappings: dict[str, dict[str, str]]
    errors: list[str]


def load_manifest(path: Path = MANIFEST_PATH) -> dict[str, Any]:
    with path.open("rb") as handle:
        return tomllib.load(handle)


def normalize_hex(value: str) -> str:
    value = value.lower()
    if not re.fullmatch(r"#[0-9a-f]{6}(?:[0-9a-f]{2})?", value):
        raise ValueError(f"invalid hex color: {value}")
    return value


def palette_colors(manifest: dict[str, Any]) -> list[Color]:
    ansi = [
        Color(name, normalize_hex(data["hex"]), data["role"], "ANSI", data["index"])
        for name, data in manifest["ansi"].items()
    ]
    ansi.sort(key=lambda color: color.index if color.index is not None else -1)
    extras = [
        Color(name, normalize_hex(data["hex"]), data["role"], "Extra")
        for name, data in manifest["extras"].items()
    ]
    return ansi + extras


def palette_maps(
    colors: Iterable[Color],
) -> tuple[dict[str, Color], dict[str, str], dict[int, str]]:
    by_name = {color.name: color for color in colors}
    by_hex = {color.hex: color.name for color in colors}
    by_index = {color.index: color.name for color in colors if color.index is not None}
    return by_name, by_hex, by_index


def expected_mirror_values(manifest: dict[str, Any]) -> dict[str, str]:
    expected = {
        name: normalize_hex(data["hex"])
        for section in ("ansi", "extras")
        for name, data in manifest[section].items()
    }
    expected.update(manifest.get("tokens", {}))
    return {MIRROR_ALIASES.get(name, name): value for name, value in expected.items()}


def validate_schema(manifest: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    if manifest.get("schema_version") != 1:
        errors.append("palette.toml: schema_version must be 1")

    try:
        colors = palette_colors(manifest)
    except (KeyError, TypeError, ValueError) as error:
        return [f"palette.toml: {error}"]

    ansi = [color for color in colors if color.kind == "ANSI"]
    indices = [color.index for color in ansi]
    if len(ansi) != 16 or sorted(indices) != list(range(16)):
        errors.append(
            "palette.toml: ANSI colors must define each index from 0 through 15 exactly once"
        )

    hexes = [color.hex for color in colors]
    if len(hexes) != len(set(hexes)):
        errors.append("palette.toml: palette hex values must be unique")

    consumer_ids = [consumer.get("id") for consumer in manifest.get("consumers", [])]
    if len(consumer_ids) != len(set(consumer_ids)):
        errors.append("palette.toml: consumer ids must be unique")

    for consumer in manifest.get("consumers", []):
        for key in ("id", "label", "group", "paths", "parser"):
            if not consumer.get(key):
                errors.append(f"palette.toml: consumer is missing {key}")
        allowed = consumer.get("allowed_hex", [])
        if allowed and not consumer.get("legacy_reason"):
            errors.append(
                f"palette.toml: {consumer.get('id', '<unknown>')} legacy colors need legacy_reason"
            )
        for value in allowed:
            try:
                normalize_hex(value)
            except ValueError as error:
                errors.append(
                    f"palette.toml: {consumer.get('id', '<unknown>')}: {error}"
                )
    return errors


def parse_lua_mirror(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = LUA_VALUE_RE.match(line)
        if match:
            values[match.group(1)] = match.group(2)
    return values


def parse_shell_mirror(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = SHELL_HEX_RE.match(line)
        if match:
            values[match.group(1).lower()] = match.group(2)
    return values


def validate_mirrors(manifest: dict[str, Any], root: Path = REPO_ROOT) -> list[str]:
    errors: list[str] = []
    expected = expected_mirror_values(manifest)
    for mirror in manifest.get("mirrors", []):
        path = root / mirror["path"]
        if not path.is_file():
            errors.append(f"{mirror['id']}: missing palette mirror {mirror['path']}")
            continue
        parser = mirror["parser"]
        if parser == "lua":
            actual = parse_lua_mirror(path)
        elif parser == "shell":
            actual = parse_shell_mirror(path)
        else:
            errors.append(f"{mirror['id']}: unknown mirror parser {parser}")
            continue
        for key, value in expected.items():
            if actual.get(key) != value:
                errors.append(
                    f"{mirror['id']}: {key} is {actual.get(key, '<missing>')}, expected {value}"
                )
    return errors


def is_comment_line(line: str) -> bool:
    stripped = line.lstrip()
    return stripped.startswith(("//", "<!--")) or (
        stripped.startswith("#") and not HEX_RE.match(stripped)
    )


def infer_role(line: str, line_number: int) -> str:
    patterns = (
        r"^\s*(?:\[['\"](.+?)['\"]\]|([@A-Za-z0-9_.-]+))\s*=",
        r"^\s*['\"]([^'\"]+)['\"]\s*:",
        r"theme\[([^\]]+)\]",
        r"ble-face\s+-s\s+([A-Za-z0-9_.-]+)",
        r"hs\.console\.([A-Za-z0-9_]+)",
    )
    for pattern in patterns:
        match = re.search(pattern, line)
        if match:
            return next(group for group in match.groups() if group is not None)
    return f"line {line_number}"


def resolve_hex(value: str, by_hex: dict[str, str]) -> str | None:
    normalized = normalize_hex(value)
    return by_hex.get(normalized) or by_hex.get(normalized[:7])


def scan_hex(paths: list[Path], by_hex: dict[str, str]) -> tuple[list[Usage], set[str]]:
    usages: list[Usage] = []
    unknown: set[str] = set()
    for path in paths:
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if is_comment_line(line):
                continue
            for match in HEX_RE.finditer(line):
                value = normalize_hex(match.group(0))
                color = resolve_hex(value, by_hex)
                if color:
                    usages.append(Usage(color, infer_role(line, number)))
                else:
                    unknown.add(value)
    return usages, unknown


def scan_lua(paths: list[Path], known_names: set[str]) -> list[Usage]:
    usages: list[Usage] = []
    for path in paths:
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if is_comment_line(line):
                continue
            for match in LUA_THEME_RE.finditer(line):
                color = match.group(1)
                canonical = "terminal_surface" if color == "wezterm_bg" else color
                canonical = "nvim_background" if canonical == "nvim_bg" else canonical
                if canonical in known_names:
                    usages.append(Usage(canonical, infer_role(line, number)))
    return usages


def scan_shell(paths: list[Path], known_names: set[str]) -> list[Usage]:
    usages: list[Usage] = []
    for path in paths:
        for line in path.read_text(encoding="utf-8").splitlines():
            match = SHELL_HEX_RE.match(line)
            if not match:
                continue
            name = match.group(1).lower()
            canonical = "terminal_surface" if name == "wezterm_bg" else name
            canonical = "nvim_background" if canonical == "nvim_bg" else canonical
            if canonical in known_names:
                usages.append(Usage(canonical, "palette export"))
    return usages


def scan_env(paths: list[Path], known_names: set[str]) -> list[Usage]:
    usages: list[Usage] = []
    for path in paths:
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if is_comment_line(line):
                continue
            for match in ENV_HEX_RE.finditer(line):
                name = match.group(1).lower()
                canonical = "terminal_surface" if name == "wezterm_bg" else name
                canonical = "nvim_background" if canonical == "nvim_bg" else canonical
                if canonical in known_names:
                    usages.append(Usage(canonical, infer_role(line, number)))
    return usages


def normalize_ansi_token(token: str, by_index: dict[int, str]) -> str | None:
    token = token.strip().strip("'\"").lower().replace("-", "")
    if token in ANSI_NAMES:
        return token
    if re.fullmatch(r"\d{1,2}", token):
        return by_index.get(int(token, 10))
    return None


def scan_ansi(paths: list[Path]) -> list[Usage]:
    usages: list[Usage] = []
    for path in paths:
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if is_comment_line(line):
                continue
            for match in ANSI_TOKEN_RE.finditer(line):
                color = normalize_ansi_token(match.group(1), {})
                if color:
                    usages.append(Usage(color, infer_role(line, number)))
    return usages


def yaml_key(line: str) -> tuple[int, str, str] | None:
    match = re.match(r"^(\s*)([^:#][^:]*):(?:\s*(.*))?$", line)
    if not match:
        return None
    indent = len(match.group(1))
    key = match.group(2).strip().strip("'\"")
    value = match.group(3).strip()
    return indent, key, value


def scan_eza(
    path: Path, by_index: dict[int, str]
) -> tuple[list[Usage], dict[str, str], list[str]]:
    usages: list[Usage] = []
    mappings: dict[str, str] = {}
    errors: list[str] = []
    stack: list[tuple[int, str]] = []
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        parsed = yaml_key(line)
        if not parsed:
            continue
        indent, key, value = parsed
        while stack and stack[-1][0] >= indent:
            stack.pop()
        parents = [item[1] for item in stack]
        if key == "foreground" and value:
            color = normalize_ansi_token(value.split()[0], by_index)
            if color:
                role = ".".join(parents) or f"line {number}"
                usages.append(Usage(color, role))
                if len(parents) >= 2 and parents[0] in {"filenames", "extensions"}:
                    mapping_key = f"{parents[0]}:{parents[1]}"
                    previous = mappings.get(mapping_key)
                    if previous and previous != color:
                        errors.append(
                            f"eza: {mapping_key} uses both {previous} and {color}"
                        )
                    mappings.setdefault(mapping_key, color)
            continue
        if not value:
            stack.append((indent, key))
    return usages, mappings, errors


def scan_webdevicons(
    path: Path, reserved_names: Iterable[str] = ()
) -> tuple[list[Usage], dict[str, str], list[str]]:
    usages: list[Usage] = []
    mappings: dict[str, str] = {}
    errors: list[str] = []
    reserved = {name.casefold() for name in reserved_names}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = WEBDEVICON_RE.match(line)
        if not match:
            continue
        key, name, color = match.groups()
        usages.append(Usage(color, key))
        mappings[key] = color
        if name.casefold() in reserved:
            errors.append(
                f"webdevicons: {key} uses reserved highlight name {name}; "
                "use a unique SourDiesel name"
            )
    return usages, mappings, errors


def build_inventory(manifest: dict[str, Any], root: Path = REPO_ROOT) -> Inventory:
    colors = palette_colors(manifest)
    by_name, by_hex, by_index = palette_maps(colors)
    known_names = set(by_name) | set(manifest.get("tokens", {}))
    usage_map: dict[str, dict[str, list[str]]] = {}
    legacy: dict[str, set[str]] = {}
    mappings: dict[str, dict[str, str]] = {}
    errors: list[str] = []

    for consumer in manifest.get("consumers", []):
        consumer_id = consumer["id"]
        paths = [root / relative for relative in consumer["paths"]]
        missing = [str(path.relative_to(root)) for path in paths if not path.is_file()]
        if missing:
            errors.extend(f"{consumer_id}: missing consumer {path}" for path in missing)
            usage_map[consumer_id] = {}
            continue

        parser = consumer["parser"]
        usages: list[Usage] = []
        unknown: set[str] = set()
        if parser == "hex":
            usages, unknown = scan_hex(paths, by_hex)
        elif parser == "lua":
            usages = scan_lua(paths, known_names)
        elif parser == "lua_env":
            usages = scan_lua(paths, known_names) + scan_env(paths, known_names)
        elif parser == "shell":
            usages = scan_shell(paths, known_names)
        elif parser == "env":
            usages = scan_env(paths, known_names)
        elif parser == "ansi":
            usages = scan_ansi(paths)
        elif parser == "eza":
            usages, mapping, scan_errors = scan_eza(paths[0], by_index)
            mappings[consumer_id] = mapping
            errors.extend(scan_errors)
        elif parser == "webdevicons":
            usages, mapping, scan_errors = scan_webdevicons(
                paths[0], consumer.get("reserved_highlight_names", [])
            )
            mappings[consumer_id] = mapping
            errors.extend(scan_errors)
        elif parser == "manual":
            usages = [
                Usage(color.name, "manual profile")
                for color in colors
                if color.kind == "ANSI"
            ]
        else:
            errors.append(f"{consumer_id}: unknown consumer parser {parser}")

        grouped: dict[str, list[str]] = defaultdict(list)
        for usage in usages:
            grouped[usage.color].append(usage.role)
        usage_map[consumer_id] = dict(grouped)

        allowed = {normalize_hex(value) for value in consumer.get("allowed_hex", [])}
        if unknown != allowed:
            added = sorted(unknown - allowed)
            stale = sorted(allowed - unknown)
            if added:
                errors.append(f"{consumer_id}: unapproved colors: {', '.join(added)}")
            if stale:
                errors.append(f"{consumer_id}: stale legacy colors: {', '.join(stale)}")
        if unknown:
            legacy[consumer_id] = unknown

    eza = mappings.get("eza", {})
    webdevicons = mappings.get("webdevicons", {})
    for key in sorted(webdevicons):
        eza_key = next(
            (
                candidate
                for candidate in (f"extensions:{key}", f"filenames:{key}")
                if candidate in eza
            ),
            None,
        )
        if eza_key and eza[eza_key] != webdevicons[key]:
            errors.append(
                f"eza/web-devicons: {key} is {eza[eza_key]} in eza and {webdevicons[key]} in web-devicons"
            )

    return Inventory(usage_map, legacy, mappings, errors)


def escape_cell(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ")


def compact_cell(roles: list[str] | None, manual: bool = False) -> str:
    if not roles:
        return "—"
    unique = list(dict.fromkeys(roles))
    if manual:
        return "manual"
    examples = ", ".join(escape_cell(role) for role in unique[:2])
    if len(examples) > 54:
        examples = examples[:51].rstrip() + "…"
    return f"{len(roles)} · {examples}"


def render_report(manifest: dict[str, Any], inventory: Inventory) -> str:
    colors = palette_colors(manifest)
    consumers = manifest["consumers"]
    lines = [
        "# SourDiesel color inventory",
        "",
        "<!-- Generated by themes/sourdiesel/tool.py from palette.toml. Do not edit directly. -->",
        "",
        "`palette.toml` is the source of truth for shared colors. Application-native files remain",
        "hand-authored and are checked against this inventory by `./bootstrap.sh --check`.",
        "",
        "## Palette",
        "",
        "| Kind | Slot | Name | Hex | Intended role |",
        "| --- | ---: | --- | --- | --- |",
    ]
    for color in colors:
        slot = str(color.index) if color.index is not None else "—"
        lines.append(
            f"| {color.kind} | {slot} | `{color.name}` | `{color.hex}` | {color.role} |"
        )

    lines.extend(["", "## Non-color tokens", "", "| Name | Value |", "| --- | --- |"])
    for name, value in manifest.get("tokens", {}).items():
        lines.append(f"| `{name}` | `{value}` |")

    groups = list(dict.fromkeys(consumer["group"] for consumer in consumers))
    for group in groups:
        group_consumers = [
            consumer for consumer in consumers if consumer["group"] == group
        ]
        lines.extend(["", f"## {group}", ""])
        header = (
            "| Color | "
            + " | ".join(consumer["label"] for consumer in group_consumers)
            + " |"
        )
        divider = "| --- | " + " | ".join("---" for _ in group_consumers) + " |"
        lines.extend([header, divider])
        for color in colors:
            cells = []
            for consumer in group_consumers:
                roles = inventory.usages.get(consumer["id"], {}).get(color.name)
                cells.append(compact_cell(roles, consumer["parser"] == "manual"))
            lines.append(f"| `{color.name}` | " + " | ".join(cells) + " |")

    lines.extend(["", "## File and icon mappings", ""])
    for consumer_id, label in (("eza", "eza"), ("webdevicons", "web-devicons")):
        mapping = inventory.mappings.get(consumer_id, {})
        lines.extend(
            [
                f"<details><summary>{label}: {len(mapping)} colored mappings</summary>",
                "",
            ]
        )
        grouped: dict[str, list[str]] = defaultdict(list)
        for key, color in mapping.items():
            grouped[color].append(key)
        for color in colors:
            keys = sorted(grouped.get(color.name, []), key=str.casefold)
            if keys:
                rendered = ", ".join(f"`{escape_cell(key)}`" for key in keys)
                lines.append(f"- `{color.name}` ({len(keys)}): {rendered}")
        lines.extend(["", "</details>", ""])

    lines.extend(["## Legacy outliers", ""])
    if inventory.legacy:
        lines.extend(["| Consumer | Allowed colors | Reason |", "| --- | --- | --- |"])
        consumers_by_id = {consumer["id"]: consumer for consumer in consumers}
        for consumer_id in sorted(inventory.legacy):
            consumer = consumers_by_id[consumer_id]
            values = ", ".join(
                f"`{value}`" for value in sorted(inventory.legacy[consumer_id])
            )
            lines.append(
                f"| {consumer['label']} | {values} | {escape_cell(consumer['legacy_reason'])} |"
            )
    else:
        lines.append("None.")

    manual = [consumer for consumer in consumers if consumer["parser"] == "manual"]
    lines.extend(["", "## Manual consumers", ""])
    for consumer in manual:
        paths = ", ".join(f"`{path}`" for path in consumer["paths"])
        lines.append(f"- {consumer['label']} ({paths}): {consumer['manual_note']}.")
    return "\n".join(lines).rstrip() + "\n"


def check_report(expected: str, path: Path = REPORT_PATH) -> list[str]:
    if not path.is_file():
        return [f"generated report is missing: {path}"]
    if path.read_text(encoding="utf-8") != expected:
        return [
            f"generated report is stale: run {Path(__file__).relative_to(REPO_ROOT)} render"
        ]
    return []


def run_check(
    manifest: dict[str, Any], root: Path = REPO_ROOT, report: Path = REPORT_PATH
) -> list[str]:
    errors = validate_schema(manifest)
    errors.extend(validate_mirrors(manifest, root))
    inventory = build_inventory(manifest, root)
    errors.extend(inventory.errors)
    if not errors:
        errors.extend(check_report(render_report(manifest, inventory), report))
    return errors


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("check", "render"))
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    manifest = load_manifest()
    schema_errors = validate_schema(manifest)
    if schema_errors:
        for error in schema_errors:
            print(f"error: {error}", file=sys.stderr)
        return 1

    mirror_errors = validate_mirrors(manifest)
    inventory = build_inventory(manifest)
    errors = mirror_errors + inventory.errors
    if errors:
        for error in errors:
            print(f"error: {error}", file=sys.stderr)
        return 1

    report = render_report(manifest, inventory)
    if args.command == "render":
        REPORT_PATH.write_text(report, encoding="utf-8")
        print(f"updated: {REPORT_PATH.relative_to(REPO_ROOT)}")
        return 0

    report_errors = check_report(report)
    if report_errors:
        for error in report_errors:
            print(f"error: {error}", file=sys.stderr)
        return 1
    print(f"ok: {MANIFEST_PATH.relative_to(REPO_ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
