# Health report template

Instructional notes in brackets are for the agent — do not include them verbatim in the output.

```
[Include this banner only when status is CRITICAL or multiple DEGRADED signals exist:]
⚠️ ATTENTION REQUIRED

## 🏥 Daily Health Report — [Area of Responsibility] — [Date UTC]

### 📌 TL;DR
[1–3 sentences readable aloud in under 30 seconds. State overall health, the single most important finding, and the top action item.]

### 🚦 Overall Health Status
**[🟢 HEALTHY / 🟡 DEGRADED / 🔴 CRITICAL]**
[One sentence explaining the basis for this status.]

### 📊 Key Metrics (Last 24h)
[Table: Metric | Current Value | vs. Yesterday | Trend]
[Trend: ↑ = worse, ↓ = better, → = stable within 5%]
[Include: Latency p50/p95/p99 | Error Rate | Throughput (RPS) | CPU | Memory]

### 🚨 Active Alerts & Monitors
- Triggered: severity, name, duration, component
- Recently resolved: name, resolved time, total duration
- No-data: name and duration missing

### 📋 Log Anomalies
- Top errors with count and trend vs yesterday
- Log volume: normal / elevated / reduced (+ %)

### 🔍 Trace Highlights
- Slowest endpoint/operation: p99 + trend
- Top error traces: service/operation + count
- Dependency bottlenecks

### 📈 SLO Status
[Table: SLO Name | Target | Current | Error Budget Remaining | Status]

### 🔥 Incidents
- Active: name, severity (P0–P3), duration, impact
- Resolved in window: name, resolution time, total duration

### ⚡ Action Items
[Every item names a component and a concrete next step]
1. [IMMEDIATE] … — Component: …, Next step: …
2. [MONITOR] … — Watch for: …
3. [INVESTIGATE] … — Suggested approach: …

### ✅ Healthy Signals
- Clean services with specific confirming metrics
```
