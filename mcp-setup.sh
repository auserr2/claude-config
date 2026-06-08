#!/bin/bash
# Install MCP servers on a new machine
# Usage: GITHUB_TOKEN=ghp_xxx bash mcp-setup.sh

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set"
  echo "Usage: GITHUB_TOKEN=ghp_xxx bash mcp-setup.sh"
  exit 1
fi

echo "Installing MCP servers..."

claude mcp add --scope user github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN \
  -- npx -y @modelcontextprotocol/server-github

echo "MCP servers installed!"
