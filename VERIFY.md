# Agentspace Verification Checklist

Use this checklist to verify that your Codespace is properly configured and working.

## Part 1: Local `makespace` Command Verification

Test the local command before creating projects:

```bash
# Test help/usage
makespace --help

# Create a test project
makespace testproj-$(date +%s)
```

**Expected results:**
- [ ] Command executes without errors
- [ ] Repository is created on GitHub under correct owner
- [ ] Repository is cloned to local machine
- [ ] Codespace is created and opens automatically

## Part 2: Codespace Environment Verification

Run these commands in your Codespace terminal:

### Secrets Validation

```bash
# Check ANTHROPIC_API_KEY exists and is non-empty
echo "$ANTHROPIC_API_KEY" | wc -c
# Expected: > 1

# Check GH_PAT exists and is non-empty
echo "$GH_PAT" | wc -c
# Expected: > 1
```

**Checklist:**
- [ ] `ANTHROPIC_API_KEY` is available (character count > 1)
- [ ] `GH_PAT` is available (character count > 1)

### Claude CLI Verification

```bash
# Verify Claude CLI is installed and wrapped
claude --version

# Check wrapper location
which claude

# Verify original binary exists
which claude.real

# Test original binary
claude.real --version
```

**Checklist:**
- [ ] `claude --version` works without errors
- [ ] `which claude` points to wrapper (e.g., `/home/vscode/.local/bin/claude`)
- [ ] `claude.real` exists and is executable
- [ ] `claude.real --version` works without errors

### Git Configuration Verification

```bash
# Check git user configuration
git config --global user.name
git config --global user.email

# Check PAT is configured for GitHub URLs
git config --global --get url."https://github.com/".insteadOf

# Test GitHub CLI authentication
gh auth status

# Test cross-repo cloning (use a public repo you have access to)
git clone https://github.com/jorgenbuilder/test-repo.git /tmp/test-clone
# Should clone without prompting for credentials
```

**Checklist:**
- [ ] Git user name is set to your GitHub username
- [ ] Git email is set correctly
- [ ] URL rewrite is configured for GitHub (shows `https://*@github.com/`)
- [ ] GitHub CLI shows authenticated status
- [ ] Cross-repo clone works without authentication prompts

### Beads Verification

```bash
# Check Beads CLI is installed
bd --version

# Verify Beads is on PATH
which bd

# Check Beads configuration
cat ~/.config/beads/config.json
```

**Checklist:**
- [ ] `bd --version` works and shows version number
- [ ] `bd` is found in PATH
- [ ] Beads config file exists

### Claude Skills Verification

```bash
# List installed Claude skills
claude.real skill list

# Check if beads skill is installed
claude.real skill list | grep -i beads
```

**Checklist:**
- [ ] `claude skill list` executes (or shows appropriate error if skills not yet supported)
- [ ] Beads skill appears in the list (if skill system is active)

### Development Tools Verification

```bash
# Verify essential tools
which tmux
which fzf
which rg
which jq
which node
which python3
which chromium-browser

# Check versions
node --version
python3 --version
```

**Checklist:**
- [ ] All essential tools are installed and on PATH
- [ ] Node.js version is 20.x
- [ ] Python version is 3.x

## Part 3: End-to-End Workflow Verification

Test a complete agent workflow:

```bash
# Start Claude with a simple task
claude

# In Claude, try these commands:
# 1. Test that permissions are skipped (should not prompt)
# 2. Test that browser integration works
# 3. Test git operations
```

**Checklist:**
- [ ] Claude starts without permission prompts (wrapper flags work)
- [ ] Claude can execute git commands
- [ ] Claude can read/write files
- [ ] Claude `--chrome` flag is active (if testable)

## Part 4: Bootstrap Scripts Verification

Check that all bootstrap scripts ran successfully:

```bash
# Check postCreateCommand log (if available in Codespaces)
# Look for success messages from each script

# Manually verify each script is idempotent
.devcontainer/scripts/00-validate-secrets.sh
.devcontainer/scripts/20-configure-git.sh
.devcontainer/scripts/30-wrap-claude.sh
.devcontainer/scripts/40-install-beads.sh
.devcontainer/scripts/50-install-claude-skills.sh
```

**Checklist:**
- [ ] All scripts execute without errors
- [ ] Scripts are idempotent (can run multiple times safely)
- [ ] Success messages appear for each script

## Troubleshooting

If any checks fail:

1. **Secrets missing**: Run `./scripts/attach-codespaces-secrets.sh <owner>/<repo>` and rebuild Codespace
2. **Claude not working**: Check that `ANTHROPIC_API_KEY` is set and valid
3. **Git auth failing**: Check that `GH_PAT` is set and has correct scopes
4. **Tools missing**: Rebuild Codespace to re-run Dockerfile installation
5. **Scripts failed**: Check Codespace creation logs for error messages

## Success Criteria

Your Codespace is fully verified when:

- [ ] All secrets are available
- [ ] Claude CLI is installed and wrapped correctly
- [ ] Git is configured for cross-repo operations
- [ ] Beads is installed and configured
- [ ] All development tools are available
- [ ] Bootstrap scripts are idempotent
- [ ] End-to-end agent workflow works without manual intervention

## Notes

- The first Codespace creation may take 3-5 minutes for bootstrap
- Subsequent rebuilds should be faster due to Docker layer caching
- If you encounter issues, check the Codespace creation logs in GitHub
