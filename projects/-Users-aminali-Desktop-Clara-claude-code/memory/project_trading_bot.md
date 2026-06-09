---
name: Trading Bot Project
description: Day/swing trading bot — modular Python, paper-first, full backtest + walk-forward + Monte Carlo + observability layer. In iterative weekly improvement cycle.
type: project
originSessionId: 5c609119-03ad-444a-a5a9-224ecb8e1316
---
Full trading bot at `/Users/aminali/Desktop/Clara claude code/trading_bot/`.

**Stack:** Python 3.11 (`/opt/homebrew/bin/python3.11`), yfinance, pandas, numpy, scipy, matplotlib, rich, click, requests

## Architecture

```
config/settings.py          — CONFIG singleton, all parameters incl. alert thresholds + webhook URLs
data/                       — yfinance fetcher + preprocessor
indicators/
  technical.py              — EMA, RSI, MACD, ATR, ADX, Volume (pure pandas/numpy)
  regime.py                 — 3-axis regime: TrendStrength × DirectionBias × VolatilityTier
strategies/
  base.py                   — Signal(direction: long/short/flat/hold)
  momentum.py               — EMA crossover + RSI + Vol + Regime
backtesting/
  portfolio.py              — Position, Trade, Portfolio (bar-by-bar, ATR sizing)
  engine.py                 — BacktestEngine (signal at close → fill at next open)
  walk_forward.py           — 5-fold expanding window
simulation/monte_carlo.py   — 1000-path bootstrap MC (geometric compounding)
analytics/
  performance.py            — Sharpe(trade+bar)/Sortino/Calmar/MDD/PF/Expectancy
  reports.py                — matplotlib dark-theme charts + terminal tables
paper_trading/
  broker.py                 — PaperBroker (JSON state, gap-aware fills, PnL attribution)
  executor.py               — PaperTradingExecutor (live loop + full observability)
journal/trade_journal.py    — CSV + Markdown diary (PnL attribution columns)
observability/
  logger.py                 — configure_logging(): JSON rotating files + Rich console
  alerts.py                 — AlertEngine: drawdown/exposure/correlation/heat/daily-loss
  notifier.py               — Notifier: Discord webhook + Telegram bot
  dashboard.py              — LiveDashboard: Rich Live terminal panel
  daily_summary.py          — DailySummaryReporter: EOD → MD + JSON
scripts/
  smoke_test.py             — 102-check pre-launch validation (per-symbol + portfolio)
  weekly_review.py          — Weekly analysis: aggregates journals → MD + JSON report
main.py                     — CLI: backtest/walkforward/paper/full/status/check/review
```

## Current configuration (post-calibration)
- EMA 20/50/200, RSI 14 (entry 40–72, exit 78), ATR 14, ADX 14
- ADX trending: 20, choppy: 15; volume multiplier: 1.1×
- Warm-up: 600 bars, history: 1460 days (~4 years)
- Risk per trade: **1.25%**, max positions: **8**, stop: ATR×2, target: ATR×4 (2:1 R:R)
- Max portfolio risk: 12.5%, max single position: 25%, max total exposure: 70%
- Daily entry halt at 3% intraday drawdown
- Volatility sizing: LOW/NORMAL=1.0×, HIGH=0.60×, EXTREME=0.0× (blocked)
- Regime: HIGH vol allowed (reduced size), only EXTREME vol blocks entry
- 16-symbol universe: SPY/QQQ/IWM, AAPL/MSFT/NVDA/AMD/META/AMZN/GOOGL, TSLA/INTC, XLE/XBI/ARKK, BA

## Iterative improvement process
**Current phase:** Week 1 paper trading → first weekly review
**Process:**
1. Run paper trading ~1 week
2. Run `python main.py review` → generates journals/weekly_review_YYYY-WW.md
3. Analyze 8 standard questions (entry quality, stops, targets, regime filter, vol sizing, symbol concentration, operational stability, skip cost)
4. Apply only evidence-based, incremental changes
5. Repeat

**Principles (strict):**
- No strategy rewrites, no indicator chasing, no overfitting
- Prioritize robustness > short-term profit
- Changes must be justified by observed data, not theory

## Data collection (per session)
- `journals/trade_journal.csv` — ENTRY/EXIT rows with PnL attribution + vol tier
- `journals/daily_summary_YYYY-MM-DD.md` — human-readable EOD report
- `logs/daily_summary_YYYY-MM-DD.json` — machine-readable EOD snapshot
- `logs/trading_bot.log` — structured JSON logs (INFO+)
- `logs/trade_events.log` — trade events only

## Review flag thresholds
- Win rate < 38% → investigate entry quality
- Profit factor < 0.90 → strategy net-negative
- Session drawdown > 5% → drawdown flag
- Stop rate > 65% → stop placement concern
- Target rate < 10% → R:R not materialising
- Skip rate > 30% of signals → calibration concern
- Single vol regime > 80% of trades → concentration concern

## CLI
```bash
/opt/homebrew/bin/python3.11 main.py check              # pre-launch validation (102 checks)
/opt/homebrew/bin/python3.11 main.py paper              # live paper trading loop
/opt/homebrew/bin/python3.11 main.py status             # current portfolio state
/opt/homebrew/bin/python3.11 main.py review             # weekly review report (last 7 days)
/opt/homebrew/bin/python3.11 main.py review --from 2026-05-12
/opt/homebrew/bin/python3.11 main.py backtest --symbol NVDA --no-plot
```

## Key design decisions
- "hold" = keep position open, don't close; "flat" = explicit exit only
- Walk-forward passes combined train+test for warm-up, filters OOS by timestamp
- Long-only (no short-selling) — suitable for paper/Robinhood trading
- Vol scalar in vol_size_scalar() on MarketRegime — sizing logic co-located with regime
- Backwards-compatible state loading: merge _defaults dict before dataclass construction
- Cycle counter: broker.tick() each cycle → entry_bar on position → bars_held on trade

## Validation
- 8 quant audit fixes confirmed (gap protection, walk-forward OOS, ADX, stop anchoring,
  commission both legs, 600-bar warm-up, MC geometric compounding, trade-level Sharpe)
- Smoke test: 102/102 passing (incl. VOL_SCALAR check)

**Long-term goal:** Stable, well-engineered swing system → real capital deployment.
