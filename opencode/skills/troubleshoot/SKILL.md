---
name: troubleshoot
description:
  This skill analyzes a given problem or issue and provides a detailed troubleshooting plan to resolve it. It gathers relevant information from the problem description, including context, symptoms, and constraints, and generates a step-by-step troubleshooting plan. The skill also identifies potential causes, required tests, and validation steps, and can assist in creating prototypes or breaking down the troubleshooting into smaller tasks or milestones. 
argument-hint:
  - "Please provide the GitHub Issue id or trace id of the problem or issue you would like to troubleshoot."  
disable-model-invocation: true
---

This skill is designed to help users troubleshoot and resolve problems or issues. It takes into account the context, symptoms, and constraints provided in the problem description, and generates a comprehensive troubleshooting plan.

## Workflow

### Step 1 — Parse the Request

Verify if the provided input refers to an open GitHub Issue by utilizing the GitHub MCP. If the input matches a valid GitHub Issue, access the issue details via the GitHub MCP. If the input does not match a valid GitHub Issue, treat it instead as a Datadog `trace_id`.

In this case, or if during the read of the GitHub Issue you come across a Datadog `trace_id`, use the `datadog-analyzer` sub-agent to analyze the trace (APM, logs, metrics, events, ...) and provide detailed insights into the root cause of the issue.

If no trace information is available, tell the user to use the `brainstorm` command to groom the idea or improvement ticket separately, and end the conversation here.

### Step 2 — Generate Troubleshooting Plan

With the information gathered from the ticket and trace analysis, generate a detailed troubleshooting guide that includes:

- A summary of the issue, including any relevant context from the ticket and trace analysis.

- A step-by-step guide to reproduce the issue, if applicable.

- A list of potential root causes, based on the analysis of the ticket and any trace data.

- Recommended solutions or workarounds for each identified root cause.

- Identify required changes to the codebase, configuration, or infrastructure to resolve the issue. In case of changes to source code, also consider additional tests that may be needed to validate the fix (use the `write-tests` skill for support if available).

In case of any uncertainties or missing information, use the `grilling` skill to ask the user for clarification or additional details.

### Step 3 — GitHub Issue Management

Finally, ask the user if they want to update or create GitHub Issue(s) for the troubleshooting plan. If so, provide a summary of the tasks or milestones that can be used to create or update the issues. For each issue created or updated, attach the detailed troubleshooting plan and any relevant context or requirements as identified as an attachment to the issue (use the `handoff` skill to assist in this process).
