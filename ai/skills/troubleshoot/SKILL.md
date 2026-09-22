---
name: troubleshoot
description: Diagnose a bug/incident (issue, or Datadog trace id) into a fix plan and tracer-bullet work.
argument-hint: "Please provide the ticket id or trace id of the problem or issue you would like to troubleshoot."
disable-model-invocation: true
---

> [!IMPORTANT]
> **Allowed writes:** plan artifacts only — `docs/research/` files per the [path rule](../brainstorm/references/research-grill-decisions.md), `CONTEXT.md` / ADRs via `domain-modeling`, and tracker creates/updates/comments. After filing, persist those artifacts on the **implement-ticket baseline branch** (Step 4) and open a **draft** PR, then stop and tell the user to run `implement-ticket` manually.
>
> **Guardrail:** do not write, edit, or execute implementation code; do not run builds/tests; do not start `implement-ticket` — even if asked to "just fix it" in the same run.

## Workflow

### Step 1 — Parse the Request

Load `issue-tracker`. Match the input against **Identity** `ticket_id_pattern` (or extract the id from a browse URL). If it matches, get the ticket via **Operations** get and load issue details. If not, treat the input as a trace id. A bare id is a Datadog trace id.

If a trace id appears in the input or the issue body, use the `observability-expert` sub-agent to analyze the trace (APM, logs, metrics, events) for root-cause insights. Name the platform the id belongs to; a Datadog trace id names Datadog. Tell that agent this pass is Consultant signal gathering and to leave the bill of materials unwritten. Treat this as **early evidence gathering only** — it does **not** replace the mandatory `ask-the-expert` consult in Step 2 (which still discovers all repo technologies and may re-engage `observability-expert` plus every other matched expert).

If no trace information is available, tell the user to use the `brainstorm` skill for idea/improvement grooming instead, and stop.

**Done when:** issue and/or trace context is loaded, or the run has correctly redirected to `brainstorm`.

### Step 2 — Generate Troubleshooting Plan

Produce a plan that includes:

- Summary of the issue (ticket + trace context)
- Steps to reproduce, if applicable
- Potential root causes (from ticket and trace data)
- Recommended solutions or workarounds per root cause
- Required code/config/infra changes and tests to validate the fix

Load [`../brainstorm/references/research-grill-decisions.md`](../brainstorm/references/research-grill-decisions.md) and complete its research → grill → decision-capture sequence before the expert consult.

#### Mandatory expert consult

**Always** invoke the `ask-the-expert` skill in **Consultant** mode before finalizing — every run, not conditional on confidence, on the early trace pass, or on whether you already “know” the stack. This consult is troubleshooting, so the incident revision rules in that skill apply.

When branching out:

1. **Invoke the skill** (do not impersonate experts yourself, and do not Task-call individual expert agents from this skill except the optional early `observability-expert` evidence pass in Step 1 — full multi-expert orchestration belongs to `ask-the-expert`).
2. **Pass full context**: draft plan, issue text, trace findings from Step 1, stack traces/logs, affected services/paths, and open questions.
3. **Resolve and hand over the incident codebase revision.** Before/with the consult, mine the ticket and trace for version signals (fix versions, release names, image/git tags, `version` / `git.commit.sha` / deploy tags on the monitoring platform, stack-trace build ids, etc.). Prefer a **git tag** (or commit mappable to one). Tell `ask-the-expert` this is **Consultant** mode for troubleshooting, screening corpus = **whole source at that revision**, and pass the tag/SHA plus the evidence. `ask-the-expert` must materialize that tagged tree for experts. If no signal exists, say so and allow fallback to the current workspace — do not assume HEAD matches production.
4. **Do not pre-filter technologies** for the consult. `ask-the-expert` must scan that **versioned codebase** (or the documented workspace fallback), match **every** available expert domain, and dispatch to **all** matched experts (that skill’s inventory and dispatch). Your job is to supply the diagnosis materials, version signal, and question — not to decide which experts run.
5. **Incorporate** the synthesized guidance (ranked hypotheses, evidence, next steps) into the plan. If the consult’s “Experts consulted” list is missing or looks incomplete relative to the repo, re-invoke `ask-the-expert` rather than proceeding on a partial consult.

**Done when:** the plan has summary, reproduce steps (if applicable), ranked causes, fixes, and validation tests; [`research-grill-decisions.md`](../brainstorm/references/research-grill-decisions.md) **Done when** criteria are met; ticket/trace version signals were checked; `ask-the-expert` was actually invoked in Consultant mode against the **resolved git tag/revision** (or an explicit current-workspace fallback); its Experts consulted / inventory outcome is reflected; feedback is incorporated.

### Step 3 — Work breakdown and ticket filing

Load [`../brainstorm/references/tracer-ticket-breakdown.md`](../brainstorm/references/tracer-ticket-breakdown.md). Split the troubleshooting plan into tracer-bullet (or expand–contract) tickets, file/update the main issue and linked children, and meet that file’s **Work breakdown** and **Ticket creation / management** **Done when** before Step 4.

**Done when:** that file’s filing **Done when** is met.

### Step 4 — Persist plan artifacts, then stop

Load **Persist plan artifacts** in [`../brainstorm/references/tracer-ticket-breakdown.md`](../brainstorm/references/tracer-ticket-breakdown.md). Report the plan summary, issue URLs, and the persist result (baseline branch, commit SHA, draft PR URL, or that nothing changed). Then stop; the user runs `implement-ticket` manually.

**Done when:** that file’s persist **Done when** is met.
