#!/bin/bash
SYNC_DIR="$HOME/.claude-sync"
CLAUDE_DIR="$HOME/.claude"
TOKEN=$(cat "$SYNC_DIR/.token" 2>/dev/null)

PROJECTS=(
  "$HOME/Desktop/trading-bot|https://$TOKEN@github.com/auserr2/trading-bot.git"
  "$HOME/Desktop/trading-platform|https://$TOKEN@github.com/auserr2/trading-platform.git"
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
  git push -q 2>/dev/null || git push origin HEAD:main -q
}

sync_project_pull() {
  local dir="$1" url="$2"
  if [ ! -d "$dir/.git" ]; then
    git clone -q "$url" "$dir" 2>/dev/null
    git -C "$dir" config user.email "sync@claude-config" 2>/dev/null
    git -C "$dir" config user.name "Claude Sync" 2>/dev/null
    return
  fi
  git -C "$dir" pull -q 2>/dev/null
}

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
  git diff --staged --quiet || { git commit -m "sync: $(date '+%Y-%m-%d %H:%M')" -q && git push origin HEAD:main -q; }

  for entry in "${PROJECTS[@]}"; do
    IFS='|' read -r dir url <<< "$entry"
    sync_project_push "$dir"
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

  for entry in "${PROJECTS[@]}"; do
    IFS='|' read -r dir url <<< "$entry"
    sync_project_pull "$dir" "$url"
  done

  echo "Claude config updated. Re-run any new MCP servers from mcp-setup.sh if needed."
}

case "$1" in
  push) push ;;
  pull) pull ;;
  *) echo "Usage: sync.sh [push|pull]" ;;
esac
