#!/bin/bash
set -e

echo "==> Validating required secrets..."

# Check for required secrets
MISSING_SECRETS=()

if [ -z "$ANTHROPIC_API_KEY" ]; then
  MISSING_SECRETS+=("ANTHROPIC_API_KEY")
fi

if [ -z "$GH_PAT" ]; then
  MISSING_SECRETS+=("GH_PAT")
fi

# If any secrets are missing, fail with instructions
if [ ${#MISSING_SECRETS[@]} -gt 0 ]; then
  echo "❌ ERROR: Missing required Codespaces secrets!"
  echo ""
  echo "Missing secrets: ${MISSING_SECRETS[*]}"
  echo ""
  echo "To fix this:"
  echo "1. Ensure you have created user Codespaces secrets for:"
  echo "   - ANTHROPIC_API_KEY"
  echo "   - GH_PAT"
  echo ""
  echo "2. Grant this repository access to those secrets:"
  echo "   Run: ./scripts/attach-codespaces-secrets.sh <owner>/<repo>"
  echo "   Or manually grant access via GitHub Settings > Codespaces > Secrets"
  echo ""
  echo "3. Rebuild this Codespace or create a new one"
  echo ""
  exit 1
fi

echo "✅ All required secrets are present"
