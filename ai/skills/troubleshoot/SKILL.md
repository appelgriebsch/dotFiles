---
name: troubleshoot
description:
  This skill analyzes a given problem or issue and provides a detailed troubleshooting plan to resolve it. It gathers relevant information from the problem description, including context, symptoms, and constraints, and generates a step-by-step troubleshooting plan. The skill also identifies potential causes, required tests, and validation steps, and can assist in creating prototypes or breaking down the troubleshooting into smaller tasks or milestones. 
argument-hint: "Please provide the GitHub Issue id or trace id of the problem or issue you would like to troubleshoot."  
disable-model-invocation: true
---

This skill is designed to help users troubleshoot and resolve problems or issues. It takes into account the context, symptoms, and constraints provided in the problem description, and generates a comprehensive troubleshooting plan.

## Workflow

### Step 1 — Parse the Request

Verify if the provided input refers to an open GitHub Issue by utilizing the GitHub MCP. If the input matches a valid GitHub Issue, access the issue details via the GitHub MCP. If the input does not match a valid GitHub Issue, treat it instead as a Datadog `trace_id`.

In any case, or if during the read of the GitHub Issue you come across a Datadog `trace_id`, use the `datadog-analyzer` sub-agent to analyze the trace (APM, logs, metrics, events, ...) and provide detailed insights into the root cause of the issue.

If no trace information is available, tell the user to use the `brainstorm` skill to groom the idea or improvement ticket separately, and end the conversation here.

### Step 2 — Generate Troubleshooting Plan

With the information gathered from the ticket and trace analysis, generate a detailed troubleshooting guide that includes:

- A summary of the issue, including any relevant context from the ticket and trace analysis.

- A step-by-step guide to reproduce the issue, if applicable.

- A list of potential root causes, based on the analysis of the ticket and any trace data.

- Recommended solutions or workarounds for each identified root cause.

- Identify required changes to the codebase, configuration, or infrastructure to resolve the issue. In case of changes to source code, also consider additional tests that may be needed to validate the fix (use the `write-tests` skill for support if available).

In case of any uncertainties or missing information, use the `grilling` skill to ask the user for clarification or additional details. If the user isn't sure about the requirements or constraints, you may also use the `research` skill to help gather and clarify the requirements.

### Step 3 - Work breakdown and Task Management

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges** — the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

### Step 4 - GitHub Issue Creation / Management

If we started with a GitHub Issue, update the ticket with a summary of the troubleshooting plan. If we started with a trace ID, create a new GitHub Issue with the summary of the troubleshooting plan (use the GitHub MCP).

For any individual tracer bullet tickets created in Step 3, create corresponding GitHub Issues and link them to the main issue. Ensure that each issue includes a clear description of the task, any relevant context, and the blocking edges identified in Step 3 (use the `handoff` skill to assist in this process).

Finally, provide the user with a summary of the troubleshooting plan, including any created GitHub Issues and their links, and any additional recommendations or next steps for the troubleshooting.
