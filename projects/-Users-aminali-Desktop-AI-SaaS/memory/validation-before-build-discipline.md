---
name: validation-before-build-discipline
description: Do not advance a product toward build before demand is validated; a blueprint is not evidence of demand
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2742f314-e4ef-4007-8419-beac24d462d1
---

When the demand test is blocked (e.g., missing outreach credentials), do NOT substitute downstream pipeline work — blueprinting, building, more engineering — as a way to "keep going." The user explicitly corrected this: producing a blueprint ahead of the demand gate is allowed only as a cheap, reversible candidate on disk; it is **not** evidence of demand and must not pull effort forward.

Gate for spending further engineering effort on the Shopify Survey product (opp #6, product id 1, `products/shopify-survey/`): only proceed when (1) the demand test actually runs, AND (2) the Intent Quality Score threshold is reached, OR (3) deposits / paid-beta commitments are received. `/build-mvp 6` is human-gated — never run it autonomously.

**Why:** The studio's core rule is validation-before-building (CLAUDE.md + ChatGPT directive). Building the wrong product is the expensive failure mode the whole pipeline exists to prevent. The 72-hour demand test is designed to let the market pick the winner between #6 and #8 — pre-committing engineering to one defeats that.

**How to apply:** When blocked on demand validation, the correct action is to maximize launch readiness (assets, attribution, measurement) and then HOLD — report the blocker, don't manufacture motion. Relates to [[project-saas-studio]].
