---
name: troubleshoot
description: Diagnose a bug/incident (issue or Datadog trace) into a fix plan and tracer-bullet work.
argument-hint: "Please provide the GitHub Issue id or trace id of the problem or issue you would like to troubleshoot."
disable-model-invocation: true
---

> [!IMPORTANT]
> This skill only **diagnoses and plans** — it must never write, edit, or execute implementation code, run builds/tests, or open branches/PRs. Once the plan is filed, tell the user to run the `implement-ticket` skill manually to build the fix; do not start implementation yourself, even if asked to "just fix it" in the same run.

## Workflow

### Step 1 — Parse the Request

Verify if the provided input refers to an open GitHub Issue via the GitHub MCP. If yes, load issue details. If not, treat the input as a Datadog `trace_id`.

If a Datadog `trace_id` appears in the input or the issue body, use the `datadog-analyzer` sub-agent to analyze the trace (APM, logs, metrics, events) for root-cause insights.

If no trace information is available, tell the user to use the `brainstorm` skill for idea/improvement grooming instead, and stop.

**Done when:** issue and/or trace context is loaded, or the run has correctly redirected to `brainstorm`.

### Step 2 — Generate Troubleshooting Plan

Produce a plan that includes:

- Summary of the issue (ticket + trace context)
- Steps to reproduce, if applicable
- Potential root causes (from ticket and trace data)
- Recommended solutions or workarounds per root cause
- Required code/config/infra changes and tests to validate the fix

If information is missing, use the `grilling` skill. If requirements need external facts, use the `research` skill.

#### Mandatory expert consult (do not skip)

**Always** invoke the `ask-the-expert` skill in **Diagnose** mode before finalizing — mandatory on every run, not conditional on confidence, on the early Datadog pass, or on whether you already “know” the stack.

When branching out:

1. **Invoke the skill** (do not impersonate experts yourself, and do not Task-call individual expert agents from this skill except the optional early `datadog-analyzer` evidence pass in Step 1 — full multi-expert orchestration belongs to `ask-the-expert`).
2. **Pass full context**: draft plan, issue text, trace findings from Step 1, stack traces/logs, affected services/paths, and open questions.
3. **Do not pre-filter technologies** for the consult. `ask-the-expert` must scan the **whole workspace**, match **every** available expert domain, and dispatch to **all** matched experts (see that skill’s hard rules). Your job is to supply the diagnosis materials and question, not to decide which experts run.
4. **Incorporate** the synthesized guidance (ranked hypotheses, evidence, next steps) into the plan. If the consult’s “Experts consulted” list is missing or looks incomplete relative to the repo, re-invoke `ask-the-expert` rather than proceeding on a partial consult.

**Done when:** the plan has summary, reproduce steps (if applicable), ranked causes, fixes, and validation tests; `ask-the-expert` was actually invoked in Diagnose mode; its Experts consulted / inventory outcome is reflected; feedback is incorporated.

### Step 3 — Work breakdown and GitHub filing

Follow [`../brainstorm/references/tracer-ticket-breakdown.md`](../brainstorm/references/tracer-ticket-breakdown.md): split into tracer-bullet tickets (or expand–contract for wide refactors), then create/update the main issue and linked child issues. (If work started from a trace ID only, create the main issue from the plan summary.)

**Done when:** that shared reference’s completion criteria are met and the user has issue URLs plus next steps.

### Step 4 — Stop and hand off

Report the plan summary and issue URLs, then stop. **Do not** begin implementation, create branches, edit files, or run `implement-ticket` yourself — the user must trigger implementation manually via the `implement-ticket` skill.

**Done when:** the user has been told to run `implement-ticket` manually when ready.
