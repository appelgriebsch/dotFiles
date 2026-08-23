---
name: troubleshoot
description: Diagnose a bug/incident (issue, or Datadog trace id) into a fix plan and tracer-bullet work.
argument-hint: "Please provide the ticket id or trace id of the problem or issue you would like to troubleshoot."
disable-model-invocation: true
---

> [!IMPORTANT]
> This skill only **diagnoses, documents decisions, and files tickets** — it must never write, edit, or execute **implementation code**, run builds/tests, or start `implement-ticket`. Allowed writes are plan artifacts only: root `RESEARCH.md`, `CONTEXT.md` / ADRs via `domain-modeling`, and tracker creates/updates/comments. After tickets are filed, commit those artifacts on the **implement-ticket baseline branch** (`branch_with_ticket` for the EPIC id, or for a leaf the ticket id) and open a **draft** PR. Then tell the user to run the `implement-ticket` skill manually to build the fix; do not start implementation yourself, even if asked to "just fix it" in the same run.

## Workflow

### Step 1 — Parse the Request

Load `issue-tracker`. Match the input against **Identity** `ticket_id_pattern` (or extract the id from a browse URL). If it matches, get the ticket via **Operations** get and load issue details. If not, treat the input as a Datadog `trace_id`.

If a Datadog `trace_id` appears in the input or the issue body, use the `datadog-analyzer` sub-agent to analyze the trace (APM, logs, metrics, events) for root-cause insights. Treat this as **early evidence gathering only** — it does **not** replace the mandatory `ask-the-expert` consult in Step 2 (which still discovers all repo technologies and may re-engage `datadog-analyzer` plus every other matched expert).

If no trace information is available, tell the user to use the `brainstorm` skill for idea/improvement grooming instead, and stop.

**Done when:** issue and/or trace context is loaded, or the run has correctly redirected to `brainstorm`.

### Step 2 — Generate Troubleshooting Plan

Produce a plan that includes:

- Summary of the issue (ticket + trace context)
- Steps to reproduce, if applicable
- Potential root causes (from ticket and trace data)
- Recommended solutions or workarounds per root cause
- Required code/config/infra changes and tests to validate the fix

If the context is dubious, unclear, or requirements need external facts (unfamiliar APIs, libraries, specs, prior incidents), dispatch the `research` skill as a **background agent** **before** grilling the user so research legwork stays out of this conversation. Task it to write/update root `RESEARCH.md`, citing sources for each claim; re-dispatch the same way later if new open questions need external facts. When the agent finishes, take facts only from that file on disk. Only once `RESEARCH.md` is ready should you clarify whatever questions remain open (missing decisions, preferences, or ambiguous scope that research cannot answer): check whether a `CONTEXT.md` exists at the repository root, and if so run a `/grilling` session, using the `/domain-modeling` skill; if not, fall back to the plain `grilling` skill instead.

#### Decision capture (after grilling)

When a grilling session ran and settled **architectural decisions**, document them on disk before the expert consult finalizes — do not leave them only in chat:

- **`CONTEXT.md` present** — record each qualifying decision as an ADR via `domain-modeling` (that skill’s three-criteria gate and ADR format). Glossary terms stay in `CONTEXT.md` as the session resolves them.
- **No `CONTEXT.md`** — append a dated **Decisions** section to root `RESEARCH.md` (create the file if needed): for each settled decision, what was chosen, why, and rejected alternatives.

If grilling produced no architectural decisions, say so briefly in the plan and skip this write.

**Done when (decision capture):** every architectural decision from grilling is on disk (ADR under `docs/adr/` or a Decisions entry in `RESEARCH.md`), or the plan states none were made.

#### Mandatory expert consult (do not skip)

**Always** invoke the `ask-the-expert` skill in **Diagnose** mode before finalizing — mandatory on every run, not conditional on confidence, on the early Datadog pass, or on whether you already “know” the stack.

When branching out:

1. **Invoke the skill** (do not impersonate experts yourself, and do not Task-call individual expert agents from this skill except the optional early `datadog-analyzer` evidence pass in Step 1 — full multi-expert orchestration belongs to `ask-the-expert`).
2. **Pass full context**: draft plan, issue text, trace findings from Step 1, stack traces/logs, affected services/paths, and open questions.
3. **Resolve and hand over the incident codebase revision.** Before/with the consult, mine the ticket and trace for version signals (fix versions, release names, image/git tags, `version` / `git.commit.sha` / deploy tags in Datadog, stack-trace build ids, etc.). Prefer a **git tag** (or commit mappable to one). Tell `ask-the-expert` this is **Diagnose** mode, screening corpus = **whole source at that revision**, and pass the tag/SHA plus the evidence. `ask-the-expert` must materialize that tagged tree for experts. If no signal exists, say so and allow fallback to the current workspace — do not assume HEAD matches production.
4. **Do not pre-filter technologies** for the consult. `ask-the-expert` must scan that **versioned codebase** (or the documented workspace fallback), match **every** available expert domain, and dispatch to **all** matched experts (see that skill’s hard rules). Your job is to supply the diagnosis materials, version signal, and question — not to decide which experts run.
5. **Incorporate** the synthesized guidance (ranked hypotheses, evidence, next steps) into the plan. If the consult’s “Experts consulted” list is missing or looks incomplete relative to the repo, re-invoke `ask-the-expert` rather than proceeding on a partial consult.

**Done when:** the plan has summary, reproduce steps (if applicable), ranked causes, fixes, and validation tests; decision capture above is satisfied when grilling ran; ticket/trace version signals were checked; `ask-the-expert` was actually invoked in Diagnose mode against the **resolved git tag/revision** (or an explicit current-workspace fallback); its Experts consulted / inventory outcome is reflected; feedback is incorporated.

### Step 3 — Work breakdown and ticket filing

Follow [`../brainstorm/references/tracer-ticket-breakdown.md`](../brainstorm/references/tracer-ticket-breakdown.md): split into tracer-bullet tickets (or expand–contract for wide refactors), **work out a per-ticket implementation plan for each child** (sliced from the troubleshooting plan; full when possible, best-effort with stated unknowns otherwise), then create/update the main issue and linked child issues. (If work started from a trace ID only, create the main issue from the plan summary.) Do not file children that are only a goal + acceptance criterion when a workable plan can already be written.

That shared reference owns three end-state gates — meet all of them before Step 4:

1. **STE summary on main** — ASD-STE100 Simplified Technical English summary of the full plan + next steps posted as a **comment on the main ticket** (**Operations** comment) (and shown to the user). Use ubiquitous language from `CONTEXT.md` when present.
2. **Labels** on every issue you create or update — apply `issue-tracker` **Extras** (create missing names first). Clear stale grooming labels when a full plan lands.
3. **Per-child plans and labels assigned** — as specified in the shared reference.

**Done when:** that shared reference’s completion criteria are met — including STE comment on the main ticket, correct labels on all touched issues, and a plan on every child when possible — and the user has issue URLs plus the STE summary and next steps.

### Step 4 — Persist plan artifacts, then stop

Follow **Persist plan artifacts** in [`../brainstorm/references/tracer-ticket-breakdown.md`](../brainstorm/references/tracer-ticket-breakdown.md). Report the plan summary, issue URLs, and the persist result (baseline branch, commit SHA, draft PR URL, or that nothing changed). Stop. Do not begin implementation or run `implement-ticket` — the user must trigger implementation manually via the `implement-ticket` skill.

**Done when:** that shared reference’s persist completion criteria are met, and the user has been told to run `implement-ticket` manually when ready.
