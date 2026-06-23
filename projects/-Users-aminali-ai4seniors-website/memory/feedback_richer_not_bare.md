---
name: feedback-richer-not-bare
description: "User found the bare-minimal redesign \"boring/AI slop\"; wants richer-but-calm UI"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f1c7095d-3149-4d2c-ae65-c4c1664a246c
---

On 2026-06-22 the user said the bare-minimal light-first site felt "very bad, basic, boring" and asked for a richer, more polished UI (reference: https://fin-teens.com). They chose "richer but still calm", keep the warm cream + purple/teal palette, all pages.

**Why:** Pure-minimal whitespace reads as empty/unfinished, not elegant — especially the near-blank About page. They equate "good UI" with visual density + credibility markers (hero visual, stat band, cards, footer), not more whitespace.

**How to apply:** Favor full, layered sections over empty space: two-column hero with a visual (built a CSS lesson-preview card, no assets), stat/trust band, lesson-preview card grid, closing CTA band, and a real multi-column footer ([[project_redesign_lightfirst]]). Keep senior-friendly calm: large text, WCAG-AA, CSS-only motion, honest copy (no fabricated stats/testimonials). New shared component: components/SiteFooter.tsx.
