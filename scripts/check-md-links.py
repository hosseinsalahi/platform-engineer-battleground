#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path
import argparse


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        description="Check markdown files for broken relative links."
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="Repository root (defaults to repo containing this script).",
    )
    args = parser.parse_args(argv)

    root = args.root.resolve()
    md_files = [
        p for p in root.rglob("*.md") if ".git" not in p.parts and ".devbox" not in p.parts
    ]

    link_re = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
    ignore_prefixes = ("http://", "https://", "mailto:", "#")

    broken: list[tuple[str, str, str]] = []

    for md_file in md_files:
        text = md_file.read_text("utf-8", errors="ignore")
        for match in link_re.finditer(text):
            raw_target = match.group(2).strip()
            if any(raw_target.startswith(prefix) for prefix in ignore_prefixes):
                continue

            target = raw_target
            if " " in target and not target.startswith("<"):
                target = target.split(" ", 1)[0]
            target = target.strip("<>")

            target_no_anchor = target.split("#", 1)[0]
            if not target_no_anchor:
                continue

            if ":" in target_no_anchor and not target_no_anchor.startswith(("./", "../")):
                continue

            resolved = (md_file.parent / target_no_anchor).resolve()
            try:
                resolved.relative_to(root)
            except ValueError:
                broken.append((str(md_file.relative_to(root)), raw_target, "outside-repo"))
                continue

            if not resolved.exists():
                broken.append((str(md_file.relative_to(root)), raw_target, "missing"))

    if broken:
        print("Broken relative markdown links:")
        for file_path, target, why in broken:
            print(f"- {file_path}: {target} ({why})")
        return 1

    print(f"OK: {len(md_files)} markdown files, no broken relative links")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
