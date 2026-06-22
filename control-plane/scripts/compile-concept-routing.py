#!/usr/bin/env python3
"""
compile-concept-routing.py — Concept Routing Index compiler.

Reads every control-plane/concepts/_cards/*.md frontmatter and compiles a
compact routing manifest. Concept cards encode decision frameworks (Pyramid,
Walter 3-lenses, etc.) that fire on decision_type patterns.

Frontmatter schema:
    ---
    title: <card title>
    decision_types:
      - "trabalho com cliente"
      - "alocação de recursos"
    embed: true|false        # if true, the card is inlined into the session
                             # context (max 2 simultaneous embeds)
    description: <one-liner>
    ---

Output: control-plane/memory/concepts/concept-routing-index.md
"""

import os
import re
import sys
import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.abspath(os.path.join(SCRIPT_DIR, "..", ".."))
CARDS_DIR = os.path.join(ROOT, "control-plane", "concepts", "_cards")
CACHE_DIR = os.path.join(ROOT, "control-plane", "memory", "concepts")
CACHE_FILE = os.path.join(CACHE_DIR, "concept-routing-index.md")

MAX_EMBED = 2


def parse_frontmatter(text):
    if not text.startswith("---"):
        return {}, text
    end = text.find("\n---", 3)
    if end == -1:
        return {}, text
    raw = text[3:end].strip()
    body = text[end + 4 :].lstrip()
    fm = {}
    current_list = None
    for line in raw.splitlines():
        if not line.strip():
            continue
        if current_list is not None and re.match(r"^\s*-\s+", line):
            current_list.append(re.sub(r'^\s*-\s+["\']?(.+?)["\']?\s*$', r"\1", line))
            continue
        else:
            current_list = None
        m = re.match(r"^([a-zA-Z_][\w-]*):\s*(.*)$", line)
        if not m:
            continue
        key, val = m.group(1), m.group(2).strip()
        if val == "":
            current_list = []
            fm[key] = current_list
        else:
            val = val.strip('"').strip("'")
            if val.lower() in ("true", "false"):
                val = val.lower() == "true"
            fm[key] = val
    return fm, body


def discover_cards():
    if not os.path.isdir(CARDS_DIR):
        return
    for entry in sorted(os.listdir(CARDS_DIR)):
        if not entry.endswith(".md"):
            continue
        path = os.path.join(CARDS_DIR, entry)
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            text = f.read()
        fm, body = parse_frontmatter(text)
        slug = os.path.splitext(entry)[0]
        yield slug, fm, body


def main():
    cards = list(discover_cards())
    today = datetime.date.today().isoformat()
    embed_count = sum(1 for _, fm, _ in cards if fm.get("embed"))

    lines = [
        "## Concept Routing Index",
        f"_Auto-compiled by compile-concept-routing.py · {len(cards)} cards · {today} · "
        f"{embed_count}/{MAX_EMBED} embed slots used_",
        "",
        "When a decision context matches a card's decision_types, surface the relevant "
        "framework. Cards marked **[INLINE]** have their content embedded below. Others "
        "are on-demand — open the full card when the decision type fires.",
        "",
    ]

    if embed_count > MAX_EMBED:
        lines.append(
            f"> **⚠️ Embed governance violation:** {embed_count} cards marked `embed: true` "
            f"but max is {MAX_EMBED}. Resolve by setting `embed: false` on lower-priority cards."
        )
        lines.append("")

    lines.append("### Cards — referência on-demand")
    for slug, fm, _ in cards:
        if fm.get("embed"):
            continue
        title = fm.get("title", slug)
        desc = fm.get("description", "").strip()
        dts = fm.get("decision_types") or []
        line = f"- **{slug}** · _{title}_ — {desc}"
        if dts:
            line += "\n  · decision_types: " + "; ".join(f'"{d}"' for d in dts[:6])
        lines.append(line)
    lines.append("")

    inlined = [(s, f, b) for s, f, b in cards if f.get("embed")]
    for slug, fm, body in inlined[:MAX_EMBED]:
        title = fm.get("title", slug)
        desc = fm.get("description", "").strip()
        lines.append(f"### [INLINE] {slug} · _{title}_")
        if desc:
            lines.append(f"_{desc}_")
        dts = fm.get("decision_types") or []
        if dts:
            lines.append("decision_types: " + "; ".join(f'"{d}"' for d in dts[:6]))
        lines.append("")
        lines.append(body.rstrip())
        lines.append("")

    os.makedirs(CACHE_DIR, exist_ok=True)
    with open(CACHE_FILE, "w", encoding="utf-8") as f:
        f.write("\n".join(lines).rstrip() + "\n")

    if "--stdout" in sys.argv:
        sys.stdout.write("\n".join(lines) + "\n")
    else:
        print(CACHE_FILE)


if __name__ == "__main__":
    main()
