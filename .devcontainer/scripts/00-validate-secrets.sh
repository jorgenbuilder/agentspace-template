#!/bin/bash
set -e

LOG_FILE="/workspaces/.build-logs.txt"

echo "==> Validating required secrets..." >> $LOG_FILE

# Check for required secrets
MISSING_SECRETS=()

if [ -z "$ANTHROPIC_API_KEY" ]; then
  MISSING_SECRETS+=("ANTHROPIC_API_KEY") >> $LOG_FILE
fi

if [ -z "$GH_PAT" ]; then
  MISSING_SECRETS+=("GH_PAT") >> $LOG_FILE
fi

# If any secrets are missing, fail with instructions
if [ ${#MISSING_SECRETS[@]} -gt 0 ]; then
  echo "❌ ERROR: Missing required Codespaces secrets!\

  Missing secrets: ${MISSING_SECRETS[*]}\
  \
  To fix this:\
  1. Ensure you have created user Codespaces secrets for:\
     - ANTHROPIC_API_KEY\
     - GH_PAT\
  \
  2. Grant this repository access to those secrets:\
     Run: ./scripts/attach-codespaces-secrets.sh <owner>/<repo>\
     Or manually grant access via GitHub Settings > Codespaces > Secrets\
  \
  3. Rebuild this Codespace or create a new one\
  \
  " >> $LOG_FILE
  exit 1
fi

echo "✅ All required secrets are present" >> $LOG_FILE

# Verify length to ensure they're real values (not empty strings)
ANTHROPIC_KEY_LENGTH=$(echo "$ANTHROPIC_API_KEY" | wc -c)
GH_PAT_LENGTH=$(echo "$GH_PAT" | wc -c)

echo "   ANTHROPIC_API_KEY length: $ANTHROPIC_KEY_LENGTH characters" >> $LOG_FILE
echo "   GH_PAT length: $GH_PAT_LENGTH characters" >> $LOG_FILE

if [ "$ANTHROPIC_KEY_LENGTH" -lt 20 ] || [ "$GH_PAT_LENGTH" -lt 20 ]; then
  echo "⚠️  WARNING: Secret values seem too short - they may not be set correctly" >> $LOG_FILE
fi
