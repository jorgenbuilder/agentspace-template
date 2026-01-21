#!/bin/bash
set -e

echo "==> Authenticating Claude CLI..."

# Check if ANTHROPIC_API_KEY is available
if [ -z "$ANTHROPIC_API_KEY" ]; then
  echo "❌ ERROR: ANTHROPIC_API_KEY not set"
  exit 1
fi

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
  echo "❌ ERROR: Claude CLI not found in PATH"
  exit 1
fi

# Check if already authenticated
if claude auth status &> /dev/null; then
  echo "✅ Claude is already authenticated, skipping"
  exit 0
fi

# Login with API key
echo "$ANTHROPIC_API_KEY" | claude auth login --api-key

echo "✅ Claude CLI authenticated successfully"
