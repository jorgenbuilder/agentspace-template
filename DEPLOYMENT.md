# Deployment Guide

This guide walks you through deploying the agentspace template to GitHub and setting up the local `makespace` command.

## Part 1: Create GitHub Codespaces Secrets

Before deploying the template, create user-level Codespaces secrets:

1. Go to: https://github.com/settings/codespaces
2. Click "New secret"
3. Create these secrets:

   **ANTHROPIC_API_KEY**
   - Your Anthropic API key
   - Get from: https://console.anthropic.com/settings/keys

   **GH_PAT**
   - GitHub Personal Access Token
   - Required scopes: `repo`, `codespace`
   - Create at: https://github.com/settings/tokens

## Part 2: Deploy Template Repository to GitHub

### Step 1: Initialize Git Repository

```bash
cd /path/to/agentspace  # This directory
git init
git add .
git commit -m "Initial commit: Agentspace template"
```

### Step 2: Create GitHub Repository

```bash
# Create the repository (adjust owner as needed)
gh repo create jorgenbuilder/agentspace-template --public --source . --remote origin --push
```

Alternatively, create via GitHub web UI:
1. Go to: https://github.com/new
2. Repository name: `agentspace-template`
3. Choose visibility (public recommended for templates)
4. Do NOT initialize with README, .gitignore, or license
5. Click "Create repository"
6. Follow instructions to push existing repository

### Step 3: Mark as Template Repository

1. Go to repository Settings on GitHub
2. Under "General", check "Template repository"
3. Save changes

Your template is now ready!

## Part 3: Install Local `makespace` Command

Follow the instructions in `local-install/INSTALL.md`.

**Quick install** (recommended):

```bash
# Copy to ~/.local/bin
mkdir -p ~/.local/bin
cp local-install/makespace ~/.local/bin/makespace
chmod +x ~/.local/bin/makespace

# Add to PATH if needed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
makespace --help
```

## Part 4: Configure Defaults (Optional)

### Update Default Owner

Edit `~/.local/bin/makespace` and change:

```bash
DEFAULT_OWNER="jorgenbuilder"  # Change to your GitHub username
```

### Update Default Template

```bash
DEFAULT_TEMPLATE="jorgenbuilder/agentspace-template"  # Change to your template repo
```

## Part 5: Test the Complete Workflow

### Create a test project

```bash
makespace test-project-$(date +%s)
```

This will:
1. Create a new repository from your template
2. Clone it locally
3. Attach Codespaces secrets
4. Create and open a Codespace

### Verify the Codespace

Once the Codespace opens (3-5 minutes for first boot):

1. Open terminal in Codespace
2. Run verification checks from `VERIFY.md`:
   ```bash
   # Check secrets
   echo "$ANTHROPIC_API_KEY" | wc -c  # Should be > 1
   echo "$GH_PAT" | wc -c             # Should be > 1

   # Check Claude
   claude --version
   which claude
   claude.real --version

   # Check Git
   gh auth status
   git config --global user.name

   # Check Beads
   bd --version

   # Test cross-repo clone
   git clone https://github.com/<some-public-repo>.git /tmp/test
   ```

3. If all checks pass, your template is working correctly!

### Clean up test project

```bash
# Delete the test repository
gh repo delete <owner>/test-project-XXXXX --yes
```

## Part 6: Customize the Template (Optional)

### Add More Claude Skills

Edit `.devcontainer/scripts/50-install-claude-skills.sh`:

```bash
CLAUDE_SKILLS=(
  "beads"
  "your-skill@version"
  # Add more here
)
```

### Add More Secrets

1. Create user Codespace secret in GitHub Settings
2. Add to `.devcontainer/devcontainer.json`:
   ```json
   "containerEnv": {
     "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}",
     "GH_PAT": "${localEnv:GH_PAT}",
     "YOUR_SECRET": "${localEnv:YOUR_SECRET}"
   }
   ```
3. Add validation in `.devcontainer/scripts/00-validate-secrets.sh`
4. Add to `scripts/attach-codespaces-secrets.sh`:
   ```bash
   SECRETS=(
     "ANTHROPIC_API_KEY"
     "GH_PAT"
     "YOUR_SECRET"
   )
   ```

### Modify Claude Wrapper Flags

Edit `.devcontainer/scripts/30-wrap-claude.sh`:

```bash
exec "$(dirname "$0")/claude.real" --your-flags-here "$@"
```

### Add More Tools to Dockerfile

Edit `.devcontainer/Dockerfile` and add installation commands:

```dockerfile
RUN apt-get update && apt-get install -y \
    your-tool \
    another-tool
```

## Troubleshooting

### Template not appearing

- Ensure you checked "Template repository" in Settings
- Repository must be public or you must have access

### Secrets not working in Codespace

1. Verify secrets exist: https://github.com/settings/codespaces
2. Check repository has access to secrets:
   ```bash
   ./scripts/attach-codespaces-secrets.sh <owner>/<repo>
   ```
3. Rebuild Codespace

### Bootstrap scripts failing

1. Check Codespace creation logs on GitHub
2. Look for error messages in postCreateCommand output
3. Test scripts manually in Codespace terminal:
   ```bash
   .devcontainer/scripts/00-validate-secrets.sh
   # etc.
   ```

### makespace command fails

1. Check prerequisites: `gh --version`, `jq --version`
2. Verify authentication: `gh auth status`
3. Check repository doesn't already exist
4. Ensure secrets exist in GitHub Settings

## Updating the Template

When you make changes to the template:

```bash
cd /path/to/agentspace-template
git add .
git commit -m "Update: description of changes"
git push origin main
```

New projects created with `makespace` will use the updated template.

Existing projects will NOT be updated automatically. To update existing projects:
1. Manually merge changes, or
2. Create a new project and migrate your work

## Maintenance

### Pinning Versions

For production use, consider pinning versions in:

- `.devcontainer/Dockerfile`: Node.js version, tool versions
- `.devcontainer/scripts/40-install-beads.sh`: Beads CLI version
- `.devcontainer/scripts/50-install-claude-skills.sh`: Claude skill versions

Example:
```bash
npm install -g @beads/cli@1.2.3  # Pin to specific version
```

### Regular Updates

1. Update Node.js version in Dockerfile
2. Update tool versions
3. Update Claude skills
4. Test with a new project
5. Commit and push changes

## Success Criteria

Your deployment is successful when:

- Template repository exists on GitHub and is marked as template
- `makespace` command is installed and working locally
- Creating a test project works end-to-end
- Codespace boots successfully with all tools configured
- All verification checks in VERIFY.md pass

## Next Steps

1. Share the template with your team
2. Create your first real project with `makespace`
3. Customize the template for your specific needs
4. Document any custom workflows in the template README

## Support

For issues with:
- **Template setup**: Check this guide and VERIFY.md
- **Codespaces**: See GitHub Codespaces documentation
- **Claude Code**: See Claude Code documentation
- **Beads**: See Beads documentation
- **makespace command**: Check local-install/INSTALL.md
