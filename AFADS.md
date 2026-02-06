# AI-Friendly Architecture Documentation Standard (AFADS)

Version: 0.1  
Status: Draft / Working Standard  
Last updated: 2026-02-06
Author: Sebastiaan Mangoentinojo

## 1. Purpose

This standard defines how we document architecture for solutions that consist of:
- multiple repositories
- both infrastructure and application components
- Kubernetes + cloud hosting (e.g. OVH)
- GitOps-based deployment (e.g. Argo CD)
- published documentation (e.g. Wiki.js)

The goal is to produce documentation that is:
- **human-readable**
- **AI-readable**
- **consistent across repos**
- **easy to maintain**
- **good for onboarding and future sessions**
- **usable as long-term architectural memory**

This standard assumes that AI sessions may start without prior context, and should be able to rebuild understanding by reading the documentation.

---

## 2. Core Principles

### 2.1 One system, many repos
Even if the implementation spans many repositories, we treat the solution as **one system**.

### 2.2 Docs live close to the code
Each repository must contain the docs needed to understand and operate that component.

### 2.3 A system-level docs hub composes everything
A dedicated docs repository acts as the “architecture hub”:
- provides the system-level narrative
- holds system-level ADRs
- indexes component docs from all repos
- publishes everything to Wiki.js

### 2.4 Avoid duplication
We do not copy-paste component docs into system docs.
Instead, the hub repo references and/or aggregates component docs.

### 2.5 Stable identifiers beat prose
Architecture docs must use stable IDs for:
- components
- environments
- namespaces
- Argo CD applications
- Helm releases

This makes the documentation queryable and durable.

---

## 3. Documentation Layers

### 3.1 Component Documentation (per repo)
Each repo documents:
- what it does
- how it is deployed
- how it is operated
- its interfaces and dependencies

This is “local truth”.

### 3.2 System Documentation (docs hub repo)
The docs hub repo documents:
- the full system architecture
- cross-cutting concerns (security, observability, backups, networking)
- deployment topology
- runtime flows
- system-level ADRs

This is “global truth”.

---

## 4. Repository Standard (Per Component Repo)

Each repository MUST include:

```
docs/
  component.md
  runbook.md
```

Each repository SHOULD include:

```
docs/
  adrs/
  diagrams/
```

### 4.1 docs/component.md (Required)

This file describes the component in a standard format.

#### Required structure

##### Header metadata block
At the top of the file, include:

- component_id (stable identifier)
- component_name
- owner/team
- repo
- type (service, infra, library, job, helm-chart, terraform, etc.)
- deployed_as (helm release name, kustomize app, systemd unit, etc.)
- namespace (if applicable)
- environments (dev/stage/prod)
- depends_on (list of component_ids)
- exposes (ports, endpoints, events)
- consumes (ports, endpoints, events)

Example:

```yaml
component_id: supabase-auth
component_name: Supabase Auth
owner: platform
repo: github.com/<org>/supabase-auth
type: service
deployed_as: helm
namespace: supabase
environments: [dev, prod]
depends_on:
  - supabase-postgres
exposes:
  - http:8080
consumes:
  - postgres://supabase-postgres:5432
```

##### Body sections
After the metadata header, the document MUST include:

1. Overview
2. Responsibilities
3. Interfaces
4. Dependencies
5. Configuration (env vars, secrets, configmaps)
6. Deployment model
7. Operational notes
8. Known risks / limitations

---

### 4.2 docs/runbook.md (Required)

This file describes how to operate the component.

Minimum sections:
1. Deploy / upgrade procedure
2. Rollback procedure
3. Health checks
4. Common incidents
5. Logs and monitoring
6. Backup/restore (if applicable)
7. Disaster recovery notes

---

### 4.3 docs/adrs/ (Optional)

Use ADRs if the component contains local design decisions.

Rules:
- ADRs MUST use sequential IDs: `0001-<title>.md`
- ADRs MUST use the standard ADR template (see section 6)

---

## 5. System Documentation Standard (Docs Hub Repo)

The docs hub repo MUST contain:

```
docs/
  architecture/
    00-orientation.md
    01-context.md
    02-containers.md
    03-deployment.md
    04-runtime-flows/
    05-security.md
    06-ops.md
    glossary.md
    ai-handoff.md
    adrs/
  components.yaml
```

### 5.1 docs/architecture/00-orientation.md
Defines:
- system purpose
- goals / non-goals
- constraints (budget, compliance, performance, uptime)
- environments (dev/stage/prod)
- quality attributes (security, availability, maintainability)
- key risks

### 5.2 docs/architecture/01-context.md (C4 L1)
Defines:
- system context diagram (human users + external systems)
- trust boundaries
- key integrations

### 5.3 docs/architecture/02-containers.md (C4 L2)
Defines:
- all major deployable units (services, databases, controllers, ingress, etc.)
- responsibilities per container
- dependencies between containers
- component_id mapping

### 5.4 docs/architecture/03-deployment.md
Defines:
- OVH + Kubernetes topology
- node pools / VM layout
- networking
- ingress model
- DNS and certificates
- storage classes and persistence strategy
- backup strategy
- Argo CD layout (apps, repos, sync model)

### 5.5 docs/architecture/04-runtime-flows/
Contains one markdown file per key flow, for example:
- `login.md`
- `file-upload.md`
- `realtime.md`
- `backup-restore.md`

Each flow MUST include:
- a short narrative
- the components involved (component_ids)
- sequence diagram or step-by-step list
- failure modes

### 5.6 docs/architecture/05-security.md
Defines:
- threat model summary
- trust boundaries
- secret management
- IAM model
- network policy model
- ingress exposure
- audit logging strategy

### 5.7 docs/architecture/06-ops.md
Defines:
- monitoring
- logging
- alerting
- upgrade strategy
- rollback strategy
- maintenance windows
- DR and recovery objectives

### 5.8 docs/architecture/glossary.md
Defines:
- domain terms
- component IDs
- abbreviations

### 5.9 docs/architecture/ai-handoff.md
This is a **session continuity file** for humans and AI.

It MUST include:
- current status of the system
- current architecture assumptions
- current issues
- top risks
- next 3–10 planned tasks
- links to the most important docs

This file SHOULD be short (1–2 pages).

---

## 6. ADR Standard (System and Component Level)

### 6.1 ADR naming
All ADRs MUST be named:

```
NNNN-short-title.md
```

Example:
- `0007-ingress-controller-choice.md`

### 6.2 ADR template
All ADRs MUST use:

```markdown
# ADR NNNN: <Title>

Date: YYYY-MM-DD  
Status: Proposed | Accepted | Deprecated | Superseded  
Deciders: <names/roles>  

## Context
What problem are we solving? What forces/constraints exist?

## Decision
What did we decide?

## Consequences
What changes because of this? What are trade-offs?

## Alternatives considered
List options and why they were rejected.

## Links
Links to PRs, issues, diagrams, docs, etc.
```

### 6.3 Where ADRs live
- System-level ADRs live in: `docs/architecture/adrs/`
- Component-level ADRs live in: `<repo>/docs/adrs/`

---

## 7. Component Registry (docs hub repo)

The docs hub repo MUST contain:

```
docs/components.yaml
```

This file is used by CI/CD to aggregate component docs into Wiki.js.

### 7.1 Required schema (minimum)

Example:

```yaml
components:
  - component_id: supabase-postgres
    name: Supabase Postgres
    repo: github.com/<org>/supabase-postgres
    ref: main
    docs:
      component: docs/component.md
      runbook: docs/runbook.md

  - component_id: ingress-nginx
    name: Ingress NGINX
    repo: github.com/<org>/cluster-addons
    ref: main
    docs:
      component: docs/ingress-nginx/component.md
      runbook: docs/ingress-nginx/runbook.md
```

### 7.2 Notes
- `component_id` MUST match the IDs used in architecture docs.
- `ref` MAY be pinned to a tag/commit for stable releases.
- The hub publishing pipeline MAY fail if required docs are missing.

---

## 8. Publishing Model

The docs hub repo is published to Wiki.js using:
- GitHub Actions (aggregation + publishing)
- Argo CD (if the publishing stack itself is deployed via GitOps)

### 8.1 Publishing goals
- A reader must be able to browse system architecture first.
- From the system docs, readers must be able to click through to component docs.
- The system architecture must remain readable even if individual repos change.

---

## 9. Diagram Standard

### 9.1 C4 model
We use C4 as the default diagram structure:
- L1: System Context
- L2: Containers (deployable units)
- L3: Components (inside a container/service)
- L4: Code (optional)

### 9.2 Diagram formats
Preferred:
- Structurizr DSL
- Mermaid (for sequence diagrams)
- Markdown tables for inventories

---

## 10. Kubernetes + GitOps Conventions (Recommended)

To improve architecture traceability, the system SHOULD define:

- namespaces per domain/system area
- Argo CD application naming standard
- Helm release naming standard
- secret management standard
- backup standard (Postgres + object storage)
- upgrade strategy for Supabase components

---

## 11. Definition of Done (Documentation)

A component is considered “documented” when:
- `docs/component.md` exists and follows the structure
- `docs/runbook.md` exists and is usable
- it is registered in `docs/components.yaml`
- the system docs reference it by `component_id`

The system is considered “architecturally documented” when:
- all system-level files exist in `docs/architecture/`
- the C4 L1 and L2 views are present
- system-level ADRs exist for key decisions
- `ai-handoff.md` is current

---

## 12. How AI Should Use This Standard

When an AI session starts, it should:

1. Read `docs/architecture/ai-handoff.md`
2. Read `docs/architecture/00-orientation.md`
3. Read `docs/architecture/01-context.md`
4. Read `docs/architecture/02-containers.md`
5. Read `docs/architecture/03-deployment.md`
6. Review system ADRs in `docs/architecture/adrs/`
7. Use `docs/components.yaml` to locate component docs
8. Read component docs only as needed

---

## 13. Future Extensions (Optional)

Possible additions:
- automatic extraction of Argo CD inventory into docs
- automatic generation of dependency graphs from component metadata
- policy-as-code references (OPA/Gatekeeper, Kyverno)
- threat modeling templates (STRIDE, LINDDUN)
- SLO and error budget templates

---

## 14. Summary

This standard provides:
- a stable system architecture memory
- consistent component documentation across repos
- decision traceability through ADRs
- compatibility with GitOps and multi-repo systems
- a structure that both humans and AI can reliably use
