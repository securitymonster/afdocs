# AFDOCS — AI-Friendly Documentation Standards

A set of documentation standards designed to be both human-readable and AI/LLM-parseable, for systems that span multiple repositories, infrastructure, and application components.

## Standards

| Standard | File | Description |
|----------|------|-------------|
| **AFADS** | [AFADS.md](AFADS.md) | AI-Friendly Architecture Documentation Standard — how to document system and component architecture |
| **AFOPS** | [OPS-STANDARD.md](OPS-STANDARD.md) | AI-Friendly Operational Procedures Standard — how to document operational procedures (deployments, backups, maintenance, etc.) |
| **AFPS** | [AFPS.md](AFPS.md) | AI-Friendly Programming Standard — how to document and enforce coding conventions, patterns, and development practices |
| **AFSS** | [AFSS.md](AFSS.md) | AI-Friendly Security Standard — how to document security controls, policies, threat models, and security review processes |
| **AFCS** | [AFCS.md](AFCS.md) | AI-Friendly Compliance Standard — how to document compliance mappings, risk assessments, and compliance scoring against external frameworks (OWASP, NIS2, etc.) |

## Design Goals

- Documentation that AI sessions can parse without prior context
- Structured metadata (YAML) for machine-readable discovery
- Consistent format across repositories and teams
- Composable — procedures, components, conventions, and controls reference each other by stable IDs
- Fail-safe operational procedures with explicit rollback and escalation paths
- Coding conventions that are the source of truth for linter and formatter configs
- Traceable security controls that map to threats, policies, and verification steps
- Quantifiable compliance coverage with traceability from external frameworks to security controls

## How They Fit Together

**AFADS** defines where documentation lives and how to describe architecture (components, dependencies, deployment topology, ADRs). **AFOPS** extends AFADS by defining how to write the operational procedures that keep that architecture running (deployments, backups, scaling, patching). **AFPS** defines how to document and enforce coding conventions, patterns, and development practices — the source of truth from which linter configs and CI checks are derived. **AFSS** defines how to document security controls, policies, and threat models — connecting threats to verifiable controls at every layer. **AFCS** defines how to map AFSS controls and policies to external compliance frameworks (OWASP, NIS2, etc.), providing checklists, risk matrices, and compliance scorecards.

All five standards share the same `component_id` namespace (from AFADS) and reference each other by stable IDs: AFOPS procedures verify AFSS controls, AFPS patterns implement AFSS controls in code, AFSS controls reference AFOPS procedures for operational verification, and AFCS mappings trace external compliance requirements to AFSS controls and policies.

All standards are designed so an AI agent starting a new session can discover, read, and act on the documentation without institutional knowledge. An AI agent can assess compliance posture by reading AFCS mappings and scorecards, then trace any gap back to the specific AFSS control or policy that needs attention.

## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).
