---
name: afads
description: "AI-Friendly Architecture Documentation Standard. Use when documenting system architecture, components, deployment topology, C4 diagrams, ADRs, or component registries."
user-invocable: true
---

# AFADS — AI-Friendly Architecture Documentation Standard

Use this skill to document architecture for systems that span multiple repositories, infrastructure, and application components.

## When to Use

- Bootstrapping documentation for a new project
- Documenting an existing system's architecture
- Creating C4 diagrams (Context, Container, Component, Code)
- Writing Architecture Decision Records (ADRs)
- Setting up a multi-repo documentation hub
- Creating component and ecosystem registries

## Key Deliverables

### Per-Repository (Required)

```
docs/
  index.md          ← landing page linking to all docs
  ecosystem.md      ← standards, architecture hub, related repos
  component.md      ← this component's architecture
  runbook.md        ← operations index (links to AFOPS procedures)
  adrs/             ← architecture decision records (optional)
  diagrams/         ← C4 and other diagrams (optional)
```

### System Documentation Hub (Multi-Repo)

```
docs/
  00-orientation.md     ← reading guide
  01-context.md         ← C4 L1 context diagram, trust boundaries
  02-containers.md      ← C4 L2 container diagram
  03-components.md      ← C4 L3 per-component summaries
  04-conventions.md     ← links to AFPS conventions
  05-security.md        ← links to AFSS controls
  06-ops.md             ← links to AFOPS procedures
  components.yaml       ← component registry
  ecosystem.yaml        ← ecosystem registry
```

## Component Metadata Schema

Every `docs/component.md` MUST start with:

```yaml
component_id: api-service          # stable kebab-case identifier
component_name: API Service
owner: platform-team
repo: github.com/org/api-service
type: service                      # service | infra | library | job | helm-chart | terraform
deployed_as: helm
namespace: production
environments: [dev, staging, prod]
depends_on: [postgres, redis]      # other component_ids
exposes: [http:8080]
consumes: [postgres://db:5432]
```

### Required Body Sections

1. Overview
2. Responsibilities
3. Interfaces
4. Dependencies
5. Configuration (env vars, secrets, configmaps)
6. Deployment model
7. Operational notes
8. Known risks / limitations

## Component Registry (components.yaml)

```yaml
components:
  - component_id: api-service
    name: API Service
    type: service
    owner: platform-team
    repo: https://github.com/org/api-service
    doc_path: docs/component.md
    depends_on: [postgres, redis]
```

## Ecosystem Registry (ecosystem.yaml)

```yaml
ecosystem:
  - component_id: api-service
    repo_url: https://github.com/org/api-service
    doc_path: docs/component.md
    type: service
```

## ADR Format

File: `docs/adrs/NNNN-short-title.md`

```yaml
---
status: accepted              # proposed | accepted | superseded | deprecated
date: 2026-01-15
deciders: [tech-lead, architect]
component_id: api-service
---

# ADR-NNNN: Decision Title

## Context
Why this decision was needed.

## Decision
What was decided.

## Consequences
Positive and negative outcomes.

## Alternatives considered
Other options that were evaluated.

## Links
Related ADRs, issues, or documents.
```

## Core Principles

- **component_id is the universal key** — all AFDOCS standards reference components by this ID
- **AI-parseable** — structured YAML metadata so agents can discover architecture without prior context
- **ecosystem.md is the entry point** — any repo serves as a starting point to discover the full system
- **C4 Model** — use Context → Container → Component → Code levels for architecture diagrams
- **Threat models** — use STRIDE or LINDDUN methodologies

## Cross-References

- AFOPS procedures reference `component_id` for the component they operate on
- AFPS conventions reference `component_id` for the component they apply to
- AFSS security controls reference `component_id` for the component they protect
- AFCS compliance mappings trace to AFSS controls which trace to components
- AFRS roadmap items reference `component_id` for planned work

## Full Standard

https://github.com/securitymonster/afdocs/blob/main/AFADS.md
