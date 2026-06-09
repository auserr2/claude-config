#!/bin/bash
SYNC_DIR="$HOME/.claude-sync"
CLAUDE_DIR="$HOME/.claude"

push() {
  cp "$CLAUDE_DIR/settings.json" "$SYNC_DIR/settings.json" 2>/dev/null
  for mem_dir in "$CLAUDE_DIR/projects"/*/memory; do
    [ -d "$mem_dir" ] || continue
    project=$(basename "$(dirname "$mem_dir")")
    mkdir -p "$SYNC_DIR/projects/$project/memory"
    cp -r "$mem_dir/." "$SYNC_DIR/projects/$project/memory/" 2>/dev/null
  done
  cd "$SYNC_DIR"
  git add -A
  git diff --staged --quiet && exit 0
  git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
  git push origin HEAD:main -q
}

pull() {
  cd "$SYNC_DIR"
  git pull -q
  cp "$SYNC_DIR/settings.json" "$CLAUDE_DIR/settings.json" 2>/dev/null
  for mem_dir in "$SYNC_DIR/projects"/*/memory; do
    [ -d "$mem_dir" ] || continue
    project=$(basename "$(dirname "$mem_dir")")
    mkdir -p "$CLAUDE_DIR/projects/$project/memory"
    cp -r "$mem_dir/." "$CLAUDE_DIR/projects/$project/memory/" 2>/dev/null
  done
  echo "Claude config updated. Re-run any new MCP servers from mcp-setup.sh if needed."
}

case "$1" in
  push) push ;;
  pull) pull ;;
  *) echo "Usage: sync.sh [push|pull]" ;;
esac
