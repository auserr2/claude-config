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

## Architecture Freeze Status

As of 2026-06-11, the architecture is FROZEN. 4 rounds of ChatGPT audit were run. The verdict after Round 4: stop designing, start running real opportunities. No new components should be added unless a real pipeline failure exposes a gap.

## What's been built (as of 2026-06-11)

63 files creating the full studio infrastructure:

**Slash commands** in `.claude/commands/`:
- `/studio`, `/research`, `/score`, `/validate`, `/blueprint`, `/build-mvp`, `/launch` (original)
- `/interest-test`, `/wedge`, `/monitor`, `/challenge` (added during audit rounds)

**Agent prompts** in `studio/agents/`:
- Master orchestrator
- Research: opportunity-finder, competitor, market, pricing, distribution, automation
- Validation: bull, bear (with status quo/switching cost), risk, distribution-killer (with 90-day revenue path), exit, judge
- Demand validation (with intent quality score: 1/3/5/10/25/40 pts, outreach QA, compliance)
- Product: wedge (new gate), architect, ux, technical-architect
- Build: builder (concierge MVP mode), database, backend, frontend, qa, security
- Launch: copywriting, landing-page, seo, analytics

**Audit trail** in `studio/audits/`:
- audit-001 through audit-006 (ChatGPT multi-round adversarial review, architecture freeze declared)

## Pipeline order (final)

1. `/research` → find 100+ opportunities with source confidence
2. `/score {id}` → score on 100-pt rubric (gate: ≥85, marketplace max 4/7 without evidence)
3. `/validate {id}` → 5 adversarial agents + Judge (gate: GO, 90-day revenue path required)
4. `/interest-test {id}` → intent quality score gate (≥15 pts or 2 strong buyer convos; 25+pts = real money express lane)
5. Post-Demand Revalidation → Judge re-runs with real outreach data
6. `/wedge {id}` → single-feature scope gate (all 6 criteria pass)
7. `/challenge {id}` → adversarial steelman before blueprinting (STRONG/MODERATE/WEAK, not a gate)
8. `/blueprint {id}` → product + UX + tech spec (gate: human approval, default: Concierge MVP)
9. `/build-mvp {id}` → build (gate: QA + security, Concierge MVP = no auth/payments until 3-5 paying customers)
10. `/launch {id}` → landing page + copy + SEO + analytics
11. `/monitor {id}` → kill criteria + revenue quality score (post-mortems in kill-postmortems.md)

## Key scoring rules

- Score ≥ 85/100 required to pass (hard threshold)
- Marketplace extensions: max 4/7 on distribution without direct evidence of organic discovery
- Speculative claims in research: capped at 50% of sub-criterion score
- Auto-reject conditions: 9 pre-checks including "AI wrapper with no moat"

## Hard rules

No generic chatbots, note-taking apps, to-do apps, AI wrappers, or products without a paying buyer. Prefer boring B2B, niche SaaS, workflow automation.
