#!/bin/bash
SYNC_DIR="$HOME/.claude-sync"
CLAUDE_DIR="$HOME/.claude"

# Directories to scan for git repos
SCAN_DIRS=(
  "$HOME/Desktop"
  "$HOME/Documents"
  "$HOME/projects"
)

sync_project_push() {
  local dir="$1"
  [ -d "$dir/.git" ] || return
  cd "$dir"
  git config user.email "sync@claude-config" 2>/dev/null
  git config user.name "Claude Sync" 2>/dev/null
  git add -A
  git diff --staged --quiet && return
  git commit -m "auto-sync: $(date '+%Y-%m-%d %H:%M')" -q
  git push -q 2>/dev/null || git push origin HEAD:main -q 2>/dev/null
}

sync_project_pull() {
  local dir="$1"
  [ -d "$dir/.git" ] || return
  git -C "$dir" pull -q 2>/dev/null
}

push() {
  # Sync Claude config
  cp "$CLAUDE_DIR/settings.json" "$SYNC_DIR/settings.json" 2>/dev/null
  for mem_dir in "$CLAUDE_DIR/projects"/*/memory; do
    [ -d "$mem_dir" ] || continue
    project=$(basename "$(dirname "$mem_dir")")
    mkdir -p "$SYNC_DIR/projects/$project/memory"
    cp -r "$mem_dir/." "$SYNC_DIR/projects/$project/memory/" 2>/dev/null
  done
  cd "$SYNC_DIR"
  git add -A
  git diff --staged --quiet || { git commit -m "sync: $(date '+%Y-%m-%d %H:%M')" -q && git push origin HEAD:main -q; }

  # Push all git repos in scan dirs
  for scan_dir in "${SCAN_DIRS[@]}"; do
    [ -d "$scan_dir" ] || continue
    for dir in "$scan_dir"/*/; do
      sync_project_push "$dir"
    done
  done
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

  # Pull all git repos in scan dirs
  for scan_dir in "${SCAN_DIRS[@]}"; do
    [ -d "$scan_dir" ] || continue
    for dir in "$scan_dir"/*/; do
      sync_project_pull "$dir"
    done
  done

  echo "Claude config updated. Re-run any new MCP servers from mcp-setup.sh if needed."
}

case "$1" in
  push) push ;;
  pull) pull ;;
  *) echo "Usage: sync.sh [push|pull]" ;;
esac
