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
| **AFRS** | [AFRS.md](AFRS.md) | AI-Friendly Roadmap Standard — how to document roadmaps, technical debt, security improvements, and track progress on initiatives |

## Design Goals

- Documentation that AI sessions can parse without prior context
- Structured metadata (YAML) for machine-readable discovery
- Consistent format across repositories and teams
- Composable — procedures, components, conventions, and controls reference each other by stable IDs
- Fail-safe operational procedures with explicit rollback and escalation paths
- Coding conventions that are the source of truth for linter and formatter configs
- Traceable security controls that map to threats, policies, and verification steps
- Quantifiable compliance coverage with traceability from external frameworks to security controls
- Traceable roadmaps connecting planned work to components, security controls, and compliance gaps

## How They Fit Together

**AFADS** defines where documentation lives and how to describe architecture (components, dependencies, deployment topology, ADRs). **AFOPS** extends AFADS by defining how to write the operational procedures that keep that architecture running (deployments, backups, scaling, patching). **AFPS** defines how to document and enforce coding conventions, patterns, and development practices — the source of truth from which linter configs and CI checks are derived. **AFSS** defines how to document security controls, policies, and threat models — connecting threats to verifiable controls at every layer. **AFCS** defines how to map AFSS controls and policies to external compliance frameworks (OWASP, NIS2, etc.), providing checklists, risk matrices, and compliance scorecards. **AFRS** defines how to plan and track work through roadmaps, technical debt registries, and security improvements — connecting planned work to components (AFADS), procedures (AFOPS), conventions (AFPS), security controls (AFSS), and compliance gaps (AFCS).

All six standards share the same `component_id` namespace (from AFADS) and reference each other by stable IDs: AFOPS procedures verify AFSS controls, AFPS patterns implement AFSS controls in code, AFSS controls reference AFOPS procedures for operational verification, AFCS mappings trace external compliance requirements to AFSS controls and policies, and AFRS roadmap items reference components, controls, procedures, and compliance requirements to ensure planned work is traceable end-to-end.

All standards are designed so an AI agent starting a new session can discover, read, and act on the documentation without institutional knowledge. An AI agent can assess compliance posture by reading AFCS mappings and scorecards, generate progress reports from AFRS roadmaps, and trace any gap back to the specific AFSS control, AFOPS procedure, or AFRS roadmap item that needs attention.

## Usage

The examples below show how to prompt an LLM to apply AFDOCS standards. Each prompt is designed to be copy-pasted into a new session. Replace placeholders (`<…>`) with your actual values.

### New Repository

Bootstrap AFDOCS documentation for a project from scratch:

```text
Read the AFDOCS standards at https://github.com/securitymonster/afdocs — specifically
AFADS.md, AFPS.md, AFSS.md, AFOPS.md (OPS-STANDARD.md), AFCS.md, and AFRS.md.

This is a new <language/framework> project called <project-name>.
Set up the AFDOCS documentation structure:

1. Create docs/index.md (documentation hub) per AFADS
2. Create docs/component.md describing this component
3. Create the initial YAML registries (components.yaml, conventions.yaml,
   procedures.yaml, controls.yaml, frameworks.yaml, roadmaps.yaml)
4. Scaffold placeholder files for conventions, procedures, and security controls
5. Create docs/roadmap/ with an initial feature roadmap or technical debt
   registry per AFRS

The component_id is: <component-id>
```

### Existing Repository

Retrofit AFDOCS onto a codebase that already has code but lacks structured documentation:

```text
Read the AFDOCS standards at https://github.com/securitymonster/afdocs — specifically
AFADS.md, AFPS.md, AFSS.md, AFOPS.md (OPS-STANDARD.md), AFCS.md, and AFRS.md.

This repository (<repo-name>) is an existing <language/framework> project.
Audit the codebase and generate AFDOCS-compliant documentation:

1. Read the code and infer the architecture — create docs/component.md per AFADS
2. Document the existing coding conventions you observe — create conventions
   per AFPS (naming, structure, patterns, testing)
3. Identify security controls already in place — document them per AFSS
4. Document any operational procedures that exist (CI/CD, deploy scripts) per AFOPS
5. Create docs/roadmap/ per AFRS if there are known planned features or
   technical debt items worth tracking
6. Create the YAML registries for everything you document

The component_id is: <component-id>
```

### Multi-Repo with Central Documentation Hub

When your system spans multiple repositories, AFADS defines a central "system documentation hub" that aggregates documentation from all component repos. This hub can also sync to a wiki.

```text
Read the AFDOCS standards at https://github.com/securitymonster/afdocs — specifically
AFADS.md (sections 5 and 8), AFCS.md, and AFRS.md.

I have a central documentation repo (<docs-repo>) and these component repos:
- <repo-1> (component_id: <id-1>)
- <repo-2> (component_id: <id-2>)
- <repo-3> (component_id: <id-3>)

Set up the system documentation hub per AFADS section 5:

1. Create the hub structure: 00-orientation.md through 06-ops.md
2. Create ecosystem.yaml listing all component repos with their URLs and
   component_ids per AFADS section 8
3. Create a system-level security overview (05-security.md) that aggregates
   controls from all components per AFSS
4. Create compliance scorecards per AFCS that cover the full system
5. Create docs/roadmap/ per AFRS for system-level initiatives and
   cross-component roadmap items
6. Structure the docs so they can be published to a wiki — each top-level
   file maps to a wiki page, with cross-links using relative paths
```

### Per-Standard Prompts

Use these when you want to apply a single standard to a repository.

**AFADS — Architecture documentation:**

```text
Read AFADS.md from https://github.com/securitymonster/afdocs.
Document the architecture of this repository per AFADS: create docs/component.md,
a C4 context diagram (Mermaid), and register the component in components.yaml.
Component_id: <component-id>
```

**AFOPS — Operational procedures:**

```text
Read OPS-STANDARD.md from https://github.com/securitymonster/afdocs.
Document the operational procedures for this repository per AFOPS: create
docs/runbook.md as the index, write procedures for deployment, rollback, and
backup in docs/procedures/, and register them in procedures.yaml.
Component_id: <component-id>
```

**AFPS — Coding conventions:**

```text
Read AFPS.md from https://github.com/securitymonster/afdocs.
Analyze this codebase and document the coding conventions per AFPS: create
conventions for naming, structure, testing, and patterns in docs/conventions/,
and register them in conventions.yaml.
Component_id: <component-id>
```

**AFSS — Security controls:**

```text
Read AFSS.md from https://github.com/securitymonster/afdocs.
Audit this repository for security controls and document them per AFSS:
create docs/security.md as the index, document each control in
docs/security/controls/, create a threat model, and register controls
in controls.yaml.
Component_id: <component-id>
```

**AFCS — Compliance mapping:**

```text
Read AFCS.md from https://github.com/securitymonster/afdocs.
Map this project's AFSS controls to <framework> (e.g., OWASP Top 10 Web 2021,
NIS2 Article 21). Create a compliance mapping, checklist, and scorecard in
docs/compliance/. Register the framework in frameworks.yaml.
Component_id: <component-id>
```

**AFRS — Roadmap and planning:**

```text
Read AFRS.md from https://github.com/securitymonster/afdocs.
Create roadmap documentation per AFRS: generate docs/roadmap/ with a feature
roadmap, technical debt registry, or security roadmap as appropriate. Include
structured items with IDs, owners, status, priorities, and acceptance criteria.
Register roadmaps in roadmaps.yaml.
Component_id: <component-id>
```

## Output

All standards produce **Markdown** documents with **YAML** frontmatter for metadata. Each standard also defines a YAML registry file that serves as a machine-readable index for AI agents and CI tools.

| Standard | YAML registries |
| -------- | --------------- |
| AFADS | `components.yaml`, `ecosystem.yaml` |
| AFOPS | `procedures.yaml` |
| AFPS | `conventions.yaml` |
| AFSS | `controls.yaml`, `policies.yaml` |
| AFCS | `frameworks.yaml`, `scorecards.yaml` |
| AFRS | `roadmaps.yaml` |

## References

These standards build on or reference the following external frameworks and methodologies:

| Framework | Used in | Context |
| --------- | ------- | ------- |
| [C4 Model](https://c4model.com/) | AFADS | Default architecture diagram structure (L1–L4) |
| [ADR (Architecture Decision Records)](https://adr.github.io/) | AFADS, AFPS, AFSS | Format for documenting architectural decisions |
| [STRIDE](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats) | AFADS, AFSS | Recommended threat modeling methodology |
| [LINDDUN](https://linddun.org/) | AFADS | Privacy-focused threat modeling methodology |
| [OWASP Top 10 Web (2021)](https://owasp.org/Top10/) | AFCS | Web application security compliance framework |
| [OWASP API Security (2023)](https://owasp.org/API-Security/) | AFCS | API security compliance framework |
| [OWASP Mobile Top 10 (2024)](https://owasp.org/www-project-mobile-top-10/) | AFCS | Mobile application security compliance framework |
| [OWASP Top 10 for LLM (2025)](https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/) | AFCS | AI/LLM application security compliance framework |
| [CVSS (v3.1/v4.0)](https://www.first.org/cvss/) | AFCS | Vulnerability risk scoring methodology |
| [NIS2 Directive (EU 2022/2555)](https://eur-lex.europa.eu/eli/dir/2022/2555) | AFCS | European cybersecurity regulation for essential entities |
| [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) | AFPS, AFSS | MUST/SHOULD/MAY requirement language |

ISO 27001, SOC 2, and GDPR are not directly integrated but are supported as mapping targets through AFCS.

## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).
