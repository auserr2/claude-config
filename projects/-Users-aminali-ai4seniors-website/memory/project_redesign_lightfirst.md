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

RESOLVED (2026-06-17): canonical curriculum is the **8-lesson course** in `COURSE_ROADMAP.md` (not 9, not the interim 12). Website Course page + homepage/about/metadata aligned to those 8. Audience = **seniors-first, beginner-friendly** (AI4Seniors brand kept). Item 6 cleanup done: 10 unused components, 7 deps removed; `components/ui/` + `lib/` gone; light-only (dark mode removed). Authoritative website doc is now **`DESIGN_REVIEW.md`**; old `AI4SENIORS_WEBSITE_DESIGN_SYSTEM.md` marked SUPERSEDED.

Still open: (1) Course lessons stay "Coming soon" until a real video `href` is added per lesson in `components/CoursePage.tsx`; (2) CSP in `next.config.mjs` still has stale Spline allowances to prune. Related: [[project-video-series]], [[project_website_audit_june2025]].
