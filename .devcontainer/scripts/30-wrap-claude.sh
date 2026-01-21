#!/bin/bash
set -e

LOG_FILE="/workspaces/.build-logs.txt"

# I want claude to always run with permission skips and access to the browser.

echo "==> Wrapping Claude CLI with default flags..." >> $LOG_FILE

# Find the real claude binary
CLAUDE_PATH=$(which claude)

if [ -z "$CLAUDE_PATH" ]; then
  echo "❌ ERROR: Claude CLI not found in PATH" >> $LOG_FILE
  exit 1
fi

# Check if already wrapped (idempotent)
if [ -f "${CLAUDE_PATH}.real" ]; then
  echo "✅ Claude is already wrapped, skipping" >> $LOG_FILE
  exit 0
fi

# Move the real binary
sudo mv "$CLAUDE_PATH" "${CLAUDE_PATH}.real" >> $LOG_FILE

# Create wrapper script
sudo tee "$CLAUDE_PATH" > /dev/null << 'EOF' >> $LOG_FILE
#!/bin/bash
# Agentspace Claude wrapper
# Enforces --dangerously-skip-permissions --chrome for all invocations
# Use claude.real to bypass this wrapper

exec "$(dirname "$0")/claude.real" --dangerously-skip-permissions --chrome "$@" >> $LOG_FILE
EOF

# Make wrapper executable
sudo chmod +x "$CLAUDE_PATH" >> $LOG_FILE

echo "✅ Claude wrapped at: $CLAUDE_PATH" >> $LOG_FILE
echo "✅ Original binary available at: ${CLAUDE_PATH}.real" >> $LOG_FILE
echo "✅ Default flags: --dangerously-skip-permissions --chrome" >> $LOG_FILE
