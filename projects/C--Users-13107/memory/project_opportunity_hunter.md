---
name: project-opportunity-hunter
description: Opportunity Hunter platform — AI-powered gig intelligence scanner built at C:\Users\13107\opportunity-hunter
metadata: 
  node_type: memory
  type: project
  originSessionId: 11bc7ccf-1547-4c1f-a245-64dd9a5d65fb
---

Full-stack Python platform at `C:\Users\13107\opportunity-hunter` that continuously scans the internet for freelance/gig opportunities where AI can do 70-95% of the work.

**Why:** User wants to find AI-completable gigs, supervise and deliver the output as a freelancer.

**How to apply:** When user asks about this project, refer to this directory and the two-process startup below.

## Architecture
- `main.py` — entry point; starts APScheduler-based background scanner
- `scheduler/scan_scheduler.py` — orchestrates scrape → filter → analyze → notify loop
- `scrapers/` — Reddit RSS, Hacker News Algolia API, generic RSS feeds
- `analyzer/claude_analyzer.py` — Claude Haiku for batch filtering + per-opportunity analysis; Sonnet for service template generation
- `database/` — SQLAlchemy + SQLite (`opportunity_hunter.db`)
- `notifications/notifier.py` — desktop (plyer) + DB notifications
- `dashboard/app.py` — Streamlit dashboard (5 tabs: Overview, Opportunities, Services Library, Notifications, Scan Logs)

## Startup
```
# Terminal 1 — background scanner
python main.py

# Terminal 2 — dashboard
streamlit run dashboard/app.py
```

## Config
- `.env` file with `ANTHROPIC_API_KEY`, `SCAN_INTERVAL_MINUTES` (default 30), notification thresholds
- `config.py` — subreddits list, RSS feeds, scoring weights

## Key tables
- `opportunities` — raw scraped posts
- `analyses` — Claude scoring (ROI 0-100, profit/hr, AI%, workflow, prompts, templates)
- `services` — auto-built library of repeatable service types
- `scan_logs` — scrape history
- `notifications` — alert log
