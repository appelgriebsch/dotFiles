# Test Report Template

## Summary
- **Release / PR:** `<PR #, title, version>`
- **Environment:** `<staging URL, deployed version, date/time>`
- **Baseline version for perf comparison:** `<previous version>`
- **Verdict:** `GREEN` (all pass, no perf regressions) / `YELLOW` (pass with warnings) / `RED` (failures or perf regressions)

## Test Results
| ID | Title | Type (PR-focused / regression) | Expected | Actual | Status | Evidence |
|----|-------|-------------------------------|----------|--------|--------|----------|

## Failures Detail
### `<ID>` — `<title>`
- **Expected:** …
- **Actual:** …
- **Evidence:** response body / screenshot / log excerpt
- **Repro steps:** …
- **Suspected cause (PR change):** …

## Performance KPIs (backend)
| Endpoint | Method | Version | p50 (ms) | p95 (ms) | p99 (ms) | Throughput (req/s) | Error rate | Δ vs baseline |
|----------|--------|---------|----------|----------|----------|--------------------|------------|---------------|

### Regressions / Warnings
- …

## New Baseline
Store current KPIs as baseline for the next release.

## Recommendation
Proceed to production / hold / investigate specific items.
