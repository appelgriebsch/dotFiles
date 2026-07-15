---
name: datadog-health-report
description: Consolidated Datadog health report for a scoped area of responsibility — use before a daily standup or SoS when you need metrics, logs, traces, monitors, SLOs, and incidents synthesized into a meeting-ready summary.
argument-hint: "Please provide the area of responsibility (team, service, domain, or component) and any relevant Datadog tags or config to scope the report."
---

Orchestrate Datadog signal gathering via the **`datadog-analyzer`** agent, then synthesize a standup/SoS health report. Scope every query; never run globally unscoped Datadog queries.

## Step 1 — Confirm scope

Confirm with the user if missing:

1. **Area of responsibility** (team, service, domain, component)
2. **Time window** (default: last 24 hours)
3. **Meeting type** — daily standup or SoS
4. **Datadog tags/config** — service, `env:…`, monitors/dashboards
5. **Known context** — deployments, config changes, known incidents

**Done when:** area + tags/env are clear enough to scope queries.

## Step 2 — Gather signals via datadog-analyzer

Dispatch **parallel** Task invocations of `datadog-analyzer` (or equivalent), each scoped to the confirmed tags and window. Cover these seven categories — one focused prompt per category (or batch carefully without dropping a category):

| Category | Fetch |
| --- | --- |
| Metrics | Latency p50/p95/p99, error rate, throughput/RPS, CPU/memory, domain KPIs |
| Logs | Error/warning spikes, volume anomalies, recurring patterns |
| Traces | Latency outliers, slow ops, dependency bottlenecks, error traces |
| Monitors | Triggered (severity, duration), recently resolved, no-data |
| SLOs | Compliance, error budget, burn rate, at-risk next 24–72h |
| Incidents | Active + resolved in window (severity, duration, impact) |
| Dashboards | Key health widgets; threshold breaches |

**Done when:** every category has results or an explicit no-data/error note.

## Step 3 — Correlate

- Align signals by timestamp (e.g. log spike at T vs metrics/traces)
- Prefer convergent multi-signal failures over single-signal noise
- Separate ongoing vs resolved vs early-warning
- Trend vs yesterday (or last week for weekly SoS)
- Surface observability gaps when a category returns no data

**Done when:** a short correlation notes list exists (including gaps).

## Step 4 — Overall status

Strict rules — overall status = most severe finding:

- 🔴 **CRITICAL** — active P0/P1 incident, active SLO breach, or critical monitor triggered
- 🟡 **DEGRADED** — warning monitors, error budget below 20%, or log/trace anomalies without active incident
- 🟢 **HEALTHY** — monitors OK, SLOs in budget, no active incidents, no significant anomalies

**Done when:** one status assigned with a one-sentence basis.

## Step 5 — Report

Fill [`references/report-template.md`](references/report-template.md). Then adapt:

- **Daily standup:** lead with TL;DR + status + action items; keep scannable in under 2 minutes
- **SoS:** one section per area if multi-area; add cross-team summary, shared incidents, escalations

Operational rules: scope with tags only; say “No data available” instead of omitting sections; use monitor/SLO baselines; annotate pre/post-deploy if the user noted deploys; put escalation paths on CRITICAL action items.

Before delivery, run [`references/qa-checklist.md`](references/qa-checklist.md).

**Done when:** template filled, meeting-type adapted, QA checklist satisfied or gaps noted in the report.
