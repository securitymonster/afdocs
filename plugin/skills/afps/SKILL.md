---
name: afps
description: "AI-Friendly Programming Standard. Use when documenting coding conventions, patterns, testing strategies, dependency rules, code review processes, or AI coding guidelines."
user-invocable: true
---

# AFPS — AI-Friendly Programming Standard

Use this skill to document and enforce coding conventions, patterns, and development practices — the source of truth from which linter configs and CI checks are derived.

## When to Use

- Documenting coding conventions for a project or team
- Defining reusable code patterns (error handling, data fetching, etc.)
- Setting up testing strategy and coverage requirements
- Establishing dependency management rules
- Defining code review and merge conventions
- Creating AI-specific coding guidelines

## Key Deliverables

```
docs/
  conventions.yaml          ← machine-readable index (required)
  conventions/
    naming.md               ← one file per convention type
    structure.md
    patterns/
      error-handling.md     ← one file per pattern
      form-validation.md
    testing.md
    dependencies.md
    style.md
    review.md
    ai-coding.md
```

## Convention Types

| Type | Description |
|------|-------------|
| `naming` | Naming rules for files, variables, functions, types, DB objects |
| `structure` | Project directory layout and file organization |
| `pattern` | Reusable code patterns for common problems |
| `testing` | Testing strategy, coverage, test file organization |
| `dependency` | Rules for adding, updating, and auditing dependencies |
| `style` | Formatting, linting, syntactic preferences |
| `review` | Code review process, approval rules, merge conventions |
| `ai-coding` | Rules specific to AI-assisted code generation |

## Convention Metadata Schema

```yaml
---
convention_id: naming-sveltekit-webapp
name: SvelteKit Web Application Naming Conventions
type: naming
component_id: webapp                  # AFADS component_id, or "system"
scope: [typescript, svelte]           # languages/frameworks
status: active                        # active | draft | deprecated
owner: platform-team
last_reviewed: 2026-02-07
overrides_system: false               # optional: overrides system default?
enforced_by: [eslint, biome]          # optional: tooling that enforces this
related_patterns: []                  # optional: related convention_ids
adr_link: docs/adrs/0003-naming.md   # optional
---
```

## Convention Body Structure

```markdown
## Purpose
Why this convention exists and what problem it solves.

## Rules
- MUST use camelCase for function names
- MUST use PascalCase for types and interfaces
- SHOULD use kebab-case for file names
(Use RFC 2119 language: MUST, SHOULD, MAY)

## Examples

### Good
```typescript
function getUserProfile() { ... }
```

### Bad
```typescript
function get_user_profile() { ... }
```

## Exceptions
When it is acceptable to deviate from this convention.

## Enforcement
- ESLint rule: `camelcase`
- CI check: `npm run lint`

## AI Guidance
Instructions for AI agents when generating or reviewing code:
- Always check this convention before generating code
- Flag violations in code reviews
- Never introduce new patterns that conflict
```

## Pattern Specification (type: pattern)

Patterns have additional body sections:

```markdown
## Problem
What common problem does this pattern solve?

## Context
When should this pattern be applied?

## Solution
The recommended approach.

## Implementation
Code examples showing the pattern in use.

## Trade-offs
Pros and cons of this approach.

## Related Patterns
Links to other patterns that complement or conflict.
```

## Convention Registry (conventions.yaml)

```yaml
conventions:
  - convention_id: naming-sveltekit-webapp
    name: SvelteKit Naming Conventions
    type: naming
    component_id: webapp
    path: docs/conventions/naming.md
    scope: [typescript, svelte]
    status: active
    enforced_by: [eslint, biome]
    owner: platform-team
    last_reviewed: 2026-02-07
```

## Override Model

- System-level conventions live in the docs hub under `docs/conventions/defaults/`
- Repo-level conventions override system defaults when `overrides_system: true`
- Repo convention completely replaces the system default for that type

## Core Principles

- **Conventions are documented, not tribal** — if it's not written down, it's not a convention
- **Source of truth** — linter/formatter configs are derived from conventions, not the other way around
- **Machine-readable** — YAML metadata for AI agents and CI tooling
- **RFC 2119** — use MUST/SHOULD/MAY for testable rules
- **AI agents follow conventions literally** — they must read conventions before generating code

## Cross-References

- `component_id` MUST match an AFADS component
- Patterns may implement AFSS security controls
- AFRS roadmap items may reference conventions via `convention_id`

## Full Standard

https://github.com/securitymonster/afdocs/blob/main/AFPS.md
