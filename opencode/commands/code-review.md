---
description: Run code review for the current project
agent: code-review-orchestrator
model: github-copilot/claude-sonnet-5
---

Run a thorough code review for the $ARGUMENTS (default: current project), focusing on the following aspects:

- Code Quality: Check for code readability, maintainability, and adherence to best practices.

- Security: Identify potential security vulnerabilities and suggest improvements.

- Performance: Analyze the code for performance bottlenecks and suggest optimizations.

- Testing: Review the test coverage and quality of existing tests, and recommend additional tests if necessary.

- Dependency Management: Check for outdated or vulnerable dependencies and suggest updates.

If there are any issues found during the code review, categorize them by severity (e.g., critical, major, minor) and provide detailed comments (and potential fixes) for each issue. If no issues are found, inform the user that the code review passed successfully.
