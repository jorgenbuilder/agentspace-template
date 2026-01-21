#!/bin/bash
set -e

claude -p "$(cat <<'EOF'
Install the following dependencies:

## Install `agent-browser`
sudo npm install -g agent-browser
sudo agent-browser install --with-deps

## Install `vercel` cli
sudo npm i -g vercel
EOF
)"