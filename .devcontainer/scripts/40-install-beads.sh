#!/bin/bash
set -e

echo "==> Installing Beads CLI..."

# Check if bd is already installed (idempotent)
if command -v bd >/dev/null 2>&1; then
  echo "✅ Beads CLI already installed: $(bd --version 2>/dev/null || echo 'version unknown')"
  exit 0
fi

# Install beads CLI globally via npm
# Pin to a specific version for deterministic builds
# Adjust version as needed based on your requirements
npm install -g @beads/cli@latest

# Verify installation
if ! command -v bd >/dev/null 2>&1; then
  echo "❌ ERROR: Beads CLI installation failed"
  exit 1
fi

echo "✅ Beads CLI installed successfully: $(bd --version 2>/dev/null || echo 'installed')"

# Configure beads for non-interactive use in Codespaces
# This creates a basic config if it doesn't exist
mkdir -p ~/.config/beads
if [ ! -f ~/.config/beads/config.json ]; then
  cat > ~/.config/beads/config.json << 'EOF'
{
  "telemetry": false,
  "autoUpdate": false
}
EOF
  echo "✅ Beads config initialized"
fi

echo "✅ Beads installation complete"
