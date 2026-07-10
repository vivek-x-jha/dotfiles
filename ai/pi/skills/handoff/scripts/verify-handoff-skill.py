#!/usr/bin/env python3
"""Deterministic verifier: the handoff skill is structurally sound and harness-portable.

Resolves everything relative to this repo (Path(__file__).resolve().parents[1]), so it
runs anywhere — no soma/grok install required, and no external dependency of any kind.

Run with either launcher:
    python3 scripts/verify-handoff-skill.py
    uv run python scripts/verify-handoff-skill.py
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "SKILL.md",
    "workflows/Handoff.md",
    "references/template.md",
    "references/destinations.md",
    "references/claude-code.md",
    "references/codex.md",
    "references/pi.md",
    "references/grok.md",
]

# Core files that must NOT issue soma commands (soma is not a dependency).
# grok.md is exempt: it documents soma calls as explicitly-optional sugar.
SOMA_FREE_FILES = [
    "SKILL.md",
    "workflows/Handoff.md",
    "references/template.md",
    "references/destinations.md",
    "references/claude-code.md",
    "references/codex.md",
    "references/pi.md",
]
FORBIDDEN_SOMA_CMDS = ["soma session", "soma doctor", "soma lifecycle", "bun run soma"]

ASSERTIONS: list[tuple[str, str]] = []


def check(aid: str, ok: bool, detail: str) -> None:
    status = "PASS" if ok else "FAIL"
    ASSERTIONS.append((aid, status))
    print(f"{status} {aid}: {detail}")
    if not ok:
        raise AssertionError(f"{aid}: {detail}")


def read(rel: str) -> str:
    return (REPO / rel).read_text(encoding="utf-8")


def main() -> int:
    print("=== handoff skill verifier ===")
    print(f"repo: {REPO}\n")

    # A1: required file tree exists in this repo
    for rel in REQUIRED_FILES:
        check("A1", (REPO / rel).is_file(), f"repo has {rel}")

    skill = read("SKILL.md")
    workflow = read("workflows/Handoff.md")
    template = read("references/template.md")
    destinations = read("references/destinations.md")

    # A2: SKILL frontmatter contract — minimal, portable (name + description only)
    fm_match = re.match(r"---\n(.*?)\n---", skill, re.DOTALL)
    check("A2", fm_match is not None, "SKILL.md has closed YAML frontmatter")
    fm = fm_match.group(1) if fm_match else ""
    check("A2", "name: handoff" in fm, "frontmatter name: handoff")
    check("A2", "description:" in fm, "frontmatter description present")
    check("A2", "triggers:" not in fm, "no 'triggers:' field (invalid in Claude Code/Codex/Pi)")

    # A3: description enables auto-invocation across harnesses
    desc_match = re.search(r"description:\s*\|\s*\n((?:\s+.+\n)+)", skill)
    desc = desc_match.group(1) if desc_match else ""
    check("A3", len(desc) > 80, f"description length {len(desc)} > 80")
    check("A3", len(desc) < 1536, f"description length {len(desc)} < 1536 (Claude Code/Codex cap)")
    check("A3", "/handoff" in desc, "description mentions /handoff")

    # A4: goal-directed new-session intent (not in-place compaction)
    check("A4", "new, focused session" in skill, "states new focused session purpose")
    check("A4", "do not summarize the whole thread" in skill.lower(), "explicitly not compaction-style summary")

    # A5: distinguishes handoff from alternatives by FUNCTION (no harness-specific command names required)
    for needle in ("handoff", "compaction", "branch", "memory"):
        check("A5", needle in skill.lower(), f"'when to use' table covers {needle}")

    # A6: harness-portability is documented
    check("A6", "harness-agnostic" in skill.lower(), "declares harness-agnostic")
    for overlay in ("claude-code.md", "codex.md", "pi.md", "grok.md"):
        check("A6", overlay in skill, f"SKILL.md points at references/{overlay}")
    check("A6", "destinations.md" in skill, "SKILL.md names portable destinations fallback")

    # A7: soma is NOT a dependency — core files issue no soma commands
    for rel in SOMA_FREE_FILES:
        body = read(rel)
        for cmd in FORBIDDEN_SOMA_CMDS:
            check("A7", cmd not in body, f"{rel} contains no '{cmd}'")

    # A8: workflow covers parse, gather, write, deliver
    for step in ("Confirm goal", "Extract", "Compose document", "Write file", "Report to user"):
        check("A8", step in workflow, f"workflow includes '{step}'")

    # A9: mandatory deliverables in workflow
    check("A9", "Suggested skills" in workflow and "mandatory" in workflow.lower(), "suggested skills mandatory")
    check("A9", "Suggested first message" in workflow, "first message mandatory in workflow")

    # A10: template has required handoff sections
    for section in (
        "Suggested first message",
        "Current state",
        "COMPLETED",
        "IN PROGRESS",
        "NEXT",
        "BLOCKERS",
        "Artifacts",
        "Suggested skills",
        "Failed approaches",
    ):
        check("A10", section in template, f"template has '{section}'")

    # A11: portable destinations doc — per-OS temp + canonical first-message format
    check("A11", "agent-handoffs" in destinations, "agent-handoffs temp subdir documented")
    check("A11", "TMPDIR" in destinations and "TEMP" in destinations, "per-OS temp roots documented")
    check("A11", "Continue from" in destinations, "canonical first-message 'Continue from'")
    check("A11", "Read the handoff file in full first" in destinations, "first-message receiver contract")
    check("A11", "Key artifacts:" in destinations, "first-message key artifacts line")

    # A12: receiver contract + quality bar in SKILL.md
    check("A12", "FULL file" in skill, "receiver contract requires reading FULL file")
    check("A12", "forward-looking" in skill.lower(), "quality bar forward-looking")
    check("A12", "disposable" in skill.lower(), "quality bar disposable")
    check("A12", "do not duplicate" in skill.lower(), "no-duplication rule present")

    passed = sum(1 for _, s in ASSERTIONS if s == "PASS")
    print(f"\n=== ALL {passed} ASSERTIONS PASSED ===")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as e:
        print(f"\nVERIFIER FAILED: {e}", file=sys.stderr)
        passed = sum(1 for _, s in ASSERTIONS if s == "PASS")
        print(f"Passed {passed}/{len(ASSERTIONS)} before failure", file=sys.stderr)
        raise SystemExit(1)
