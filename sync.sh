#!/bin/bash
# Claude Config Sync - push/pull settings to GitHub

SYNC_DIR="$HOME/.claude-sync"
SETTINGS_SRC="$HOME/.claude/settings.json"

push() {
  cp "$SETTINGS_SRC" "$SYNC_DIR/settings.json"
  cd "$SYNC_DIR"
  git add -A
  git diff --staged --quiet && exit 0
  git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
  git push -q
}

pull() {
  cd "$SYNC_DIR"
  git pull -q
  cp "$SYNC_DIR/settings.json" "$SETTINGS_SRC"
  echo "Claude config updated. Re-run any new MCP servers from mcp-setup.sh if needed."
}

case "$1" in
  push) push ;;
  pull) pull ;;
  *) echo "Usage: sync.sh [push|pull]" ;;
esac
