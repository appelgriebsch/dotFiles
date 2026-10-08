# Research, grill, decision capture

Shared by `brainstorm` and `troubleshoot` during plan generation (their Step 2). Load **before** the calling skill’s expert consult. The consult itself stays in the calling skill (both use **Consultant**; `troubleshoot` also passes the incident revision).

**Done when (whole file):** the research/grill **Done when** is met, and the decision-capture **Done when** is met or no grilling session ran.

## Scratch

One directory outside the repo for this run: `$TMPDIR/groom-{scope}`.

`{scope}` is the in-hand ticket id when one exists, otherwise a lowercase kebab topic slug (`checkout-latency`).

Inquiry files, `DECISION.md`, and the `PLAN.md` files from [`tracer-ticket-breakdown.md`](tracer-ticket-breakdown.md) share this directory. Nothing here is committed.

## Research, then grill

If context is dubious, unclear, or needs external facts (unfamiliar APIs, libraries, specs, prior art, prior incidents):

1. Dispatch the `research` skill as a **background agent** **before** grilling so research legwork stays out of this conversation.
2. Task it to write or update `{scratch}/{inquiry-slug}.md` only, citing sources for each claim. `{inquiry-slug}` is a lowercase kebab-case name of that question. The same question updates its file. A different question is a new file.
3. Re-dispatch the same way for each later question that needs external facts.
4. When the agent finishes, take facts only from that inquiry’s file.

Only once that file is ready (or research was not needed), clarify questions research cannot answer (missing decisions, preferences, ambiguous scope):

- `GLOSSARY.md` at the repository root → a `/grilling` session using the `/domain-modeling` skill
- else → the plain `grilling` skill

**Done when:** every external fact used onward comes from its inquiry file in **Scratch** (or research was not needed), and remaining non-fact questions have been grilled or there were none.

## Decision capture (after grilling)

Skip this section if no grilling session ran.

When grilling settled **architectural decisions**, record them before the expert consult finalizes:

- **ADR** — root `GLOSSARY.md` is present and the decision passes `domain-modeling`’s three-criteria gate. Write it via that skill (its format and path). Glossary terms stay in `GLOSSARY.md`. That decision stays an ADR only.
- **`DECISION.md`** — every other settled architectural decision (no root `GLOSSARY.md`, or it fails the ADR gate). Append a dated entry to `{scratch}/DECISION.md`: what was chosen, why, and rejected alternatives. Create the file on the first such decision.

If grilling produced no architectural decisions, say so briefly in the plan.

**Done when:** every architectural decision from grilling is an ADR or a dated entry in `{scratch}/DECISION.md`, or the plan states none were made.

## Ticket context files

Context for this ticket, posted to the **main** issue (the leaf, or the EPIC parent) from [`tracer-ticket-breakdown.md`](tracer-ticket-breakdown.md). Not repo files.

- `{scratch}/RESEARCH.md` — when this run has inquiry files: one `## {inquiry-slug}` section per file, body copied as-is (citations included). Write it when filing posts the `RESEARCH` doc comment.
- `{scratch}/DECISION.md` — the file from **Decision capture**, when any non-ADR decision was recorded.
