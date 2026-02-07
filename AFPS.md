# AI-Friendly Programming Standard (AFPS)

Version: 0.1
Status: Draft / Working Standard
Last updated: 2026-02-07
Author: Sebastian Mang
Companion to: AI-Friendly Architecture Documentation Standard (AFADS),
              AI-Friendly Operational Procedures Standard (AFOPS)

## 1. Purpose

This standard defines how to document, structure, and maintain programming conventions so they are:
- **human-readable** — clear enough for any developer to follow without prior context
- **AI-parseable** — structured so an LLM can discover, interpret, and follow conventions when generating or reviewing code
- **consistent across repos** — every convention follows the same format
- **derivable** — linter configs, formatter configs, and CI checks are derived from conventions, not the other way around
- **evolvable** — conventions change through documented decisions, not tribal drift

### 1.1 Scope

This standard covers **programming conventions**:
- naming rules (files, variables, functions, types, database objects)
- project structure (directory layout, file organization, module boundaries)
- code patterns (reusable solutions to common problems)
- testing strategy (test types, coverage, organization, CI integration)
- dependency management (addition, updates, auditing, licensing)
- code style (formatting, linting, syntactic preferences)
- code review process (approval rules, checklists, merge strategy)
- AI-assisted development (rules for AI-generated code)

### 1.2 What AFPS Is Not

AFPS is not a linter configuration file. It is the human- and AI-readable source of truth from which linter configs, formatter configs, and CI checks are derived. When a linter rule and this standard disagree, this standard wins and the linter config must be updated.

AFPS is not a tutorial or style guide for a specific language or framework. It defines the format for documenting conventions, not the conventions themselves.

### 1.3 Relationship to AFADS and AFOPS

AFPS is a companion standard to AFADS and AFOPS. It extends:
- AFADS section 4 (Repository Standard) — AFPS defines the detailed project structure conventions that AFADS references at a high level
- AFOPS section 7 (Step Specification) — AFPS defines the code quality standards that procedure scripts and automation code must follow

A component documented per AFADS and operated per AFOPS writes its code per AFPS.

---

## 2. Core Principles

### 2.1 Conventions are documented, not tribal

Every coding convention must be written down. If it is not in the conventions file, it is not a convention. New team members and AI agents must be able to learn every convention by reading the documentation.

### 2.2 Conventions live close to the code

Each repository contains its own conventions file. System-wide defaults live in the docs hub. Repo-level conventions override system defaults.

### 2.3 Conventions are machine-readable

Convention artifacts use YAML metadata so AI agents and CI tooling can discover and enforce them without parsing prose.

### 2.4 Conventions are derivable

Linter configs, formatter configs, and CI checks are derived from the conventions file. The conventions file is the source of truth; tool configs are generated or aligned artifacts.

### 2.5 Conventions evolve through ADRs

When a convention changes, the change is recorded as an ADR (per AFADS section 6). The conventions file is updated and the ADR links to the diff.

### 2.6 AI agents follow conventions explicitly

When an AI agent generates or modifies code, it must read the conventions file first and follow it literally. Conventions are not suggestions.

---

## 3. Convention Types

Every convention artifact MUST be classified as one of these types:

| Type | Description | Example |
|------|-------------|---------|
| `naming` | Naming rules for files, variables, functions, types, database objects | camelCase for functions, kebab-case for files |
| `structure` | Project directory layout and file organization rules | `src/lib/server/` for server-only code |
| `pattern` | Reusable code patterns and idioms for common problems | Error handling pattern for load functions |
| `testing` | Testing strategy, coverage requirements, test file organization | Unit tests co-located, integration tests in `tests/` |
| `dependency` | Rules for adding, updating, and auditing dependencies | Pin major versions, max 1 HTTP client library |
| `style` | Formatting, linting, and syntactic preferences | Tabs, single quotes, trailing commas |
| `review` | Code review process, approval rules, merge conventions | 1 approval required, squash merge only |
| `ai-coding` | Rules specific to AI-assisted code generation and editing | AI must not introduce new dependencies without flagging |

The `type` field in convention metadata MUST use one of these values.

---

## 4. File Layout and Naming

### 4.1 Component repositories

Conventions live inside the AFADS-required `docs/` directory:

```
docs/
  conventions.yaml          ← machine-readable convention index (required)
  conventions/
    naming.md               ← one file per convention type
    structure.md
    patterns/
      error-handling.md     ← one file per pattern
      form-validation.md
      data-fetching.md
    testing.md
    dependencies.md
    style.md
    review.md
    ai-coding.md
```

### 4.2 File naming

Convention files MUST be named using the convention type:

```
<type>.md                     ← if there is one file for the type
<type>/<qualifier>.md         ← if there are multiple (patterns are always a directory)
```

### 4.3 The conventions.yaml index

Every repository MUST contain `docs/conventions.yaml`. This file is the machine-readable entry point for AI agents and CI tools. It lists every convention with its ID, type, and file path. See section 12 for the full schema.

### 4.4 System-level conventions (docs hub repo)

Default conventions that apply across all repositories live in the docs hub:

```
docs/
  conventions/
    defaults/
      naming.md
      structure.md
      style.md
      testing.md
      dependencies.md
      review.md
      ai-coding.md
    conventions.yaml       ← system-level convention registry
```

### 4.5 Override model

Repository-level conventions override system-level defaults. When a repo convention file exists for a type, it completely replaces the system default for that type. The repo's convention metadata MUST declare `overrides_system: true` for any convention that overrides a system default.

---

## 5. Convention Metadata Schema

Every convention artifact MUST begin with a YAML frontmatter block. This block is the primary entry point for AI/LLM parsing.

### 5.1 Required fields

```yaml
---
convention_id: naming-sveltekit-webapp
name: SvelteKit Web Application Naming Conventions
type: naming
component_id: webapp                   # AFADS component_id, or "system" for system-wide
scope: [typescript, svelte]            # languages / frameworks this applies to
status: active                         # active | draft | deprecated
owner: platform-team
last_reviewed: 2026-02-07
---
```

### 5.2 Optional fields

```yaml
overrides_system: true                 # this repo convention replaces the system default
supersedes: naming-sveltekit-webapp-v1 # convention_id this replaces
enforced_by: [eslint, biome]           # tooling that enforces this convention
tags: [sveltekit, typescript, api]
related_patterns: [pattern-error-handling-load]  # convention_ids of related patterns
adr_link: docs/adrs/0003-naming-conventions.md
```

### 5.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `convention_id` | Yes | slug | Stable unique identifier, kebab-case |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | enum | One of the types from section 3 |
| `component_id` | Yes | slug | AFADS component_id, or `system` for cross-component |
| `scope` | Yes | list | Languages, frameworks, or domains this applies to |
| `status` | Yes | enum | `active` / `draft` / `deprecated` |
| `owner` | Yes | string | Team responsible for maintaining this convention |
| `last_reviewed` | Yes | date | ISO date of last review |
| `overrides_system` | No | boolean | Whether this overrides the system-level default |
| `supersedes` | No | slug | Convention ID this replaces |
| `enforced_by` | No | list | Tooling that encodes this convention |
| `tags` | No | list | Searchable tags |
| `related_patterns` | No | list | Convention IDs of related pattern documents |
| `adr_link` | No | path | Path to the ADR that justifies this convention |

---

## 6. Convention Body Structure

After the metadata block, every convention MUST include these sections in order:

```
## Purpose
## Rules
## Examples
## Exceptions
## Enforcement
## AI Guidance
```

### 6.1 Purpose

One to three sentences describing what this convention governs and why it exists.

### 6.2 Rules

A numbered list of concrete, unambiguous rules. Each rule MUST be testable — a human or AI can determine whether code follows it. Rules use RFC 2119 language (MUST, SHOULD, MAY).

### 6.3 Examples

For each rule, at least one compliant example and one non-compliant example, using fenced code blocks with language tags. Examples MUST use the project's actual tech stack where applicable.

### 6.4 Exceptions

Documented cases where a rule may be violated, with justification. If there are no exceptions, state "No exceptions."

### 6.5 Enforcement

How each rule is enforced: which linter rule, which CI check, or "manual review only." If a rule has no automated enforcement, it MUST be flagged as `enforcement: manual`.

### 6.6 AI Guidance

Specific instructions for AI agents generating or modifying code that falls under this convention. This section tells the AI what to do, not just what the rule is.

---

## 7. Pattern Specification

Patterns are a special convention type (`type: pattern`) that document reusable solutions to common coding problems. They have additional structure beyond the standard convention body.

### 7.1 Pattern body structure

In addition to the standard convention body (section 6), patterns MUST include these sections:

```
## Problem
## Context
## Solution
## Implementation
## Trade-offs
## Related Patterns
```

### 7.2 Problem

A concise statement of the problem this pattern solves.

### 7.3 Context

When to use this pattern: what conditions, constraints, or requirements make it appropriate. Also when NOT to use it.

### 7.4 Solution

The pattern itself, described in prose. A narrative explanation of the approach.

### 7.5 Implementation

A complete, working code example using the project's tech stack. Not a snippet — a full implementation that can be copy-adapted.

### 7.6 Trade-offs

What you gain and what you lose by using this pattern. Performance implications, complexity cost, alternatives considered.

### 7.7 Related Patterns

Links to other pattern `convention_id`s that are commonly used together or are alternatives.

---

## 8. Project Structure Convention

The `structure` convention type defines where code lives. It has additional required sections beyond the standard convention body.

### 8.1 Structure convention body

In addition to the standard convention body (section 6), structure conventions MUST include:

```
## Directory Tree
## File Placement Rules
## Import Path Conventions
## Module Boundaries
```

### 8.2 Directory Tree

A complete directory tree showing the canonical project layout. Uses code blocks with annotations explaining the purpose of each directory.

### 8.3 File Placement Rules

Rules for where new files go, keyed by file type (component, utility, server route, test, migration, etc.).

### 8.4 Import Path Conventions

Rules for import aliases, relative vs absolute imports, and barrel files (index re-exports).

### 8.5 Module Boundaries

Which directories may import from which other directories. This defines the dependency direction and prevents circular imports.

---

## 9. Testing Convention Specification

The `testing` convention type defines the testing strategy. It has additional required sections beyond the standard convention body.

### 9.1 Testing convention body

In addition to the standard convention body (section 6), testing conventions MUST include:

```
## Test Types
## Coverage Requirements
## Test File Layout
## Test Naming
## Fixture and Mock Conventions
## CI Integration
```

### 9.2 Test Types

Table of test types used in the project with scope, tooling, and run frequency:

```markdown
| Type | Scope | Tooling | Runs |
|------|-------|---------|------|
| unit | Single function/module | Vitest | Every commit |
| integration | Component + database | Vitest + Supabase local | Every PR |
| e2e | Full user flows | Playwright | Every PR |
| component | Svelte component rendering | Vitest + testing-library | Every commit |
```

### 9.3 Coverage Requirements

Minimum coverage thresholds per test type, per directory, or per component.

### 9.4 Test File Layout

Where test files live relative to source files (co-located vs separate tree).

### 9.5 Test Naming

Naming conventions for test files, describe blocks, and individual test cases.

### 9.6 Fixture and Mock Conventions

How to organize test fixtures, factories, and mocks. Rules for when to mock vs use real dependencies.

### 9.7 CI Integration

How tests are run in CI, which tests gate merges, which are informational only.

---

## 10. Dependency Management Convention

The `dependency` convention type governs how external dependencies are managed. It has additional required sections beyond the standard convention body.

### 10.1 Dependency convention body

In addition to the standard convention body (section 6), dependency conventions MUST include:

```
## Approved Dependencies
## Addition Process
## Update Strategy
## Security Auditing
## License Policy
```

### 10.2 Approved Dependencies

A list or reference to an approved dependency list. New dependencies not on this list require an ADR.

### 10.3 Addition Process

Steps to follow when adding a new dependency: evaluate, propose ADR, peer review, add.

### 10.4 Update Strategy

How and when dependencies are updated (Dependabot/Renovate config, major vs minor vs patch policy).

### 10.5 Security Auditing

How dependency vulnerabilities are detected and remediated. Cross-reference to AFSS for vulnerability response controls.

### 10.6 License Policy

Which open-source licenses are acceptable and which are not.

---

## 11. Code Review Convention

The `review` convention type defines the code review process. It has additional required sections beyond the standard convention body.

### 11.1 Review convention body

In addition to the standard convention body (section 6), review conventions MUST include:

```
## Review Requirements
## Review Checklist
## Merge Strategy
## AI-Generated Code Review
```

### 11.2 Review Requirements

Number of approvals, who can approve, blocking vs advisory reviews.

### 11.3 Review Checklist

Standard checklist items reviewers must verify. Cross-references conventions by `convention_id`.

### 11.4 Merge Strategy

Squash, merge commit, or rebase. Branch naming conventions. Commit message format.

### 11.5 AI-Generated Code Review

Additional review requirements when code was generated or modified by an AI agent. What to look for, what to verify beyond normal review.

---

## 12. Convention Registry

The docs hub repo MUST contain a convention registry, analogous to the AFADS component registry (`components.yaml`) and AFOPS procedure registry (`procedures.yaml`).

### 12.1 File location

```
docs/conventions.yaml
```

### 12.2 Schema

```yaml
conventions:
  - convention_id: naming-sveltekit-webapp
    name: SvelteKit Web Application Naming Conventions
    type: naming
    component_id: webapp
    scope: [typescript, svelte]
    status: active
    repo: github.com/<org>/webapp
    ref: main
    path: docs/conventions/naming.md

  - convention_id: pattern-error-handling-load
    name: SvelteKit Load Function Error Handling
    type: pattern
    component_id: system
    scope: [sveltekit, typescript]
    status: active
    repo: github.com/<org>/platform-docs
    ref: main
    path: docs/conventions/patterns/error-handling-load.md

  - convention_id: testing-integration-supabase
    name: Supabase Integration Testing Strategy
    type: testing
    component_id: system
    scope: [supabase, postgres, vitest]
    status: active
    repo: github.com/<org>/platform-docs
    ref: main
    path: docs/conventions/testing.md
```

### 12.3 Registry rules

- `convention_id` MUST match the ID in the convention's metadata block.
- `component_id` MUST match an AFADS `component_id`, or be `system` for system-wide conventions.
- The registry SHOULD be validated in CI (e.g., check that referenced files exist and contain valid metadata).

---

## 13. AI/LLM Integration Model

This section defines how AI agents should interact with AFPS conventions when generating, modifying, or reviewing code.

### 13.1 Convention discovery

When an AI agent starts a coding session, it MUST:

1. Read `docs/conventions.yaml` in the current repository.
2. If the repo's `conventions.yaml` references system defaults, read the system-level `conventions.yaml` from the docs hub.
3. Build a merged convention set (repo overrides system).
4. Identify which conventions apply to the current task based on `scope` and `type`.

### 13.2 Code generation

When generating code, the AI agent MUST:

1. Read all applicable convention files before writing any code.
2. Follow the Rules section literally.
3. Use the Examples section as templates when applicable.
4. Follow the AI Guidance section for any convention-specific AI behavior.
5. When a pattern exists for the problem being solved, use the pattern's Implementation section as the starting point.
6. Never introduce a new dependency without checking the dependency convention's Approved Dependencies list.

### 13.3 Code modification

When modifying existing code, the AI agent MUST:

1. Read all applicable conventions.
2. Follow existing code style in the file unless it violates a convention (in which case, follow the convention).
3. Not refactor code style in files it was not asked to modify.
4. Flag any convention violations it discovers in the code it is modifying, but only fix them if asked to or if the violations are in code it is actively changing.

### 13.4 Code review assistance

When reviewing code, the AI agent MUST:

1. Read all applicable conventions.
2. Check each changed line against the Rules section of applicable conventions.
3. Reference the specific `convention_id` and rule number when flagging a violation.
4. Distinguish between MUST violations (blocking) and SHOULD violations (advisory).

### 13.5 Convention conflict resolution

When conventions appear to conflict:

1. Repo-level conventions override system-level defaults.
2. More-specific conventions override less-specific ones (e.g., `naming-sveltekit-api` overrides `naming-typescript-general`).
3. If a genuine conflict exists, the AI agent MUST flag it to the human and not guess.

### 13.6 Pattern selection

When the AI agent recognizes a problem that matches a documented pattern:

1. It MUST use the documented pattern rather than inventing a new approach.
2. If the agent believes the pattern is suboptimal for the specific case, it must flag this to the human with a justification and ask before deviating.

---

## 14. Lifecycle and Review

### 14.1 Review triggers

A convention MUST be reviewed when:

| Trigger | Review deadline |
|---------|----------------|
| 180 days since last review | within 2 weeks |
| Framework major version upgrade | before adoption |
| New team member proposes change | within 1 sprint |
| Convention conflict discovered | within 3 business days |
| AI agent flags repeated friction with a convention | within 1 sprint |

### 14.2 Review process

1. Create a PR with proposed changes.
2. The PR description MUST explain what changed and why.
3. The convention owner MUST approve the PR.
4. After merge, update `last_reviewed` in the convention metadata.

### 14.3 Deprecation

To deprecate a convention:
1. Set `status: deprecated` in the metadata.
2. Add a `supersedes` field pointing to the replacement convention.
3. Do not delete the file until all references to it have been updated.

---

## 15. Definition of Done

A convention is considered **compliant** when:

- [ ] Metadata block contains all required fields (section 5.1)
- [ ] All required body sections are present (section 6)
- [ ] Every rule is testable and uses RFC 2119 language (section 6.2)
- [ ] At least one compliant and one non-compliant example per rule (section 6.3)
- [ ] Enforcement method is documented for every rule (section 6.5)
- [ ] AI Guidance section is present (section 6.6)
- [ ] Convention is registered in `conventions.yaml` (section 12)
- [ ] `last_reviewed` date is within 180 days
- [ ] If type is `pattern`, pattern-specific sections are present (section 7)
- [ ] If type is `structure`, structure-specific sections are present (section 8)
- [ ] If type is `testing`, testing-specific sections are present (section 9)
- [ ] If type is `dependency`, dependency-specific sections are present (section 10)
- [ ] If type is `review`, review-specific sections are present (section 11)

---

## 16. Relationship to AFADS and AFOPS

### 16.1 What AFPS extends

| Standard | Section | AFPS Relationship |
|----------|---------|-------------------|
| AFADS | Section 4 (Repository Standard) | AFPS section 8 defines the detailed project structure that AFADS references at a high level |
| AFADS | Section 5.1 (`00-orientation.md`) | Quality attributes in orientation docs should reference `convention_id`s for how those attributes are achieved in code |
| AFOPS | Section 7 (Step Specification) | Automation scripts and procedure code must follow AFPS conventions. Procedure scripts should reference the applicable `convention_id`s |

### 16.2 What AFPS does not replace

- AFADS `docs/component.md` — component documentation remains unchanged
- AFADS ADRs — convention changes are recorded as ADRs per AFADS section 6
- AFOPS procedures — AFPS governs code quality, not operational procedures

### 16.3 Cross-references

- Convention metadata `component_id` MUST match an AFADS `component_id`.
- The `structure` convention's directory tree MUST be consistent with the AFADS section 4 file layout.
- The `testing` convention's CI integration section SHOULD reference AFOPS procedures for test environment setup.
- The `dependency` convention's security auditing section MUST reference AFSS security controls for vulnerability management.

---

## 17. Appendix A: Example Convention (Naming)

```markdown
---
convention_id: naming-sveltekit-webapp
name: SvelteKit Web Application Naming Conventions
type: naming
component_id: webapp
scope: [typescript, svelte, sveltekit]
status: active
owner: platform-team
last_reviewed: 2026-02-07
enforced_by: [eslint]
---

## Purpose

Defines naming rules for the SvelteKit web application to ensure consistency
across components, routes, utilities, and database interactions.

## Rules

1. **Files**: MUST use kebab-case for all file names.
   - Route files use SvelteKit conventions: `+page.svelte`, `+page.server.ts`, `+layout.svelte`.
   - Component files: `user-profile-card.svelte`.
   - Utility files: `format-currency.ts`.

2. **Variables and functions**: MUST use camelCase.
   - `const userName = ...`
   - `function fetchUserProfile() { ... }`

3. **Types and interfaces**: MUST use PascalCase.
   - `type UserProfile = { ... }`
   - `interface DatabaseRow { ... }`

4. **Database tables**: MUST use snake_case (matches Postgres convention).
   - `user_profiles`, `order_items`

5. **Database columns**: MUST use snake_case.
   - `created_at`, `user_id`

6. **Supabase RPC functions**: MUST use snake_case with verb prefix.
   - `get_user_profile`, `update_order_status`

7. **Environment variables**: MUST use UPPER_SNAKE_CASE with project prefix.
   - `PUBLIC_SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`

8. **SvelteKit route groups**: MUST use parenthesized names for layout groups.
   - `(auth)`, `(app)`, `(marketing)`

## Examples

### Rule 1 — Compliant
```
src/lib/components/user-profile-card.svelte
src/routes/(app)/dashboard/+page.svelte
src/lib/server/format-currency.ts
```

### Rule 1 — Non-compliant
```
src/lib/components/UserProfileCard.svelte     ← PascalCase file name
src/lib/server/formatCurrency.ts              ← camelCase file name
```

### Rules 4–5 — Compliant
```sql
CREATE TABLE user_profiles (
  id uuid PRIMARY KEY,
  display_name text,
  created_at timestamptz DEFAULT now()
);
```

### Rules 4–5 — Non-compliant
```sql
CREATE TABLE UserProfiles (                   -- PascalCase table name
  Id uuid PRIMARY KEY,                        -- PascalCase column name
  displayName text                            -- camelCase column name
);
```

## Exceptions

- SvelteKit special files (`+page.svelte`, `+error.svelte`, `$types.d.ts`)
  follow SvelteKit conventions, not this rule.
- `node_modules/`, generated files, and third-party code are exempt.

## Enforcement

| Rule | Tool | Config |
|------|------|--------|
| File naming | eslint-plugin-filenames | `eslint.config.js` |
| Variable/function naming | @typescript-eslint/naming-convention | `eslint.config.js` |
| Type naming | @typescript-eslint/naming-convention | `eslint.config.js` |
| Database naming | Manual review + migration linter | CI check on `supabase/migrations/` |
| Environment variables | Manual review | enforcement: manual |

## AI Guidance

When generating code for this component:
- Always use kebab-case when creating new files.
- When creating Supabase queries, use the exact table/column names from
  the schema (snake_case). Never convert to camelCase in SQL.
- When creating TypeScript types that map to database tables, the type
  name is PascalCase but property names match the database column names
  (snake_case), relying on Supabase's generated types.
- When creating environment variables, always add the appropriate prefix
  (`PUBLIC_` for client-accessible, project prefix for all).
```

---

## 18. Appendix B: Example Pattern (Error Handling)

```markdown
---
convention_id: pattern-error-handling-load
name: SvelteKit Load Function Error Handling
type: pattern
component_id: system
scope: [sveltekit, typescript]
status: active
owner: platform-team
last_reviewed: 2026-02-07
related_patterns: [pattern-error-handling-api, pattern-form-validation]
---

## Purpose

Defines the standard error handling pattern for SvelteKit `+page.server.ts`
and `+layout.server.ts` load functions.

## Problem

SvelteKit load functions interact with Supabase and must handle database
errors, auth errors, and not-found cases consistently without leaking
internal details to the client.

## Context

Use this pattern in every `load` function in `+page.server.ts` and
`+layout.server.ts` files. Do NOT use this pattern in API routes
(`+server.ts`) — see `pattern-error-handling-api` instead.

## Solution

Wrap Supabase calls in a try/catch, map known error codes to SvelteKit
`error()` responses, and let unknown errors propagate as 500s with a
generic message.

## Implementation

```typescript
// src/routes/(app)/projects/[id]/+page.server.ts
import { error } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
  const { supabase } = locals;

  const { data: project, error: dbError } = await supabase
    .from('projects')
    .select('id, name, description, created_at')
    .eq('id', params.id)
    .single();

  if (dbError) {
    if (dbError.code === 'PGRST116') {
      // Row not found
      throw error(404, { message: 'Project not found' });
    }
    // Unknown database error — log and return generic 500
    console.error('Database error loading project:', dbError);
    throw error(500, { message: 'Failed to load project' });
  }

  return { project };
};
```

## Rules

1. Load functions MUST NOT return raw Supabase error objects to the client.
2. Load functions MUST map `PGRST116` to 404.
3. Load functions MUST log unknown errors server-side before throwing 500.
4. Error messages in `error()` calls MUST be user-safe (no SQL, no stack traces).

## Examples

### Compliant

See Implementation section above.

### Non-compliant

```typescript
// BAD: leaks database error details to client
export const load: PageServerLoad = async ({ params, locals }) => {
  const { data, error: dbError } = await locals.supabase
    .from('projects')
    .select('*')
    .eq('id', params.id)
    .single();

  if (dbError) {
    throw error(500, { message: dbError.message }); // WRONG: leaks internal details
  }
  return { project: data };
};
```

## Trade-offs

- **Gain**: Consistent error responses, no information leakage, debuggable server logs.
- **Cost**: Slightly more code per load function. Could be reduced with a wrapper utility if the pattern is used very frequently.

## Exceptions

No exceptions. All load functions that query Supabase must follow this pattern.

## Enforcement

Manual code review. Planned: custom ESLint rule to detect raw `dbError.message` in `error()` calls.

## AI Guidance

When generating a SvelteKit load function that queries Supabase:
1. Always use this pattern. Do not invent a different error handling approach.
2. Check for `PGRST116` (not found) as a named case.
3. Never pass `dbError.message` directly to the `error()` helper.
4. If the query uses `.maybeSingle()` instead of `.single()`, a null result
   is expected and should not throw 404 — handle it as an empty state.

## Related Patterns

- `pattern-error-handling-api` — for `+server.ts` API routes
- `pattern-form-validation` — for form action error handling
```

---

## 19. Summary

This standard provides:
- a **conventions-as-documentation** approach where coding standards are human-readable, AI-parseable, and version-controlled
- a **structured format** for naming, structure, patterns, testing, dependencies, style, review, and AI-coding conventions
- a **pattern catalog** for reusable solutions to common problems
- a **convention registry** for discoverability across the system
- an **AI integration model** that tells AI agents how to discover, follow, and enforce conventions when generating or reviewing code
- a **derivation model** where linter and formatter configs are derived from the conventions, not the other way around
- a clear **relationship to AFADS and AFOPS** so all three standards work together
