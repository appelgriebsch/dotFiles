---
name: resolve-datadog-zipkin-trace
description: Search and debug Datadog logs/APM for xarvio requests using a Zipkin trace ID stored as @zipkin_trace_id.
---

# Debug Datadog Zipkin Trace

Use this skill when the user asks to find, inspect, or debug a request in
Datadog using a trace ID from xFM logs. In these logs, the user-provided trace
ID is usually stored in Datadog as `@zipkin_trace_id`, not the top-level
Datadog `trace_id`.

Typical prompts:

- "Check this trace ID in Datadog"
- "Find this trace in this Datadog log URL"
- "What happened for zipkin trace ID ..."
- "What was the request/response/error for this trace?"

## Defaults

- Treat the trace ID as `@zipkin_trace_id:<id>` first.
- Do **not** assume top-level `trace_id` is the same value. Datadog may also
  show a separate generated `trace_id` on the log entry.
- If the user provides a Datadog Logs Explorer URL, preserve its query filters,
  time range, storage tier, and sort direction before adding
  `@zipkin_trace_id:<id>`.
- If no URL or time window is provided, start with the smallest reasonable time
  range from the user's context. If none is available, ask for the environment
  or approximate time before doing broad searches.
- Load the Datadog MCP `datadog/logs` guide before log searches and
  `datadog/traces` before APM trace retrieval.

## Workflow

1. Extract inputs:
   - Zipkin trace ID.
   - Datadog Logs URL filters/time range if provided.
   - Environment, service, endpoint, HTTP method, and status filters if stated.
2. Search logs with the exact scoped query:
   - Add `@zipkin_trace_id:<trace_id>` to the user's existing filters.
   - Request useful fields via `extra_fields`, starting with:
     `zipkin_trace_id`, `zipkin_span_id`, `http*`, `applicationName`,
     `requestBody`, `responseBody`, and `error*`.
3. If the scoped search returns no results:
   - Search only `@zipkin_trace_id:<trace_id>` in the same time window.
   - If a URL was provided, sample the original URL query without the trace
     filter to verify field names and whether the expected logs exist.
   - Only broaden the time range after the field/query syntax has been checked.
4. If logs are found:
   - Report the count, timestamp, service, env, HTTP method/path/status, and
     Datadog top-level `trace_id`.
   - Pull all logs for the same `@zipkin_trace_id` in the same window to inspect
     gateway, backend, and error-handler entries together.
5. For response/error details:
   - Prefer explicit captured fields such as `responseBody`, `http.response*`,
     or `error.message`.
   - If no response body is captured, say that plainly and use the correlated
     error log message as the best available response/error evidence.
6. For APM follow-up:
   - If a top-level Datadog `trace_id` is present, use it for Datadog APM trace
     lookup.
   - Do not treat an APM 404 as proof the log trace is invalid; logs may retain
     `@zipkin_trace_id` even when the APM trace is unavailable.

## Query Examples

```text
@zipkin_trace_id:6a324919283bf15f7d1135ebab8f21d1
```

```text
env:qa0 @applicationName:sustainability-service @http.method:POST
@http.url_details.path:"/carbon-farming-requests" -@http.status_code:201
@zipkin_trace_id:6a324919283bf15f7d1135ebab8f21d1
```

## Output Format

```markdown
**Found:** <yes/no, count>

**Request:** <method path, service/env, timestamp, status>

**Trace IDs:** zipkin_trace_id `<id>`, Datadog trace_id `<id if present>`

**Details:** <response body if captured, otherwise correlated error message>
```

If the result is missing or incomplete, state exactly what was checked and what
evidence is unavailable.
