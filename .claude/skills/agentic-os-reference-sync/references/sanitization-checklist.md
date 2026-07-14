# Sanitization Checklist

Use before moving any private-reference behavior into the public `agentic-os` template.

## Must Exclude

- Personal identity details beyond already-public author attribution.
- Client names, stakeholder names, engagement codes, project-specific repo paths, and meeting artifacts.
- Absolute paths containing local usernames or private folder structures.
- Operational memory from `control-plane/memory/auto/`, daily notes, transcripts, or scratchpads.
- Private scheduler, launchd, OAuth, or account-switching assumptions that a fresh fork cannot run.
- Generated bundles when the source file can be edited instead.

## Convert To Public Pattern

| Private reference detail | Public template language |
|---|---|
| Named private OS behavior | "reference implementation" |
| Specific client/project agent | "client/project agent" or "code-owner agent" |
| Personal non-negotiable | "entity guardian protecting a declared priority" |
| Local runtime incident | "runtime caveat" or "validation requirement" |
| Cost complaint with private telemetry | "context-budget pressure" |

## Required Claims Discipline

- Say "orientation added" when only docs were added.
- Say "validated locally" only after running the command in the public repo.
- Say "reference-only" when the behavior exists in the private OS but not in this repo.
- Say "Claude Code reference runtime" unless Codex or another runtime has been validated separately.

## Final Scan

Run:

```bash
rg -n "Daniel|BCG|HDI|Kowalski OS|/Users/|scardinidaniel|private|client name" README.md ARCHITECTURE.md CHANGELOG.md ROADMAP.md control-plane .claude/skills
git diff --check
```

Review every hit. Some author attribution or explicit historical examples may be intentional; private implementation detail should not ship.
