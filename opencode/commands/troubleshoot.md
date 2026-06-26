---
description: Analyze a given bug, improvement ticket, or trace id and provide a detailed troubleshooting guide to resolve the issue.
agent: plan
model: github-copilot/claude-sonnet-5
---

Verify the provided input $ARGUMENTS against the expected prefix (usually `DFITE`). If the input matches a valid Jira ticket ID with this prefix, access the ticket details via the Atlassian Jira MCP. If the input does not match a valid Jira ticket ID, treat it instead as either a Datadog `trace_id` or a `zipkin_trace_id`. In either case, or if during the read of the Jira ticket you come across a Datadog `trace_id` or a `zipkin_trace_id`, use the `datadog-analyzer` sub-agent to analyze the trace (APM, logs) and provide insights into the root cause of the issue (hint: in case of a `zipkin_trace_id` use the `resolve-datadog-zipkin-trace` skill to find the corresponding trace information in Datadog).

If no trace information is available, ask the user to use the `brainstorm` command to groom the idea or improvement ticket separately, and then return to this command to generate a troubleshooting guide.

Otherwise, with the information gathered from the ticket and any trace analysis, generate a detailed troubleshooting guide that includes:

- A summary of the issue, including any relevant context from the ticket and trace analysis.

- A step-by-step guide to reproduce the issue, if applicable.

- A list of potential root causes, based on the analysis of the ticket and any trace data.

- Recommended solutions or workarounds for each identified root cause.

- Identify required changes to the codebase, configuration, or infrastructure to resolve the issue. In case of changes to source code, also consider additional tests that may be needed to validate the fix (use the `write-tests` skill for support).

In case of any uncertainties or missing information, use the `grilling` skill to ask the user for clarification or additional details.

Finally, ask the user if he wants to update or create Jira tickets for the troubleshooting plan, and if so, provide a summary of the tasks or milestones that can be used to create or update the tickets. You can use the `create-jira-ticket` skill to assist in creating or updating the tickets. For each ticket created or updated, attach the detailed troubleshooting plan and any relevant context or requirements as identified as attachment to the ticket, use the `handoff` skill to assist in this process.
