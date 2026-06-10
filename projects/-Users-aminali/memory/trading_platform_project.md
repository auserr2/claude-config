---
name: trading-platform-project
description: Core facts about ~/Projects/trading-platform — a modular paper-trading platform with swing (EMA momentum) and day (ORB) bots across 17+ completed phases
metadata: 
  node_type: memory
  type: project
  originSessionId: 6deadc7f-aa71-4930-a13d-a3098c51e895
---

Paper-trading research platform at ~/Projects/trading-platform. Two independent bots:
- **Swing bot**: daily bars, EMA 20/50/200 momentum, $1k paper, 14-symbol universe (SPY QQQ AAPL MSFT NVDA AMD META AMZN GOOGL TSLA INTC XBI ARKK BA), IWM/XLE pruned in v1.1.0
- **Day bot**: 5-min bars, Opening Range Breakout (09:30–09:44 EST), $1k paper, force-close 15:45 EST

**Why:** Research-first, advisory-only. Nothing auto-applied. All recommendations are text reports for human review.

**Current status (Phase 17+++):** 1373 tests passing + 219 smoke checks.
- Swing: READY for paper trading (OOS PF=1.18, 160 OOS trades, 3/5 windows profitable)
- Day ORB: HOLD — OOS PF=0.74–0.98, FRAGILE under 2× slippage
- Small account at $1k current prices: ~16% capture rate; SPY/QQQ inaccessible

**Key invariants:**
- Wilder's smoothing: ATR/ADX/RSI use ewm(alpha=1/period) — never change to SMA
- UTC internally everywhere; naive datetimes raise ValueError
- Frozen dataclasses; dataclasses.replace() for copies
- strategy_version bumped manually by human only
- Risk controls immutable: 25% single-cap, 70% total-cap, $50 min trade, ATR×2 stop

**How to apply:** Always read CLAUDE.md before any session. Python is python3.11.
