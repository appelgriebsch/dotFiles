---
description: Publish the code review comments to the appropriate platform (e.g., GitHub, GitLab, Bitbucket) for the current project.
agent: code-review-orchestrator
model: github-copilot/claude-sonnet-5
---

If there hasn't been run a recent code review for the current branch, inform the user that they need to do it prior to be able to publish the comments.

If there has been a recent code review, which has led to a set of comments categorized by severity (e.g., critical, major, minor), publish the comments of severity "$ARGUMENTS" (default: all severities) to GitHub using the GitHub MCP and add them to the pull request associated with the current branch. If there is no pull request associated with the current branch, inform the user that they need to create one before publishing the comments.

To prevent publishing duplicate comments, check if the comments have already been published to the pull request. If they have, inform the user that the comments have already been published and do not publish them again (new ones should still be published to the pull request).
