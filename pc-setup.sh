#!/bin/bash
# First-time Claude Code setup for a new machine
# Usage: GITHUB_TOKEN=ghp_xxx bash pc-setup.sh

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set"
  echo "Usage: GITHUB_TOKEN=ghp_xxx bash pc-setup.sh"
  exit 1
fi

REPO="auserr2/claude-config"

echo "Cloning Claude config from GitHub..."
git clone https://github.com/$REPO ~/.claude-sync

echo "Applying settings..."
mkdir -p ~/.claude
cp ~/.claude-sync/settings.json ~/.claude/settings.json

echo "Installing MCP servers..."
GITHUB_TOKEN=$GITHUB_TOKEN bash ~/.claude-sync/mcp-setup.sh

echo "Setting up auto-sync hook..."
node -e "
const fs = require('fs');
const path = require('os').homedir() + '/.claude/settings.json';
const s = JSON.parse(fs.readFileSync(path));
s.hooks = s.hooks || {};
s.hooks.Stop = s.hooks.Stop || [];
s.hooks.Stop.push({ hooks: [{ type: 'command', command: 'bash ~/.claude-sync/sync.sh push' }] });
fs.writeFileSync(path, JSON.stringify(s, null, 2));
"

echo ""
echo "Done! Claude Code is fully set up."
echo "Settings, plugins, and MCP servers are all synced."
