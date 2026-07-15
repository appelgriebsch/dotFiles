---
name: brainstorm
description: 
  This skill analyzes a given improvement ticket or idea and provides a detailed plan on how to implement it. It gathers relevant information from the ticket or request, including context, requirements, and constraints, and generates a step-by-step implementation plan. The skill also identifies potential challenges, required tests, and validation steps, and can assist in creating prototypes or breaking down the implementation into smaller tasks or milestones.
argument-hint: "Please provide the GitHub Issue id or describe the improvement idea you would like to implement."
disable-model-invocation: true
---

This skill is designed to help users brainstorm and plan the implementation of improvement tickets or ideas. It takes into account the context, requirements, and constraints provided in the ticket or request, and generates a comprehensive implementation plan.

## Workflow

### Step 1 — Parse the Request

Verify if the provided input refers to an open GitHub Issue by utilizing the GitHub MCP. If the input does not match a valid GitHub Issue id, treat it instead as an idea or improvement request. In either case, gather relevant information from the ticket or request, including any context, requirements, and constraints. If the ticket or request includes any reference to an existing PRD (Product Requirements Document), use the GitHub MCP to look for and access the PRD (and any related documents) and extract relevant information.

### Step 2 — Generate Implementation Plan

With the information gathered from the ticket or request, generate a detailed implementation plan that includes:

- A summary of the improvement or idea, including any relevant context from the ticket or request.

- A step-by-step guide to implement the improvement or idea, including any necessary changes to the codebase, configuration, or infrastructure.

- A list of potential challenges or risks associated with the implementation, along with recommended mitigation strategies.

- Identify any required tests or validation steps to ensure the improvement or idea is implemented correctly and meets the desired requirements (use the `write-tests` skill for support if available).

- If the user asked for a prototype or proof of concept, provide a plan for creating and testing the prototype, including any necessary tools, frameworks, or libraries. You may also use the `prototype` skill to assist in creating the prototype.

In case of any uncertainties or missing information, use the `grilling` skill to ask the user for clarification or additional details. If the user isn't sure about the requirements or constraints, you may also use the `research` skill to help gather and clarify the requirements.

### Step 3 - Work breakdown and Task Management

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges** — the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

### Step 4 - GitHub Issue Creation / Management

If we started with a GitHub Issue id, update the issue with a summary of the implementation plan. If we started with an idea or improvement request, create a new GitHub Issue with the summary of the implementation plan (use the GitHub MCP).

For any individual tracer bullet tickets created in Step 3, create corresponding GitHub Issues and link them to the main issue. Ensure that each issue includes a clear description of the task, any relevant context, and the blocking edges identified in Step 3 (use the `handoff` skill to assist in this process).

Finally, provide the user with a summary of the implementation plan, including any created GitHub Issues and their links, and any additional recommendations or next steps for the implementation.
