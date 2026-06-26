---
name: brainstorm
description: 
  This skill analyzes a given improvement ticket or idea and provides a detailed plan on how to implement it. It gathers relevant information from the ticket or request, including context, requirements, and constraints, and generates a step-by-step implementation plan. The skill also identifies potential challenges, required tests, and validation steps, and can assist in creating prototypes or breaking down the implementation into smaller tasks or milestones.
argument-hint: 
  - "Please provide the GitHub Issue id or describe the improvement idea you would like to implement."
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

- If the amount of work is significant, provide a breakdown of the implementation into smaller tasks or milestones, along with estimated timelines for each task or milestone. In addition, provide a diagram or flowchart to illustrate the implementation plan, if applicable. You can use the `pretty-mermaid` skill to assist in creating the diagram or flowchart.

In case of any uncertainties or missing information, use the `grilling` skill to ask the user for clarification or additional details.

### Step 3 — GitHub Issue Management

Finally, ask the user if they want to update or create GitHub Issue(s) for the implementation plan. If so, provide a summary of the tasks or milestones that can be used to create or update the issues. For each issue created or updated, attach the detailed implementation plan and any relevant context or requirements as identified as an attachment to the issue (use the `handoff` skill to assist in this process).
