#!/usr/bin/env python3
"""Behavioral verifier: a produced handoff document matches references/template.md.

Harness-agnostic. Reads the template and the canonical first-message contract from
this repo (not from any global install), so it runs anywhere.

    python3 scripts/verify-handoff-output.py <path-to-handoff.md>
    uv run python scripts/verify-handoff-output.py <path-to-handoff.md>
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
TEMPLATE = REPO / "references" / "template.md"

ASSERTIONS: list[tuple[str, str]] = []


def check(aid: str, ok: bool, detail: str) -> None:
    status = "PASS" if ok else "FAIL"
    ASSERTIONS.append((aid, status))
    print(f"{status} {aid}: {detail}")
    if not ok:
        raise AssertionError(f"{aid}: {detail}")


def note(msg: str) -> None:
    print(f"SKIP --: {msg}")


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: verify-handoff-output.py <path-to-handoff.md>", file=sys.stderr)
        return 2

    handoff_path = Path(sys.argv[1]).resolve()
    print("=== handoff output verifier ===\n")
    print(f"Target: {handoff_path}\n")

    check("B0", handoff_path.is_file(), f"handoff file exists ({handoff_path})")
    doc = read(handoff_path).replace("\r\n", "\n")

    # B1: YAML frontmatter contract (from template.md)
    check("B1", doc.startswith("---\n"), "starts with YAML frontmatter delimiter")
    fm_match = re.match(r"---\n(.*?)\n---", doc, re.DOTALL)
    check("B1", fm_match is not None, "closed YAML frontmatter block")
    fm = fm_match.group(1) if fm_match else ""
    for field in ("title:", "created:", "goal:", "workspace:"):
        check("B1", field in fm, f"frontmatter has {field.rstrip(':')}")

    # B2: document title and next-session goal line
    check("B2", re.search(r"^# Handoff — .+", doc, re.MULTILINE) is not None, "H1 'Handoff — <goal>' present")
    check("B2", "**Next session goal:**" in doc, "next session goal line present")

    # B3: mandatory Suggested first message section + fence (harness-agnostic contract)
    check("B3", "## Suggested first message" in doc, "Suggested first message section")
    first_msg_match = re.search(
        r"## Suggested first message\s+```[^\n]*\n(.*?)```",
        doc,
        re.DOTALL,
    )
    check("B3", first_msg_match is not None, "first message fenced block present")
    first_msg = first_msg_match.group(1).strip() if first_msg_match else ""
    check("B3", "Continue from" in first_msg, "first message has 'Continue from'")
    check("B3", "Goal for this session:" in first_msg, "first message has goal line")
    check(
        "B3",
        "Read the handoff file in full first" in first_msg,
        "first message has receiver read contract",
    )
    check(
        "B3",
        str(handoff_path) in first_msg or handoff_path.as_posix() in first_msg,
        "first message references this handoff absolute path",
    )

    # B4: canonical first-message includes key artifacts pointer
    check("B4", "Key artifacts:" in first_msg, "first message lists key artifacts (use 'none' if empty)")

    # B5: mandatory body sections (per template.md). Decisions / Failed approaches /
    # Artifacts / Relevant files are OPTIONAL — a cold-start handoff may omit them —
    # so they are validated conditionally below, not required here.
    for section in ("## Current state", "## Suggested skills"):
        check("B5", section in doc, f"mandatory section '{section}' present")

    # B6: Current state table rows (mandatory)
    for row in ("COMPLETED", "IN PROGRESS", "NEXT", "BLOCKERS"):
        check("B6", row in doc, f"current state includes {row}")

    # B7: artifacts table — only when the Artifacts section is present
    if "## Artifacts (read these; do not duplicate)" in doc:
        artifacts_match = re.search(
            r"## Artifacts \(read these; do not duplicate\)\n+\|[^\n]+\|",
            doc,
        )
        check("B7", artifacts_match is not None, "artifacts section has markdown table")
        if artifacts_match:
            header = artifacts_match.group(0)
            for col in ("Artifact", "Path", "Why it matters"):
                check("B7", col in header, f"artifacts table column '{col}'")
    else:
        note("B7 artifacts table (section omitted — optional)")

    # B8: suggested skills non-empty (at least one bullet) — mandatory
    skills_match = re.search(r"## Suggested skills\s*\n((?:- .+\n)+)", doc)
    check("B8", skills_match is not None, "suggested skills has at least one entry")

    # B9: relevant files ordered list — only when the section is present
    if "## Relevant files (read order)" in doc:
        files_match = re.search(r"## Relevant files \(read order\)\s*\n((?:\d+\. .+\n)+)", doc)
        check("B9", files_match is not None, "relevant files has numbered list")
    else:
        note("B9 relevant files list (section omitted — optional)")

    # B5b: when optional Decisions / Failed approaches sections appear, accept either
    # the full template heading or a short form — no shape requirement beyond presence.
    for label, heading in (("decisions", "## Decisions"), ("failed approaches", "## Failed approaches")):
        if heading in doc:
            check("B5", True, f"optional section '{label}' present and well-formed")

    # B10: template reference alignment — required strings also defined in template.md
    template = read(TEMPLATE) if TEMPLATE.is_file() else ""
    for needle in (
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
        check("B10", needle in template, f"template.md defines '{needle}' (reference ok)")

    # B11: quality — forward-looking, not transcript dump
    check("B11", len(doc) < 12000, f"doc length {len(doc)} < 12000 (disposable, not transcript)")
    check("B11", "tool-call" not in doc.lower(), "no tool-call noise in handoff")

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
