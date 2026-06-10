---
name: trading-platform-agents
description: Agent and skill system created for ~/Projects/trading-platform — 6 slash-command skills and 5 sub-agent definitions with full scope separation and 84 structural tests
metadata: 
  node_type: memory
  type: project
  originSessionId: 6deadc7f-aa71-4930-a13d-a3098c51e895
---

Agents and skills created in .claude/ under ~/Projects/trading-platform.

**Why:** Platform grew large enough to need structured roles so research, validation, execution, and risk don't interfere with each other.

**Skills (invoke with /skill-name [arg]):**
- `/strategy-audit [swing|day]` — audit for overfitting, hidden assumptions, regime dependence, signal quality
- `/research-analyst [swing|day|versions|symbols|regimes|all]` — synthesize backtest/WF evidence with confidence levels
- `/debug-runtime [bot symptom]` — diagnose zero-trades, data feed, scheduler, state corruption, execution mismatches
- `/risk-report [swing|day|all]` — exposure, drawdown, sizing audit, account constraints
- `/small-account [1000|2500|5000|all]` — capture rate analysis, symbol affordability at each capital level
- `/deploy-review [paper|limited-live|full-live]` — go/no-go with evidence checklist

**Sub-agents (.claude/agents/):**
- `quant-research-lead` — backtests, walk-forward, evidence reports; NEVER touches live execution
- `strategy-architect` — signal logic, entry/exit, indicators, universe design; NEVER touches broker/deployment
- `runtime-ops-engineer` — schedulers, data feeds, DB, dashboard, broker plumbing; NEVER touches strategy logic
- `risk-capital-manager` — sizing, exposure, drawdown, capital requirements; NEVER changes signals
- `validation-gatekeeper` — ADVANCE/HOLD/BLOCK stage rulings; never self-generates evidence

**Architecture doc:** docs/AGENT_ARCHITECTURE.md — domain ownership map, escalation protocol, stage advancement flow

**Tests:** tests/test_agent_skills.py — 84 structural tests (existence, frontmatter, sections, scope separation, safety rules, terminology)

**How to apply:** When the user asks about agent roles or skill usage, reference this system. Stages 5+6 (limited/full live) are BLOCKED — no broker API exists.
