#!/bin/bash
set -e

echo "==> Installing Claude Code skills..."

# Define skills to install
# Format: "skill-name" or "skill-name@version"
# The beads skill is required for this template
CLAUDE_SKILLS=(
  "beads"
  # Add additional skills here as needed
  # "skill-name@version"
)

# Check if claude CLI supports skill installation
if ! claude.real --help 2>&1 | grep -q "skill" && ! claude.real skill --help >/dev/null 2>&1; then
  echo "⚠️  WARNING: Claude CLI does not appear to support skill management"
  echo "⚠️  You may need to install skills manually or update Claude CLI"
  echo "⚠️  Continuing anyway..."
fi

# Attempt to install each skill
INSTALLED_COUNT=0
SKIPPED_COUNT=0
FAILED_COUNT=0

for skill in "${CLAUDE_SKILLS[@]}"; do
  echo ""
  echo "Installing skill: $skill"

  # Check if skill is already installed (if possible)
  # This check may need adjustment based on actual Claude CLI behavior
  if claude.real skill list 2>/dev/null | grep -q "$skill"; then
    echo "  ✅ Already installed: $skill"
    ((SKIPPED_COUNT++))
    continue
  fi

  # Attempt to install the skill
  if claude.real skill add "$skill" 2>/dev/null; then
    echo "  ✅ Installed: $skill"
    ((INSTALLED_COUNT++))
  else
    echo "  ⚠️  Failed to install: $skill"
    echo "  You may need to install this skill manually"
    ((FAILED_COUNT++))
  fi
done

echo ""
echo "==> Skills installation summary:"
echo "  Installed: $INSTALLED_COUNT"
echo "  Skipped (already installed): $SKIPPED_COUNT"
echo "  Failed: $FAILED_COUNT"

if [ $FAILED_COUNT -gt 0 ]; then
  echo ""
  echo "⚠️  Some skills failed to install."
  echo "⚠️  To install manually, run: claude skill add <skill-name>"
  echo "⚠️  Or visit the Claude Code marketplace"
  # Don't fail the script - allow container to start
fi

echo "✅ Skills installation complete"
