---
description: Analyze a given improvement ticket, or idea and provide a detailed plan on how to implement it.
agent: plan
model: github-copilot/claude-sonnet-5
---

Verify the provided input $ARGUMENTS against the expected prefix (usually `DFITE`). If the input matches a valid Jira ticket ID with this prefix, access the ticket details via the Atlassian Jira MCP. If the input does not match a valid Jira ticket ID, treat it instead as an idea or improvement request. In either case, gather relevant information from the ticket or request, including any context, requirements, and constraints. If the ticket or request includes any reference to an existing PRD (Product Requirements Document), use the Atlassian Confluence MCP to look for and access the PRD (and any related documents) and extract relevant information.

With the information gathered from the ticket or request, generate a detailed implementation plan that includes:

- A summary of the improvement or idea, including any relevant context from the ticket or request.

- A step-by-step guide to implement the improvement or idea, including any necessary changes to the codebase, configuration, or infrastructure.

- A list of potential challenges or risks associated with the implementation, along with recommended mitigation strategies.

- Identify any required tests or validation steps to ensure the improvement or idea is implemented correctly and meets the desired requirements (use the `write-tests` skill for support).

- If the user asked for a prototype or proof of concept, provide a plan for creating and testing the prototype, including any necessary tools, frameworks, or libraries. You may also use the `prototype` skill to assist in creating the prototype.

- If the amount of work is significant, provide a breakdown of the implementation into smaller tasks or milestones, along with estimated timelines for each task or milestone. In addition, provide a diagram or flowchart to illustrate the implementation plan, if applicable. You can use the `pretty-mermaid` skill to assist in creating the diagram or flowchart.

In case of any uncertainties or missing information, use the `grilling` skill to ask the user for clarification or additional details.

Finally, ask the user if he wants to update or create Jira tickets for the implementation plan, and if so, provide a summary of the tasks or milestones that can be used to create or update the tickets. You can use the `create-jira-ticket` skill to assist in creating or updating the tickets. For each ticket created or updated, attach the detailed implementation plan and any relevant context or requirements as identified as attachment to the ticket, use the `handoff` skill to assist in this process.
