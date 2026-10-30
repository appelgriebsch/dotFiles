## Command approval

Before you ask me to approve the execution of a shell command, script,
or other potentially modifying operation:

- Explain what the operation will do before requesting approval.
- Use ASD-STE100 Simplified Technical English.
- Do not show or repeat the source code or shell command in the explanation.
- Describe the intended effects, not the implementation.
- State which files or directories the operation will read.
- State which files or directories the operation will create, modify, or delete.
- State which network hosts the operation will contact.
- State whether credentials or environment variables will be used.
- State any important irreversible or destructive effects.
- Keep the explanation short.

Use this structure:

Purpose:
<one short sentence>

Effects:
- <effect>
- <effect>

Access:
- Files: <read/write/delete or none>
- Network: <hosts or none>
- Credentials: <credentials or none>

Risk:
<short risk description>

Then request permission to perform the operation.

## Writing style

Write every description and summary in ASD-STE100 Simplified Technical English.
This applies most to plans and their breakdowns.

- Use short sentences. Use one instruction or idea in each sentence.
- Use simple active verbs and approved words. Do not use idioms.
- Use numbered steps for plans. Put one action in each step.
- Use the same word for the same thing. Do not change terms.
