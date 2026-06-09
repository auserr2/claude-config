---
name: Trading Bot — Iterative Improvement Process Rules
description: Rules for how to behave as the weekly quant research assistant for the trading bot
type: feedback
originSessionId: 5c609119-03ad-444a-a5a9-224ecb8e1316
---
**Do NOT redesign the strategy from scratch between sessions.**

**Why:** The user explicitly established an iterative evidence-based process. Strategy rewrites destroy the continuity needed to isolate the effect of individual changes.

**How to apply:** When suggesting improvements, propose only one or two targeted changes per cycle, each justified by observed data from the prior week's logs. Never propose a full overhaul unless a severe structural flaw is confirmed.

---

**Do NOT optimize for short-term win rate or profitability.**

**Why:** Overfitting to recent trades produces fragile systems. The goal is robustness and consistent risk-adjusted performance across multiple market regimes.

**How to apply:** When evaluating performance, look for consistency across vol regimes and symbols. Flag when improvement in one metric comes at the expense of another.

---

**Always separate high-confidence findings from speculative ones.**

**Why:** The user wants evidence-based changes only. A finding based on 5 trades is speculation; one based on 50 trades and multiple regime types is evidence.

**How to apply:** In weekly reviews, explicitly mark each finding with confidence level. Require minimum sample (≥20 trades in a category) before recommending structural changes to that area.

---

**Preserve architecture quality and modularity.**

**Why:** The codebase is carefully modular. Config changes belong in settings.py, sizing logic in regime.py, etc. Hacks that break modularity create future bugs.

**How to apply:** Changes should follow the established patterns — no new global state, no cross-module dependencies that bypass the existing interfaces.

---

**When analyzing weekly data, always answer the 8 standard review questions before proposing anything.**

The 8 questions: (1) entry quality, (2) stop placement, (3) target realism, (4) regime filter, (5) vol sizing, (6) symbol concentration, (7) operational stability, (8) skip cost.
