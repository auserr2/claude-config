---
name: project-video-series
description: "AI4Seniors 9-episode video series content repository — structure, status, and tone rules"
metadata: 
  node_type: memory
  type: project
  originSessionId: 73b5982c-d828-401e-ab1d-bd32b3e86c61
---

Built a content production repository inside the Next.js website root for a 9-episode video series teaching AI to seniors (65+).

**Why:** User wants to produce educational video content alongside the website. Content lives in markdown files; the website serves as the public face.

**How to apply:** When asked to write or extend episode scripts, graphics prompts, or handouts, follow the tone rules in `CLAUDE.md` (max 15 words/sentence, no jargon, warm/patient voice). Do not touch `app/`, `components/`, or `lib/`.

## Structure created
- `CLAUDE.md` — session context + tone rules + episode status table
- `README.md` — 9-episode syllabus
- `scripts/` — ep1 (complete), ep7 (complete), ep2–ep6/ep8–ep9 (outlines)
- `graphics_prompts/` — ep1_assets.md, ep7_assets.md (6 assets each, `--ar 16:9`)
- `companion_sheets/` — ep7_handout.md (printable large-print safety card)

## Episode status as of 2026-06-14
| Ep | Title | Script | Assets | Handout |
|----|-------|--------|--------|---------|
| 1 | What Exactly is AI? | Complete | Complete | — |
| 7 | Digital Self-Defense | Complete | Complete | Complete |
| 2–6, 8–9 | Various | Outline only | — | — |

## Key tone rules
- Forbidden words: algorithm, LLM, neural network, machine learning, prompt engineering, API, latency, model
- Max 15 words/sentence in scripts
- Analogies: digital librarian (Ep1), patient assistant (Ep3), trusted family member (Ep7)
- Script format: `| Visual Cue | Narration |` two-column table
