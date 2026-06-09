---
name: feedback_new_project_setup
description: "Always auto-setup git + GitHub for any new project directory, without being asked"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: aa969e4b-f2ef-4639-b797-ba5ca4179ffc
---

Whenever creating or starting work in a new project directory, always initialize it as a git repo with a private GitHub remote and do an initial push — without waiting to be asked.

**Why:** User has cross-device sync (Mac + PC) via sync.sh that auto-syncs all git repos in ~/Desktop, ~/Documents, ~/projects. Any new project that isn't a git repo with a remote won't sync.

**How to apply:** On any new project folder — whether user asks to "create a project", "start a new bot", "build X" — immediately run: git init, create private GitHub repo via API (token at ~/.claude-sync/.token, GitHub user is auserr2), add remote, initial commit, push. Do this before writing any code.
