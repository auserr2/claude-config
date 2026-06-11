---
name: project-saas-studio
description: "Core mission, architecture, and file layout for the AI SaaS Startup Studio in /Users/aminali/Desktop/AI SaaS"
metadata: 
  node_type: memory
  type: project
  originSessionId: f17e5140-bf17-4f74-8a25-ec810b10ecb3
---

The project is an AI-powered SaaS startup studio. The goal is to identify, validate, build, and launch software products with the highest probability of making money, with minimal ongoing human work.

**Why:** User wants agents to do the heavy lifting while they approve key decisions.

**How to apply:** Always follow the CLAUDE.md + studio/workflow/pipeline.md workflow. Validation (score ≥ 85/100) must happen before any building. Kill bad ideas fast.

## What's been built (as of 2026-06-10)

44 files creating the full studio infrastructure:

- **7 slash commands** in `.claude/commands/`: `/studio`, `/research`, `/score`, `/validate`, `/blueprint`, `/build-mvp`, `/launch`
- **22 agent prompts** in `studio/agents/`: master, 6 research, 4 validation, 3 product, 6 build, 4 launch
- **SQLite database** at `studio/database/studio.db` with 6 tables + 2 views (initialized)
- **Scoring rubric** at `studio/scoring/rubric.md` — 7 dimensions, 100 points, 85 threshold
- **Workflow docs** at `studio/workflow/` — pipeline + orchestration rules
- **Evaluation framework** at `studio/evaluation/framework.md`
- **MCP integration plan** at `studio/mcp/integration-plan.md`
- **Memory schema** at `studio/memory/SCHEMA.md`

## Pipeline order

1. `/research` → find 100+ opportunities
2. `/score {id}` → score on 100-pt rubric (gate: ≥85)
3. `/validate {id}` → Bull/Bear/Risk/Judge (gate: GO)
4. `/blueprint {id}` → product + UX + tech spec (gate: human approval)
5. `/build-mvp {id}` → build the product (gate: QA + security pass)
6. `/launch {id}` → landing page + copy + SEO + analytics

## Hard rules

No generic chatbots, note-taking apps, to-do apps, AI wrappers, or products without a paying buyer. Prefer boring B2B, niche SaaS, workflow automation.
