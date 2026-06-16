---
name: website-audit-june2025
description: "Full P0+P1 audit and implementation pass on the AI4Seniors website — security, accessibility, fonts, copy rewrite"
metadata: 
  node_type: memory
  type: project
  originSessionId: 77302325-8a8e-418e-b3d9-b19310a12c0c
---

Full audit and implementation completed June 2025.

**What was done:**
- Brand fonts (Lexend + Source Sans 3) wired up via next/font/google; tailwind config updated to use CSS vars `--font-heading` / `--font-body` (fonts were previously declared but never loaded — Arial fallback silently in use)
- Security headers added to next.config.mjs: CSP, X-Frame-Options DENY, X-Content-Type-Options, Referrer-Policy, Permissions-Policy
- postcss vulnerability resolved via `overrides` in package.json (bumped to ^8.5.10; eliminated Next.js's nested vulnerable copy)
- Skip-to-content link added to SiteNav (sr-only, focus:not-sr-only)
- `<main id="main-content" tabIndex={-1}>` added to homepage (app/page.tsx) and PlaceholderPage
- sr-only H1 + description added to ContinuousHomepage (screen reader accessible homepage content)
- Animated decorative H1 changed to `<p aria-hidden>` (decorative, not page heading)
- Floating bottom CTA made aria-hidden + tabIndex=-1 permanently (nav CTA is the accessible primary CTA)
- Hero copy (MOMENTS array) rewritten to brand voice: warm, direct, plain-language, ≤15 words/line
- prefers-reduced-motion hardened: cursor influence, time-based waves, and rAF loop all gated (single paint then stops)
- Visibility API: rAF loop pauses when tab is hidden (battery/CPU)
- Dead `aria-label` removed from canvas nested inside aria-hidden parent
- SiteFooter component created (nav links + copyright); added to PlaceholderPage
- Custom 404 page (app/not-found.tsx) created
- Per-page metadata added to About, Course, Resources, Contact
- npm audit: 0 vulnerabilities

**Spline verdict:** Rejected. Generic demo scene from third-party CDN, heavy WebGL runtime (~2MB+), requires shadcn infrastructure not present, filler copy violating brand voice guidelines. Design doc explicitly prohibits 3D for novelty.

**Why:** Accessibility for 65+ audience, performance on older devices, and security posture for nonprofit educational site.

**How to apply:** These are baseline quality expectations for all future work on this site. Don't regress any of these.
