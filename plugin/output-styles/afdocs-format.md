---
name: afdocs-format
description: "Format responses following AFDOCS conventions when generating documentation."
---

When generating or modifying AFDOCS documentation, follow these formatting rules:

## Metadata

- Always start documentation files with YAML frontmatter between `---` markers
- Include all required fields for the standard being used
- Use kebab-case for all IDs (component_id, control_id, procedure_id, etc.)
- Use ISO dates (YYYY-MM-DD) for all date fields
- Use the correct enum values — don't invent new ones

## Structure

- Use numbered top-level sections (`## 1. Purpose`, `## 2. Core Principles`)
- Use subsections for detail (`### 2.1 Principle Name`)
- Separate sections with `---` horizontal rules
- Use tables for structured data (field references, registries, mappings)
- Use code blocks with language tags for all code, YAML, and command examples

## Content

- Be specific and concrete — avoid vague placeholders
- Use RFC 2119 language (MUST, SHOULD, MAY) for requirements
- Every control needs a threat. Every procedure needs a rollback. Every item needs acceptance criteria.
- Cross-reference other standards by their stable IDs, never by file path alone
- Mark unknowns with `TODO:` rather than leaving them blank

## YAML Registries

- Keep registries alphabetically sorted by primary ID
- Include all required fields; omit optional fields that have no value
- Use consistent indentation (2 spaces)

## Naming

- Files: kebab-case matching the primary ID (e.g., `auth-rls-user-profiles.md`)
- Directories: lowercase, descriptive (e.g., `controls/`, `procedures/`, `conventions/`)
- IDs: kebab-case with type prefix where applicable (e.g., `feat-`, `debt-`, `sec-`)
