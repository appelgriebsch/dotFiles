# Review standards and edge cases

Load before delivering a review. Apply every standard that fits the findings.

## Quality standards

- **Specific locations:** Every finding references file/function/line and a concrete fix — not generic advice.
- **Explain the why:** State impact (e.g. security, correctness, data loss), not only the pattern name.
- **Prioritize:** Lead with breakage and security; style only after substantive issues.
- **Answer the user’s framing first:** If they asked a focused question (e.g. thread-safety), answer it before the general list.
- **Acknowledge uncertainty:** Say when language/runtime behavior is uncertain.
- **Real APIs only:** Suggest only APIs and language features that exist.
- **Skip bike-shedding:** Prefer substantive issues over trivial style when both exist.
- **Expert-sourced findings:** Domain issues come from matched experts. The orchestrator merges, deduplicates, and prioritizes — it does not add a parallel generalist review.

## Edge cases

- **No dedicated expert:** Surface the gap explicitly. Do **not** substitute orchestrator generalist domain analysis for a missing specialist. Non-domain process notes (scope, PR hygiene, ticket traceability) are still allowed.
- **Conflicting experts:** Adjudicate with architectural judgment; state the tradeoff and recommend for the user’s context.
- **Ambiguous scope:** Ask one focused clarifying question before reviewing. Until scope is clear, do not start inventory or review.
- **Full-codebase review requested:** Confirm, then use **whole source** as the screening corpus (not a changeset-only pass).
- **PR/diff review:** Keep screening and expert matching on the **changeset only**; do not widen inventory to the untouched tree.
