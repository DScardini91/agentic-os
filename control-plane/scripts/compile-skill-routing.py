#!/usr/bin/env python3
"""
compile-skill-routing.py — Skill Routing Index compiler.

Reads every .claude/skills/*/SKILL.md frontmatter and compiles a compact
routing manifest used as SessionStart context, so the model knows which
skills exist and when to fire them WITHOUT loading every full SKILL.md.

Design (generic — sanitized from kowalski-os/control-plane/scripts/):
- No third-party deps; hand-parses YAML-ish frontmatter.
- Optional fields per skill:
    name        — derived from directory if absent
    description — one-liner
    pod / category — grouping bucket; falls back to "general"
    triggers    — list of phrases (explicit override)
- When `triggers:` is absent, the compiler also scans the description for
  `Triggers — "..."` phrases (single source of truth for legacy skills).
- Deterministic ordering — cache only changes when content changes.

Output: writes the manifest to
    control-plane/memory/skills/skill-routing-index.md
"""

import os
import re
import sys
import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.abspath(os.path.join(SCRIPT_DIR, "..", ".."))
SKILLS_DIR = os.path.join(ROOT, ".claude", "skills")
CACHE_DIR = os.path.join(ROOT, "control-plane", "memory", "skills")
CACHE_FILE = os.path.join(CACHE_DIR, "skill-routing-index.md")


def parse_frontmatter(text):
    """Returns (frontmatter dict, body). Empty dict if no frontmatter."""
    if not text.startswith("---"):
        return {}, text
    end = text.find("\n---", 3)
    if end == -1:
        return {}, text
    raw = text[3:end].strip()
    body = text[end + 4 :].lstrip()
    fm = {}
    current_key = None
    current_list = None
    for line in raw.splitlines():
        if not line.strip():
            continue
        if current_list is not None and re.match(r"^\s*-\s+", line):
            item = re.sub(r'^\s*-\s+["\']?(.+?)["\']?\s*$', r"\1", line)
            current_list.append(item)
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
            current_key = key
        else:
            val = val.strip('"').strip("'")
            fm[key] = val
            current_key = key
    return fm, body


TRIGGER_RX = re.compile(r'Triggers?\s*[—–-]\s*((?:"[^"]+"\s*[;,]?\s*)+)', re.IGNORECASE)
QUOTED_RX = re.compile(r'"([^"]+)"')


def extract_triggers(fm, body):
    """Returns list of trigger phrases. Explicit `triggers:` wins; falls back
    to parsing the description / body for `Triggers — "..."` patterns."""
    explicit = fm.get("triggers")
    if isinstance(explicit, list) and explicit:
        return [t for t in explicit if t.strip()]
    desc = fm.get("description", "")
    candidates = []
    for chunk in (desc, body[:2000]):
        m = TRIGGER_RX.search(chunk)
        if m:
            candidates += QUOTED_RX.findall(m.group(1))
            break
    return candidates


def discover_skills():
    """Yields (skill_name, frontmatter, body) for every .claude/skills/*/SKILL.md."""
    if not os.path.isdir(SKILLS_DIR):
        return
    for entry in sorted(os.listdir(SKILLS_DIR)):
        path = os.path.join(SKILLS_DIR, entry, "SKILL.md")
        if not os.path.isfile(path):
            continue
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            text = f.read()
        fm, body = parse_frontmatter(text)
        name = fm.get("name") or entry
        yield name, fm, body


def main():
    skills_by_pod = {}
    counts = {"explicit_triggers": 0, "parsed_triggers": 0, "none": 0}
    total = 0
    for name, fm, body in discover_skills():
        total += 1
        pod = fm.get("pod") or fm.get("category") or "general"
        triggers = extract_triggers(fm, body)
        if fm.get("triggers"):
            counts["explicit_triggers"] += 1
        elif triggers:
            counts["parsed_triggers"] += 1
        else:
            counts["none"] += 1
        skills_by_pod.setdefault(pod, []).append(
            {
                "name": name,
                "description": fm.get("description", "").strip(),
                "triggers": triggers,
            }
        )

    today = datetime.date.today().isoformat()
    lines = [
        "## Skill Routing Index",
        f"_Auto-compiled by compile-skill-routing.py · {total} skills · {today} · "
        f"triggers: {counts['explicit_triggers']} explicit / {counts['parsed_triggers']} parsed / {counts['none']} none_",
        "",
        "When a request matches a skill's triggers below, invoke that skill via the "
        "**Skill tool** before composing a manual response. This is a routing table, "
        "not the skill body — the Skill tool loads the full SKILL.md on demand.",
        "",
    ]
    for pod in sorted(skills_by_pod.keys()):
        lines.append(f"### {pod}")
        for s in sorted(skills_by_pod[pod], key=lambda x: x["name"]):
            desc = s["description"][:160].rstrip()
            trig_line = (
                "  · triggers: " + "; ".join(f'"{t}"' for t in s["triggers"][:6])
                if s["triggers"]
                else ""
            )
            line = f"- **{s['name']}** — {desc}"
            if trig_line:
                line += f"\n{trig_line}"
            lines.append(line)
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
