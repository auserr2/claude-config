---
name: Clara MVP
description: Care coordination mobile app — React Native/Expo, Supabase, Claude API for shift note summaries
type: project
originSessionId: 69ff3e26-f68e-4759-87d4-3b4337bd6d3f
---
Clara is a mobile app that connects families with their loved one's caregivers. Caregivers record a voice note at shift end; the app transcribes it (Whisper), summarizes it warmly (Claude), and pushes it to the family.

**Codebase location:** `/Users/aminali/Desktop/Clara claude code/clara`

**Stack:** React Native + Expo (~51), Expo Router, Supabase (auth/db/storage/edge functions), Zustand, Claude API (claude-sonnet-4-6), OpenAI Whisper, Expo Notifications, expo-image-picker

**What's been built (all screens complete, no dead ends):**
- `onboarding.tsx` — phone OTP → name → role → navigates explicitly to create-group or tabs
- `create-group.tsx` — 4-step family onboarding: name + photo → relationship → invite team → done
- `_layout.tsx` — auth guard that detects incomplete profiles and routes family with no group to /create-group
- Home screen with real-time shift note updates and read receipts
- `shift-log.tsx` — voice recording → Whisper → Claude → family push notification
- `timeline.tsx`, `medications.tsx`, `team.tsx`, `sos.tsx`, `settings.tsx` — all complete
- Supabase schema with RLS policies, indexed for 100 families
- Edge function: `process-shift-note` (Whisper + Claude + Expo push)
- Design system in `app/lib/design.ts` (warm/non-clinical: terracotta, sage, cream)

**Key architecture decisions:**
- Auth listener in `_layout.tsx` guards on `profile.full_name !== 'User'` before routing — prevents premature navigation during onboarding name/role steps
- After `completeProfile()` in onboarding, navigation is EXPLICIT (not delegated to auth listener) — family → /create-group, others → /(tabs)
- `create-group.tsx` sets `senior` + `careGroup` in Zustand store immediately after DB creation — no re-fetch needed
- Invite tokens created server-side by Supabase default; share links are `https://clara.app/join/[token]`

**What to build next (priority order):**
1. `app/join/[token].tsx` — deep link handler so caregivers can accept invites and join a group
2. Manual text fallback in `shift-log.tsx` — tap-to-type when mic isn't practical
3. Caregiver empty state on home screen — caregivers who have no group yet see a "waiting for invite" message instead of broken empty dashboard

**Why:** Helping families of aging parents coordinate care across multiple caregivers. First target: families with 1 full-time caregiver and 2-4 family members wanting daily updates.
