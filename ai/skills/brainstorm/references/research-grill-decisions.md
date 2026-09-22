# Research, grill, decision capture

Shared by `brainstorm` and `troubleshoot` during plan generation (their Step 2). Load **before** the calling skill’s expert consult. The consult itself stays in the calling skill (both use **Consultant**; `troubleshoot` also passes the incident revision).

**Done when (whole file):** the research/grill **Done when** is met, and the decision-capture **Done when** is met or no grilling session ran.

## Research store

One Markdown file per inquiry:

`docs/research/<scope>/<inquiry-slug>.md`

Example: `docs/research/42/oauth-token-refresh.md`

`<inquiry-slug>` is a lowercase kebab-case name of that question. The same question updates its file. A different question is a new file in the same scope directory.

`<scope>` is one directory name, in this order:

1. The EPIC `{TICKET_ID}` from `issue-tracker` **Identity** when this work has an EPIC (the in-hand ticket carries `epic` or linked children, or **Operations** parent returns one).
2. Otherwise the in-hand ticket’s `{TICKET_ID}`.
3. Otherwise a lowercase kebab-case topic slug for the effort (`checkout-latency`).

The directory name is the bare `{TICKET_ID}` (`42`).

**Scope rename.** After filing, when `<scope>` is still a topic slug, move `docs/research/<topic-slug>/` to `docs/research/<main-issue-id>/` before persist. When that main-issue directory already exists, move this run’s files into it and remove the emptied topic-slug directory. A scope that is already a `{TICKET_ID}` stays, so an EPIC directory stays on the EPIC id. Persist applies this rename.

## Research, then grill

If context is dubious, unclear, or needs external facts (unfamiliar APIs, libraries, specs, prior art, prior incidents):

1. Resolve `<scope>` and `<inquiry-slug>` from **Research store**.
2. Dispatch the `research` skill as a **background agent** **before** grilling so research legwork stays out of this conversation.
3. Task it to write or update that inquiry’s file only, citing sources for each claim. Pass the concrete path from **Research store**.
4. Re-dispatch the same way for each later question that needs external facts.
5. When the agent finishes, take facts only from that inquiry’s file on disk.

Only once that file is ready (or research was not needed), clarify questions research cannot answer (missing decisions, preferences, ambiguous scope):

- `CONTEXT.md` at the repository root → a `/grilling` session using the `/domain-modeling` skill
- else → the plain `grilling` skill

**Done when:** every external fact used onward comes from its inquiry file under `docs/research/<scope>/` (or research was not needed), and remaining non-fact questions have been grilled or there were none.

## Decision capture (after grilling)

Skip this section if no grilling session ran.

When grilling settled **architectural decisions**, write them on disk before the expert consult finalizes — do not leave them only in chat:

- **`CONTEXT.md` present** — each qualifying decision as an ADR via `domain-modeling` (that skill’s three-criteria gate and ADR format). Glossary terms stay in `CONTEXT.md` as the session resolves them.
- **No `CONTEXT.md`** — a dated **Decisions** section in `docs/research/<scope>/decisions.md` (same `<scope>` as **Research store**, including the scope rename): for each settled decision, what was chosen, why, and rejected alternatives. Create the file on the first decision.

If grilling produced no architectural decisions, say so briefly in the plan and skip this write.

**Done when:** every architectural decision from grilling is on disk (ADR under `docs/adr/` or a Decisions entry in `docs/research/<scope>/decisions.md`), or the plan states none were made.
