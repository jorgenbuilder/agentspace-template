#!/bin/bash
set -e

LOG_FILE="/workspaces/.build-logs.txt"

echo "==> Installing Beads CLI..." >> $LOG_FILE

claude -p "install and initialize beads, and add all recommended skills to claude cli, reference https://github.com/steveyegge/beads/blob/main/docs/INSTALLING.md" >> $LOG_FILE