---
name: content-factory-v2-quality-pipeline
description: AI4Seniors Content Factory quality-first pipeline rebuild — what was changed and why
metadata: 
  node_type: memory
  type: project
  originSessionId: c68f94d7-e3c5-42af-bb8f-20c0aeba1172
---

## Quality-First Pipeline Rebuild — Completed June 11, 2026

**Why:** Original generated videos were "AI slop" — robotic narration, generic DALL-E clip art, no visual system, no quality gates. ChatGPT reviewed the architecture and recommended Creator→Critic→Revision→QA pattern.

**How to apply:** This is now the active pipeline. Run `python3.11 main.py "topic"` from `/Users/aminali/Documents/ai4seniors-content-factory/`.

### Key Changes Made

**New Agents:**
- `agents/script_critic_agent.py` — scores script 1-10 on 7 dimensions; gate is 7.5/10
- `agents/script_revision_agent.py` — rewrites script based on critique (max 3 loops)
- `agents/voice_director_agent.py` — converts final script to TTS-optimized `05_tts_script.txt`

**Updated Files:**
- `prompts/script.md` — stricter forbidden phrases, explicit "short sentences are GOOD" calibration
- `tools/frame_composer.py` — 5 new visual types: step_card, ui_mockup, warning_card, diagram, key_concept
- `tools/scene_planner.py` — outputs visual_type + scene_data per scene (not just dalle_prompt)
- `agents/video_agent.py` — routes visual types to Pillow renderers (no DALL-E for most frames)
- `agents/orchestrator.py` — quality gate pipeline with Script Critic loop

**Key Learning — Script Critic Calibration:**
The initial critic was penalizing SHORT SENTENCES as "too simplistic." This is wrong for this content. Updated the system prompt to explicitly say:
- "You type a question. It types back." → 9/10, this is exactly what we want
- "In summary, ChatGPT is a handy tool" → 3/10, forbidden filler
Fixed script: 8.6/10 score, 0 flags.

**Visual System:**
Old: DALL-E "person at computer" flat illustrations (generic, tells viewer nothing)
New: step_card (numbered steps on cards), ui_mockup (fake ChatGPT interface with actual prompts), warning_card (yellow/red caution), diagram (flow chart with arrows), key_concept (large text on navy)
Result: 0 DALL-E frames used in the "What is ChatGPT?" lesson — all Pillow-rendered

**Current Output Quality:**
- Script: 8.6/10 — passes gate
- Audio: 143s (2.4 min) — NOTE: script is ~400 words, target should be 800+ for 6-8 min
- Video: 2.6 MB, professional look
- Still missing: real avatar, only 7 scene changes in 143s (should be more frequent)

**Length + Visual Density Fixes (June 11, 2026, later session):**
1. ~~Script too short~~ FIXED: `config.py` MIN_SCRIPT_WORDS=850/MAX=1150; new `tools/script_metrics.py` (shared word count, used by orchestrator gate + qa_agent); orchestrator length gate is programmatic (Python counts, never the LLM); `script_revision_agent.py` gets an expansion mode via `critique["length_issue"]` (more examples/steps, never longer sentences); prompts/script.md + templates/script_format.md durations raised to sum 360-460s with explicit 850-1100 word target.
2. ~~Generic scene text~~ FIXED: scene_planner max_tokens 4000→8000, one JSON retry before heuristic fallback (fallback now logs a warning and derives titles/subtitles from actual script sentences), prompt rules require scene_data to quote actual script text.
3. No real avatar — still open, static frames only.
4. ~~Too few visual changes~~ FIXED: PLANNER_SYSTEM targets 12-16s segments with min-scene formula (words/2.3/16); plan_scenes injects "AT LEAST {min_scenes} segments"; `video_agent._split_long_scenes()` hard-guarantees no frame exceeds 20s by splitting per-type (step cards split steps, ui_mockup does a truncated→full reveal, others become key_concept) with zero extra LLM/DALL-E calls.
