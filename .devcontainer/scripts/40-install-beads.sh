#!/bin/bash
set -e

echo "==> Installing Beads CLI..."

claude -p "install and initialize beads, and add all recommended skills to claude cli, reference https://github.com/steveyegge/beads/blob/main/docs/INSTALLING.md."
claude -p "/plugin marketplace add steveyegge/beads\
/plugin install beads"
