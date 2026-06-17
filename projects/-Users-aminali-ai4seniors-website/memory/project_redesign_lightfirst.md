---
name: project-redesign-lightfirst
description: Light-first redesign on redesign-experiment branch; stable-site restore point; teal-700 contrast rule
metadata: 
  node_type: memory
  type: project
  originSessionId: f5ef891b-77e6-4319-a77f-6577f5a54ea5
---

Redesign of the AI4Seniors website (Next.js 16 + Tailwind) is happening on git branch **`redesign-experiment`**. The pre-redesign site is frozen on branch **`stable-site`** as a restore point (`git checkout stable-site`). Repo git was initialized during this work (was not a repo before, as of 2026-06-17).

Direction: **light-first** (warm off-white, navy text, teal/blue accents), calm and senior-friendly. The old site was hard-coded dark (`<html className="dark">`, navy `PageLayout`, white text, a WebGL shader homepage) — all removed.

Done: light flip across all pages + new light homepage hero (step 1); homepage trust band, 12-step Coursera-style Course learning path, senior-friendly nav with visible labels + ≥44px targets (items 3–5). Unused 21st.dev effect components were the "block dump" — `tubelight-navbar` deleted; `shape-landing-hero`, `background-paths`, `shader-animation`, `splite`, `spotlight` still present and unused.

**Contrast gotcha — do NOT revert:** brand teal `#14B8A6` (Tailwind `teal` / old `--primary`) fails WCAG as text or as a button fill with white text (~2.5:1). Interactive teal now uses **teal-700 `#0F766E`** via `--primary` (5.47:1). Use `text-primary` / `bg-primary` for any teal text/button; keep bright `#14B8A6` only for decorative tint backgrounds (`bg-teal/10`). Note: `extend.colors.teal` is a single value, so Tailwind teal-scale utilities (`teal-400`, `teal-700`) do NOT exist.

Homepage entrance is **CSS-only** (`.rise` classes in globals.css, gated by `prefers-reduced-motion: no-preference`) — not framer-motion `initial opacity:0` — so content is visible without JS.

Open decisions for the user: (1) canonical lesson count — CLAUDE.md says 9 episodes, the live Course page lists **12** per user instruction; (2) Course lessons show "Coming soon" with no Watch button until a real video `href` is added to the `lessons` array in `components/CoursePage.tsx`. Related: [[project_website_audit_june2025]].
