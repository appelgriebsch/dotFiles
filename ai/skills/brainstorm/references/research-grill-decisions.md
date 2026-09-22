# Research, grill, decision capture

Shared by `brainstorm` and `troubleshoot` during plan generation (their Step 2). Load **before** the calling skill’s expert consult. The consult itself stays in the calling skill (both use **Consultant**; `troubleshoot` also passes the incident revision).

**Done when (whole file):** the research/grill **Done when** is met, and the decision-capture **Done when** is met or no grilling session ran.

## Research, then grill

If context is dubious, unclear, or needs external facts (unfamiliar APIs, libraries, specs, prior art, prior incidents):

1. Dispatch the `research` skill as a **background agent** **before** grilling so research legwork stays out of this conversation.
2. Task it to write/update root `RESEARCH.md`, citing sources for each claim.
3. Re-dispatch the same way later if new open questions need external facts.
4. When the agent finishes, take facts only from that file on disk.

Only once `RESEARCH.md` is ready (or research was not needed), clarify questions research cannot answer (missing decisions, preferences, ambiguous scope):

- `CONTEXT.md` at the repository root → a `/grilling` session using the `/domain-modeling` skill
- else → the plain `grilling` skill

**Done when:** facts used onward come only from `RESEARCH.md` on disk (or research was not needed), and remaining non-fact questions have been grilled or there were none.

## Decision capture (after grilling)

Skip this section if no grilling session ran.

When grilling settled **architectural decisions**, write them on disk before the expert consult finalizes — do not leave them only in chat:

- **`CONTEXT.md` present** — each qualifying decision as an ADR via `domain-modeling` (that skill’s three-criteria gate and ADR format). Glossary terms stay in `CONTEXT.md` as the session resolves them.
- **No `CONTEXT.md`** — append a dated **Decisions** section to root `RESEARCH.md` (create the file if needed): for each settled decision, what was chosen, why, and rejected alternatives.

If grilling produced no architectural decisions, say so briefly in the plan and skip this write.

**Done when:** every architectural decision from grilling is on disk (ADR under `docs/adr/` or a Decisions entry in `RESEARCH.md`), or the plan states none were made.
