# LLM Architecture Standard

A set of documentation standards designed to be both human-readable and AI/LLM-parseable, for systems that span multiple repositories, infrastructure, and application components.

## Standards

| Standard | File | Description |
|----------|------|-------------|
| **AFADS** | [AFADS.md](AFADS.md) | AI-Friendly Architecture Documentation Standard — how to document system and component architecture |
| **AFOPS** | [OPS-STANDARD.md](OPS-STANDARD.md) | AI-Friendly Operational Procedures Standard — how to document operational procedures (deployments, backups, maintenance, etc.) |

## Design Goals

- Documentation that AI sessions can parse without prior context
- Structured metadata (YAML) for machine-readable discovery
- Consistent format across repositories and teams
- Composable — procedures and components reference each other by stable IDs
- Fail-safe operational procedures with explicit rollback and escalation paths

## How They Fit Together

**AFADS** defines where documentation lives and how to describe architecture (components, dependencies, deployment topology, ADRs). **AFOPS** extends AFADS by defining how to write the operational procedures that keep that architecture running (deployments, backups, scaling, patching).

Both standards are designed so an AI agent starting a new session can discover, read, and act on the documentation without institutional knowledge.

## License

All rights reserved.
