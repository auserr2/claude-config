---
name: project-video-series
description: "AI4Seniors video course — pivoted to 8-lesson general-beginner series with a 5-agent production pipeline (supersedes old 9-episode senior series)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 73b5982c-d828-401e-ab1d-bd32b3e86c61
---

**PIVOT (2026-06-17):** The video course was redirected away from a "for seniors (65+)" framing to a course for **complete beginners / curious adults / non-technical people**. Voice: a great teacher explaining clearly — intelligent, respectful, practical, NOT condescending, NOT over-simplified. Hard ban on AI hype/marketing ("unlock the power of AI", "transform your life", "revolutionary", "game-changing", "cutting-edge", "next-generation", "future-ready").

**Why:** User explicitly restructured the project; the senior-specific tone was dropped.

**How to apply:** Use the new audience/voice above for CONTENT. `CLAUDE.md` and `COURSE_ROADMAP.md` are now both updated to the 8-lesson course (the old 9-episode contradiction is resolved). For the WEBSITE, the user chose **seniors-first, beginner-friendly**: the AI4Seniors brand + senior-first design stays, content is welcoming to any beginner. So website framing (seniors-first) differs slightly from the content-doc framing (general beginners) — intentional.

## New course (8 lessons, ~60 min, ~6–8 min each)
1 What Is AI? · 2 AI Is Already Around You · 3 What AI Can and Cannot Do · 4 AI Scams and Warning Signs · 5 Deepfakes and Fake Content · 6 Privacy and Digital Safety · 7 What Is ChatGPT? · 8 Using AI in Everyday Life

Every lesson = **[ON-CAMERA INTRO]** (~30s, presenter live) + **[MAIN LESSON]** (AI voice narration, cloned presenter voice). See `COURSE_ROADMAP.md`.

## Production pipeline (5 reusable subagents in `.claude/agents/`)
research-agent → script-agent → qa-agent → project-manager-agent (presents, then STOP) → storyboard-agent (only when explicitly approved). Workflow runs ONE lesson at a time; do not generate slides/graphics/future lessons unless approved.

## Directories (new)
- `research/` — dossiers (lesson-NN-<slug>.md)
- `scripts/` — scripts/outlines (lesson-NN-<slug>.md)
- `storyboards/` — visual plans (not created yet)

## Status as of 2026-06-17
- Old 9-episode senior content (scripts/, graphics_prompts/, companion_sheets/) DELETED — recoverable from git snapshot `5c3f029`.
- Lesson 1: dossier ✓ (`research/lesson-01-what-is-ai.md`), script OUTLINE ✓ (`scripts/lesson-01-what-is-ai.md`) — awaiting user approval before full draft.
- WEBSITE aligned to the 8 lessons (CoursePage + homepage/about/metadata; all "Coming soon", no video URLs yet). README rewritten to 8-lesson; `AI4SENIORS_WEBSITE_DESIGN_SYSTEM.md` marked SUPERSEDED → see new `DESIGN_REVIEW.md`. Website details in [[project-redesign-lightfirst]].
- Research gotcha: don't lock specific stats (Pew %, ChatGPT user counts) without refreshing the source first.
