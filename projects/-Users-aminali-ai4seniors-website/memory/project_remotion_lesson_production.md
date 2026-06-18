---
name: project-remotion-lesson-production
description: "Self-contained Remotion video project in the website repo (production/remotion/) — data-driven lesson templates, Lesson 1 validating the pipeline"
metadata: 
  node_type: memory
  type: project
  originSessionId: 24cd5444-eee6-48d6-8b01-6fbef07cbbfb
---

A **self-contained Remotion project** lives at `production/remotion/` inside the AI4Seniors website repo (NOT the old content-factory `my-video/` from [[content-factory-v3-watchability]] — this is a fresh, isolated build started 2026-06-17, scaffolded 2026-06-18). It has its own `package.json`/`node_modules` and is **isolated from the Next.js site** (nothing here is imported by `app/`). Node 24, Remotion 4.x, React 19, 0 vulns on install.

**Architecture is data-driven** so Lessons 2–8 reuse everything:
- `src/theme/` — theme.ts (brand tokens, mirrors design system), anim.ts (fadeUp/fadeInOut/wipe), fonts.ts (Lexend + Source Sans 3 via @remotion/google-fonts).
- `src/components/` — reusable props-driven templates: TitleCard, LowerThird (has a `durationInFrames` prop because `useVideoConfig()` inside a `Series.Sequence` returns the WHOLE composition length, not the sequence length — pass scene duration so its out-fade is right), KeywordCard (GR-2), KeyIdeaCard (GR-3), NextLessonBumper, Caption.
- `src/lessons/` — types.ts (Scene discriminated union by `kind` + LessonData), SceneView.tsx (kind→component map, includes a visible `placeholder` kind for unbuilt scenes), LessonComposition.tsx (generic `<Series>` sequencer + per-scene lowerThird/caption overlays), registry.ts (array → one `<Composition>` each in Root.tsx, duration auto-summed from scenes).
- Adding a lesson = write `src/lessons/lesson-NN/data.ts` + append to registry.ts.

**Validated 2026-06-18 (no assets rendered):** `npx tsc --noEmit` passes; `npx remotion compositions` registers `lesson-01` = 1920x1080@30, 900 frames (30s). Lesson 1 is a validation cut (Title → placeholder[two-meanings] → Generative keyword → key-idea → placeholder[timeline] → next-lesson bumper); durations are representative, final timing follows narration audio.

Commands (from production/remotion/): `npm run studio` (preview), `npm run compositions` (validate, renders nothing), `npm run render lesson-01 out/lesson-01.mp4` (ONLY when approved). NEVER auto-render final assets.

**Still to build** (placeholders hold their timeline slots): Timeline (GR-4), SplitCard + icon set (GR-1/GR-8), TwoColumn (GR-7), NOT-list (GR-5), analogy pair (GR-6); then expand lesson-01 data to full ~7:36.

Source-of-truth docs: `scripts/lesson-01-what-is-ai.md` (approved script), `storyboards/lesson-01-production-plan.md` (storyboard + reuse strategy). All of `production/ research/ scripts/ storyboards/` is currently **untracked git** by user's choice — do not commit without asking. Related: [[project-video-series]], [[content-factory-v3-watchability]].
