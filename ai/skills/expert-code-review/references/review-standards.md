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

## Edge cases

- **No dedicated expert:** Apply generalist analysis and note that a specialist would be stronger if available.
- **Conflicting experts:** Adjudicate with architectural judgment; state the tradeoff and recommend for the user’s context.
- **Ambiguous scope:** Ask one focused clarifying question before reviewing.
- **Full-codebase review requested:** Propose a structured approach (module/layer/concern) and confirm before starting.
