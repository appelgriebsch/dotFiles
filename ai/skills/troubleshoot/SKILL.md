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

If the context is dubious, unclear, or requirements need external facts (unfamiliar APIs, libraries, specs, prior incidents), invoke the `research` skill **before** grilling the user. Have it write/update `RESEARCH.md` at the repository root, citing sources for each claim; re-invoke it later in this run if new open questions surface that need external facts. Only once research is done should you use the `grilling` skill to clarify whatever questions remain open (missing decisions, preferences, or ambiguous scope that research cannot answer).

#### Mandatory expert consult (do not skip)

**Always** invoke the `ask-the-expert` skill in **Diagnose** mode before finalizing — mandatory on every run, not conditional on confidence, on the early Datadog pass, or on whether you already “know” the stack.

When branching out:

1. **Invoke the skill** (do not impersonate experts yourself, and do not Task-call individual expert agents from this skill except the optional early `datadog-analyzer` evidence pass in Step 1 — full multi-expert orchestration belongs to `ask-the-expert`).
2. **Pass full context**: draft plan, issue text, trace findings from Step 1, stack traces/logs, affected services/paths, and open questions.
3. **Resolve and hand over the incident codebase revision.** Before/with the consult, mine the ticket and trace for version signals (fix versions, release names, image/git tags, `version` / `git.commit.sha` / deploy tags in Datadog, stack-trace build ids, etc.). Prefer a **git tag** (or commit mappable to one). Tell `ask-the-expert` this is **Diagnose** mode, screening corpus = **whole source at that revision**, and pass the tag/SHA plus the evidence. `ask-the-expert` must materialize that tagged tree for experts. If no signal exists, say so and allow fallback to the current workspace — do not assume HEAD matches production.
4. **Do not pre-filter technologies** for the consult. `ask-the-expert` must scan that **versioned codebase** (or the documented workspace fallback), match **every** available expert domain, and dispatch to **all** matched experts (see that skill’s hard rules). Your job is to supply the diagnosis materials, version signal, and question — not to decide which experts run.
5. **Incorporate** the synthesized guidance (ranked hypotheses, evidence, next steps) into the plan. If the consult’s “Experts consulted” list is missing or looks incomplete relative to the repo, re-invoke `ask-the-expert` rather than proceeding on a partial consult.

**Done when:** the plan has summary, reproduce steps (if applicable), ranked causes, fixes, and validation tests; ticket/trace version signals were checked; `ask-the-expert` was actually invoked in Diagnose mode against the **resolved git tag/revision** (or an explicit current-workspace fallback); its Experts consulted / inventory outcome is reflected; feedback is incorporated.

### Step 3 — Work breakdown and GitHub filing

Follow [`../brainstorm/references/tracer-ticket-breakdown.md`](../brainstorm/references/tracer-ticket-breakdown.md): split into tracer-bullet tickets (or expand–contract for wide refactors), then create/update the main issue and linked child issues. (If work started from a trace ID only, create the main issue from the plan summary.)

**Done when:** that shared reference’s completion criteria are met and the user has issue URLs plus next steps.

### Step 4 — Stop and hand off

Report the plan summary and issue URLs, then stop. **Do not** begin implementation, create branches, edit files, or run `implement-ticket` yourself — the user must trigger implementation manually via the `implement-ticket` skill.

**Done when:** the user has been told to run `implement-ticket` manually when ready.
