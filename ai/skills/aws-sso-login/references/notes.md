# AWS SSO notes

## Setup

- AWS CLI v2 must be installed.
- The selected profile must already be configured for SSO in `~/.aws/config`.

## Default profile

Document the default profile name in a shared project guide or skill configuration file. Reuse that documented profile when invoking this skill; leave this skill unchanged per repository.

## Session and headless

- SSO sessions commonly expire after 8–12 hours; rerun this skill when AWS CLI commands fail with expired-session errors.
- Authentication uses a browser flow. In headless environments, run `aws sso login --no-browser --profile <profile-name>` and open the printed URL.
