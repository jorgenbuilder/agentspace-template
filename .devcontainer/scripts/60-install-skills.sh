#!/bin/bash
set -e

#!/bin/bash
set -e

claude -p "$(cat <<'EOF'
Install the following skills:

npx skills add vercel-labs/agent-skills -s "vercel-react-best-practices" -a claude-code -g -y
npx skills add vercel-labs/agent-skills -s "web-design-guidelines" -a claude-code -g -y
npx skills add vercel-labs/agent-browser -s "agent-browser" -a claude-code -g -y
EOF
)"

