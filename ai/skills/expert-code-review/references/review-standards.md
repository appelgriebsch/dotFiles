# Review standards

Load before delivering a review. Apply every standard that fits the findings.

## Quality of findings

- **Specific locations:** Every finding references file/function/line and a concrete fix.
- **Explain the why:** State impact (e.g. security, correctness, data loss), not only the pattern name.
- **Prioritize:** Lead with breakage and security; style only after substantive issues.
- **Answer the user’s framing first:** If they asked a focused question (e.g. thread-safety), answer it before the general list.
- **Acknowledge uncertainty:** Say when language/runtime behavior is uncertain.
- **Real APIs only:** Suggest only APIs and language features that exist.
- **Skip bike-shedding:** Prefer substantive issues over trivial style when both exist.

## Edge cases

- **No dedicated expert:** Surface the gap explicitly. Non-domain process notes (scope, PR hygiene, ticket traceability) are still allowed; domain analysis waits for a specialist.
- **Conflicting experts:** Adjudicate with architectural judgment; state the tradeoff and recommend for the user’s context.
