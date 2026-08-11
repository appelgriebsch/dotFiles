# AWS SSO Login Notes

## Setup prerequisites

- AWS CLI v2 must be installed.
- The selected profile must already be configured for SSO in `~/.aws/config`.
- Network access to the SSO authentication endpoint is required.

## Project configuration

- Document the default profile name in a shared project guide or skill configuration file.
- Reuse that documented profile when invoking this skill instead of editing the skill per repository.

## Operational notes

- SSO sessions commonly expire after 8-12 hours; rerun this skill when AWS CLI commands fail with expired-session errors.
- Authentication requires a browser-based flow. In headless environments, use `aws sso login --no-browser --profile <profile-name>` and open the printed URL manually.
- Run this skill before `assume-cloudformation-role` when that role assumption depends on SSO authentication.
