#!/bin/bash
# SessionStart hook: detect if the current project uses AFDOCS
# Outputs context about which standards are in use so Claude is aware

DOCS_DIR="docs"
FOUND_STANDARDS=""

# Check for AFDOCS registry files
[ -f "$DOCS_DIR/components.yaml" ] || [ -f "components.yaml" ] && FOUND_STANDARDS="$FOUND_STANDARDS AFADS"
[ -f "$DOCS_DIR/procedures.yaml" ] || [ -d "$DOCS_DIR/procedures" ] && FOUND_STANDARDS="$FOUND_STANDARDS AFOPS"
[ -f "$DOCS_DIR/conventions.yaml" ] || [ -d "$DOCS_DIR/conventions" ] && FOUND_STANDARDS="$FOUND_STANDARDS AFPS"
[ -f "$DOCS_DIR/security/controls.yaml" ] || [ -f "controls.yaml" ] && FOUND_STANDARDS="$FOUND_STANDARDS AFSS"
[ -f "$DOCS_DIR/compliance/frameworks.yaml" ] || [ -f "frameworks.yaml" ] && FOUND_STANDARDS="$FOUND_STANDARDS AFCS"
[ -f "$DOCS_DIR/roadmap/roadmaps.yaml" ] || [ -f "roadmaps.yaml" ] && FOUND_STANDARDS="$FOUND_STANDARDS AFRS"

if [ -n "$FOUND_STANDARDS" ]; then
  echo "AFDOCS standards detected in this project:$FOUND_STANDARDS"
  echo "Use /afdocs:<standard> skills for guidance. Run the docs-validator agent to audit compliance."
fi

exit 0
