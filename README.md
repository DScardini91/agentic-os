# agentic-os

A template for building a personal operating system on top of Claude — agents, memory, rules, and conventions that turn an LLM into a real chief of staff rather than a generic assistant.

This repo is the **generic, sanitized version** of the architecture. The author's private instance lives in a separate repo with personal context.

## What this is

`agentic-os` is not an app. It's an architecture:

- **Agents** — specialized roles (COO, advisors, domain specialists, entity guardians) that route work
- **Memory** — structured files describing identity, decision rules, mandates, escalation paths
- **Rules** — non-negotiables, expansion sequences, output standards
- **Convention** — a single interface agent that fronts everything; specialists never speak to the principal directly

## Architecture (reference)

```
Principal (CEO)
  └── Interface agent (COO — single point of contact)
        ├── Senior Advisor (refines internally, doesn't speak to principal)
        ├── Domain specialists (professional, personal, finance, ...)
        ├── Entity guardians (family, hobbies, travel)
        └── Client/project agents
```

**Canonical flow:** Principal → Interface → specialists → Interface → Senior Advisor (if executive weight) → Interface → Principal.

## Status

🚧 **Template under construction.** Initial scaffold only. Full sanitized template (agent specs, memory templates, control-plane structure) coming in subsequent commits.

## License

TBD.
