#!/bin/bash
# PostToolUse hook: validate YAML frontmatter in AFDOCS documentation files
# Runs after Write or Edit on files in docs/ directories
# Exit 0 = allow, exit 2 = block with message

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.file // empty' 2>/dev/null)

# Skip if no file path or not a docs file
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only validate markdown files in docs/ or AFDOCS standard files
case "$FILE_PATH" in
  */docs/*.md|*/docs/*.yaml|*/docs/*.yml)
    ;;
  *)
    exit 0
    ;;
esac

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# For markdown files, check YAML frontmatter
if [[ "$FILE_PATH" =~ \.md$ ]]; then
  FIRST_LINE=$(head -1 "$FILE_PATH")

  # Only validate files with YAML frontmatter
  if [ "$FIRST_LINE" = "---" ]; then
    # Extract frontmatter (between first and second ---)
    FRONTMATTER=$(sed -n '1,/^---$/p' "$FILE_PATH" | tail -n +2 | head -n -1)

    if [ -z "$FRONTMATTER" ]; then
      echo "Warning: Empty YAML frontmatter in $FILE_PATH"
      exit 0  # Warn but don't block
    fi

    # Check for common required fields (at least one should be present)
    HAS_ID=$(echo "$FRONTMATTER" | grep -c '_id:')
    HAS_OWNER=$(echo "$FRONTMATTER" | grep -c 'owner:')
    HAS_STATUS=$(echo "$FRONTMATTER" | grep -c 'status:')

    if [ "$HAS_ID" -eq 0 ]; then
      echo "Warning: No *_id field found in YAML frontmatter of $FILE_PATH"
      echo "AFDOCS requires a stable identifier (component_id, procedure_id, control_id, etc.)"
    fi
  fi
fi

# For YAML files, check basic syntax
if [[ "$FILE_PATH" =~ \.(yaml|yml)$ ]]; then
  # Try to parse with python if available
  if command -v python3 &>/dev/null; then
    python3 -c "
import yaml, sys
try:
    with open('$FILE_PATH') as f:
        yaml.safe_load(f)
except yaml.YAMLError as e:
    print(f'YAML syntax error in $FILE_PATH: {e}')
    sys.exit(2)
" 2>&1
    if [ $? -eq 2 ]; then
      exit 2  # Block on YAML syntax errors
    fi
  fi
fi

exit 0
