#!/bin/bash
SYNC_DIR="$HOME/.claude-sync"
CLAUDE_DIR="$HOME/.claude"
TOKEN=$(cat "$SYNC_DIR/.token" 2>/dev/null)

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

build_manifest() {
  # Write owner/repo for every local git repo that has a GitHub remote
  > "$SYNC_DIR/repos.txt"
  for scan_dir in "${SCAN_DIRS[@]}"; do
    [ -d "$scan_dir" ] || continue
    for dir in "$scan_dir"/*/; do
      [ -d "$dir/.git" ] || continue
      url=$(git -C "$dir" remote get-url origin 2>/dev/null)
      repo=$(echo "$url" | grep -oE '[^/:]+/[^/]+$' | sed 's/\.git$//')
      [ -n "$repo" ] && echo "$repo" >> "$SYNC_DIR/repos.txt"
    done
  done
}

clone_from_manifest() {
  [ -f "$SYNC_DIR/repos.txt" ] || return
  while IFS= read -r repo; do
    [ -n "$repo" ] || continue
    name=$(basename "$repo")
    # Skip if already cloned anywhere in scan dirs
    for scan_dir in "${SCAN_DIRS[@]}"; do
      [ -d "$scan_dir/$name/.git" ] && continue 2
    done
    # Clone to Desktop by default
    git clone -q "https://$TOKEN@github.com/$repo.git" "$HOME/Desktop/$name" 2>/dev/null
    git -C "$HOME/Desktop/$name" config user.email "sync@claude-config" 2>/dev/null
    git -C "$HOME/Desktop/$name" config user.name "Claude Sync" 2>/dev/null
  done < "$SYNC_DIR/repos.txt"
}

push() {
  cp "$CLAUDE_DIR/settings.json" "$SYNC_DIR/settings.json" 2>/dev/null
  for mem_dir in "$CLAUDE_DIR/projects"/*/memory; do
    [ -d "$mem_dir" ] || continue
    project=$(basename "$(dirname "$mem_dir")")
    mkdir -p "$SYNC_DIR/projects/$project/memory"
    cp -r "$mem_dir/." "$SYNC_DIR/projects/$project/memory/" 2>/dev/null
  done

  build_manifest

  cd "$SYNC_DIR"
  git add -A
  git diff --staged --quiet || { git commit -m "sync: $(date '+%Y-%m-%d %H:%M')" -q && git push origin HEAD:main -q; }

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

  clone_from_manifest

  for scan_dir in "${SCAN_DIRS[@]}"; do
    [ -d "$scan_dir" ] || continue
    for dir in "$scan_dir"/*/; do
      [ -d "$dir/.git" ] || continue
      git -C "$dir" pull -q 2>/dev/null
    done
  done

  echo "Claude config updated. Re-run any new MCP servers from mcp-setup.sh if needed."
}

case "$1" in
  push) push ;;
  pull) pull ;;
  *) echo "Usage: sync.sh [push|pull]" ;;
esac
