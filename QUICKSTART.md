# Agentspace - Quick Start Guide

Get from zero to working agentspace in under 10 minutes.

## Prerequisites (5 minutes)

### 1. Create GitHub Secrets

Go to https://github.com/settings/codespaces and create:

```
ANTHROPIC_API_KEY = sk-ant-...  (your Anthropic API key)
GH_PAT = ghp_...                (GitHub PAT with repo + codespace scopes)
```

### 2. Install GitHub CLI

```bash
# macOS
brew install gh

# Other platforms: https://cli.github.com/
```

### 3. Authenticate GitHub CLI

```bash
gh auth login
```

### 4. Install jq

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

## Deploy Template (2 minutes)

```bash
cd /path/to/agentspace

# Initialize and push to GitHub
git init
git add .
git commit -m "Initial commit: Agentspace template"
gh repo create jorgenbuilder/agentspace-template --public --source . --push
```

Go to the repository settings on GitHub and check "Template repository".

## Install makespace Command (1 minute)

```bash
# Copy to your PATH
mkdir -p ~/.local/bin
cp local-install/makespace ~/.local/bin/makespace
chmod +x ~/.local/bin/makespace

# Add to PATH (if needed)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
makespace --help
```

## Create Your First Project (1 minute + 3-5 minutes bootstrap)

```bash
makespace my-first-project
```

This will:
1. Create repository from template
2. Clone it locally
3. Attach secrets
4. Create and open Codespace

Wait 3-5 minutes for the Codespace to bootstrap.

## Verify It Works (1 minute)

In the Codespace terminal:

```bash
# Quick verification
echo "$ANTHROPIC_API_KEY" | wc -c  # Should show > 1
claude --version                    # Should work
bd --version                       # Should work
gh auth status                     # Should show logged in

# Test a simple Claude command
claude
```

If all works, you're ready to go! 🎉

## What You Get

When you run `makespace project-name`, you get:

- Fresh repo from template
- Local git clone
- GitHub Codespace with:
  - Claude Code CLI (auto-configured)
  - Beads issue tracker
  - Git configured for cross-repo operations
  - All dev tools: Node 20, Python 3, tmux, fzf, ripgrep, jq
  - Your API keys and tokens pre-configured
  - Ready to use with no manual setup

## Next Steps

- Read `README.md` for template features
- Check `VERIFY.md` for complete verification
- See `DEPLOYMENT.md` for customization
- Use `makespace --help` for command options

## Common Issues

**Command not found: makespace**
```bash
# Ensure PATH includes ~/.local/bin
echo $PATH | grep -o "$HOME/.local/bin"

# If empty, add it
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Secrets not working**
```bash
# Verify secrets exist in GitHub Settings
# Then attach them to your repo:
./scripts/attach-codespaces-secrets.sh owner/repo-name

# Rebuild the Codespace
```

**Repository already exists**
```bash
# Delete it first
gh repo delete owner/repo-name --yes

# Or use a different name
makespace my-project-v2
```

## Tips

- Use `claude.real` to bypass the wrapper when needed
- All bootstrap scripts are idempotent and can be re-run
- Check Codespace logs on GitHub if bootstrap fails
- First Codespace takes 3-5 minutes, rebuilds are faster

---

That's it! You now have a production-ready AI development template.

For detailed documentation, see:
- `SUMMARY.md` - Complete overview
- `DEPLOYMENT.md` - Full deployment guide
- `README.md` - Template documentation
- `VERIFY.md` - Verification checklist
