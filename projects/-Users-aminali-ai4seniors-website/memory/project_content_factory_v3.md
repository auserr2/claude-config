---
name: content-factory-v3-watchability
description: "AI4Seniors Content Factory V3 — watchability-first redesign with 5 quality gates, beat-based pipeline, demo recording, YouTube layout"
metadata: 
  node_type: memory
  type: project
  originSessionId: cd1af834-be22-4c3f-8e4e-553b41e87968
---

## V3 Watchability-First Redesign — built June 11, 2026

Supersedes the [[content-factory-v2-quality-pipeline]] flow (V2's orchestrator/scene_planner remain in repo but orchestrator.py was rewritten for V3). Run: `python3.11 main.py "topic"` from `/Users/aminali/Documents/ai4seniors-content-factory/`.

**Why:** User judged V2 videos below the quality bar — weak intros, generic "AI explaining AI" scripts, poor visuals, robotic voice. Goal shifted from automation to videos seniors would willingly watch to completion.

**Core architecture — the BEAT is the atomic unit** (one narration paragraph ≈ 10-25s + one visual + its own audio file):

1. **Master Lesson Agent** (`agents/master_lesson_agent.py`) — sub-agents: hook_agent (3 candidates, rubric-scored, best wins), curriculum (objective + "After this video you can ___"), example_agent (worked examples with real prompts/responses, before/after), storytelling_agent (Hook/Overview/Main/Recap/Action Step as JSON beats).
2. **Voice Director** — voice_selection_agent (validates TTS chain LOUDLY at start), narration_quality_agent (per-beat TTS text), pacing_agent (per-beat mp3s with ffprobe-measured durations → exact AV sync, no proportional stretching).
3. **Visual Director** (`agents/visual_director_agent.py`) — priority ladder: demo > annotated_screenshot > diagram > step_card > warning_card > key_concept > image_scene (max 1 DALL-E/lesson). demonstration_planner records Playwright clips of a ChatGPT HTML replica typing the example's exact prompt + streaming response (1400x788, matches layout content region).
4. **Layout compositor** (`tools/layout_compositor.py`) — YouTube-style: content region 1400x788 at (40,80), guide avatar card right column (HeyGen drop-in slot), section label, progress bar. Per-beat MP4 segments concat'd. Avatar: DALL-E instructor cached at assets/avatar/instructor.png, Pillow mascot fallback.
5. **Video Critic** (`agents/video_critic_agent.py`) — reviewers: engagement, educational, senior_accessibility (vision on sampled frames), production (vision). Five gates ≥8/10: hook, script (pre-production, max 3 loops) + visual, voice, educational (post-assembly, max 2 loops, routed revision). Hard NOT APPROVED verdict — no proceed-anyway.

**Verified working (June 11, 2026):** "Asking ChatGPT for recipe ideas" APPROVED on all 5 gates — hook 8.5, script 9.2, visual 8.5, voice 8.7, educational 9.1. 19 beats, 4:05 video, 3 typing demos + response close-ups.

## V3.1 Professional Course Edition (June 11-12, 2026)
User repositioned: professional course lesson, NOT YouTube-style. Changes:
- **3D robot guide** replaces DALL-E avatar: CC0 three.js RobotExpressive GLB, re-tinted AI4Seniors teal (material "Main" → 0x2aada4), rendered via three.js+Playwright (`tools/avatar3d_builder.py`, GLB embedded as data URI — Chromium blocks file:// fetch). Section-aware animation clips: Wave (welcome) / Idle (main) / ThumbsUp (recap, action), cached in assets/avatar3d/, composited as looping overlay (-stream_loop -1).
- **Hook system removed** → `sub_agents/intro_agent.py` writes "Welcome to AI4Seniors..." formula (topic, coverage, why it matters, outcome). Clickbait = hard fail at the Introduction gate.
- **ElevenLabs default voice**: narrator locked = **Alice "Clear, Engaging Educator"** (Xb7hH8MSUJpSbSDYk0k2), scored 9.14/10 by Senior Listener Agent (gpt-audio model listening to real samples; audio-first content order + retry needed, model sometimes replies "please play the audio"). Cached in assets/voice_selection.json. Hard filter excludes broadcaster/announcer/creator names per user rule.
- **Six gates** ≥8: introduction, script, visual, voice, avatar, educational. V3.1 verified APPROVED: "Using ChatGPT to write letters and emails" — intro 9.0, script 8.9, visual 8.5, voice 8.9, avatar 8.0, educational 9.1. Routed revision proven live (visual 7.5→8.5 after re-planning only the 3 flagged beats).

## V3.2 (June 12, 2026) — free voice, agenda layout, anti-redundancy
User feedback: avatar not contributing, voice robotic (was hearing OpenAI fallback), UI mid, content redundant. Changes:
- **Edge neural TTS as the free narrator tier** (`pip install edge-tts`, no key/quota): provider chain = ElevenLabs (quota≥6k) > Edge > OpenAI. Narrator: **en-GB-SoniaNeural at -8% rate, scored 9.06/10** by Senior Listener (vs Alice 9.14 paid). Constants in tools/tts_client.py (EDGE_VOICE/EDGE_RATE).
- **Layout v2**: right rail = live "Lesson outline" agenda (teal checks done / navy pill current / hollow upcoming, AGENDA list in layout_compositor.py); guide shrunk to 220px corner card; content region 1456x819 (demo recorder matches).
- **Anti-redundancy**: storytelling hard rules (every beat adds NEW info, examples must teach different techniques, recap = 3 fresh takeaways); engagement reviewer penalizes redundancy HARD; visual variety rule (max 2 consecutive same type, "after" beats never a third screenshot).
- Verified APPROVED first-pass, no revision loops: "Using ChatGPT to plan healthy meals" — intro 9.2, script 8.4, visual 8.4, voice 8.7, avatar 8.2, educational 9.3. Sonia at 131 wpm.

## V3.3 (June 12, 2026) — motion-visual engine, flagship lesson
User: "UI 1000x better, like an actual video; content should teach ChatGPT itself (controls + prompting), not dietary topics; better voice."
- **`tools/html_visuals.py`** — every beat is now an animated HTML scene recorded by Playwright (1456x819): title_card (navy gradient opener), key_concept (drawn underline), step_list (steps appear one by one), callout (tip/caution), **interface_tour** (ChatGPT replica + moving spotlight dimming all but one control: message_box/send_button/new_chat/sidebar/chat_area), **prompt_pattern** ("how to ask" chips + typed example), demo (restyled chat). Stills get Ken Burns zoompan in the compositor. Visual director maps legacy types onto these; first beat always title_card.
- **Voice round 2**: en-US-BrianMultilingualNeural (Edge, 9.06/10, warm male) replaces Sonia. Samples in assets/voice_samples_edge2/.
- Storytelling has explicit getting-started structure: what-it-is beat → control tour beats (visual_hint "interface tour: X") → prompt formula beats ("prompt pattern: ...") → one worked demo; stay general-purpose.
- **`offline_assemble.py <slug>`** — builds a video from an existing 02_lesson_plan.json with ZERO LLM calls (Edge TTS + deterministic hint→template mapping). Must call tts_client.validate_free_fallback() first or generate_audio dead-ends on exhausted ElevenLabs. Used to ship the flagship lesson ungated.
- **Flagship lesson shipped (ungated)**: "Getting started with ChatGPT" 4:58, 20 beats — title card, 5 interface tours, 2 prompt patterns, 3 demos+close-ups, callout recap. Gates skipped: intro 8.5 PASS, script 7.6 last scored.

**Host interstitials (June 12, 2026):** The guide now HOSTS the lesson — `avatar3d_builder.get_interstitial(section)` renders a ~3s full-content-region scene (big robot animating beside the section title on navy gradient, INTERSTITIAL_SPEC maps section→animation/kicker/label, cached in assets/avatar3d/interstitial_*.mp4). `layout_compositor.make_interstitial_beat()` builds the silent pseudo-beat; inserted at every section boundary in both orchestrator._assemble and offline_assemble.py. Rebuilt "using-chatgpt-to-write-letters-and-emails" (5:03, Brian voice, 5 host interstitials, motion scenes) as the demo of this — that lesson plan originally scored intro 9.0/script 8.8 when gates were alive.

**Continuous avatar contribution + hand-authored lessons (June 12, 2026):**
- Guide now contributes 24/7: **speech bubble** in the rail "says" each beat's key_phrase (layout_compositor._build_base guide_line param, agenda compacted to fit), plus **per-beat reaction clips** (avatar3d_builder.get_reaction_clip: Yes nod on checklists, No head-shake on scam warnings, ThumbsUp on tips/action, Wave, Idle) — beats carry "reaction" field.
- Hand-authored lesson plans: beats may carry explicit `template` + `data` + `reaction` + `key_phrase` fields; offline_assemble uses them directly (map_visual short-circuit). prompt_pattern template takes headline/example_label params now.
- **"Spotting AI Fakes" lesson authored by Claude directly** (no API needed): outputs/spotting-ai-fakes/, 14 beats, 4:54 — deepfake photo tells, video tells, voice-clone scam script, hang-up-call-back defense, family safe word, Pause/Verify/Call back pattern. First non-LLM-topic, non-senior-specific lesson.

**BLOCKER (June 12, 2026):** OpenAI API account out of credit (insufficient_quota, billing) AND ANTHROPIC_API_KEY= line in .env is empty. No LLM = no new lesson plans, no critic gates. User must top up OpenAI or paste an Anthropic key (then set LLM_BACKEND=anthropic). LLM_BACKEND currently "openai".

**Gotchas:**
- **ElevenLabs free tier = 10k chars/month, resets July 12 2026.** A lesson costs 4-6k chars. Quota exhausted June 11; pipeline detects (<6000 left) and falls back loudly to OpenAI gpt-4o-mini-tts. User should upgrade (Starter $5/30k or Creator $22/100k) to narrate with Alice.
- Avatar rubric calibration: score against the user's stated FAIL conditions (artificial/creepy/childish/inconsistent), not "exceptional" — a consistent mascot doing its job is an 8.

**Hard-won debugging lessons:**
- LLM reviewers PARROT example scores from their prompt templates (every review returned exactly 7.5/7.0 until score fields became `<your score>` placeholders with "score independently, one-decimal precision" instructions).
- Vision review of sampled stills can't see animation — sample at 75% through segments and tell the production reviewer demo beats are animated, or demos get flagged "static."
- Demo animations must finish by ~70% of the beat so the full response holds on screen (was getting cut mid-word).
- Only the "typing" demo_phase gets a live demo; response → annotated screenshot close-up; before/after → cards. Forcing all 4 phases into demos made repetitive clips.
- DALL-E images banned entirely — critic flagged them as "abstract filler" every single time.

**Key facts:**
- ELEVENLABS_API_KEY line in .env is EMPTY — voice falls back to OpenAI gpt-4o-mini-tts (voice "nova" + warmth instructions in tools/tts_client.py). User should paste a real ElevenLabs key for best narration (~$0.70-0.90/lesson vs $0.08).
- User chose: HeyGen avatar only if an API key exists (none does) → illustrated guide for now; build all phases at once (no checkpoints).
- Vision LLM calls: tools/llm_client.py call_with_images(); JSON helper parse_json_response().
- Gates/loops in config.py: GATE_SCORE=8.0, MAX_SCRIPT_LOOPS=3, MAX_PRODUCTION_LOOPS=2.
