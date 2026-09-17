---
name: aws-sso-login
description: AWS SSO login. Use when AWS CLI operations need SSO auth, or the SSO session has expired.
---

## Step 1 — Determine the profile

Identify the AWS CLI profile configured for SSO. Use the project’s documented default if one exists. If the profile name is not available from project docs or prior context, ask the user which profile to use before continuing.

Setup, default-profile docs, headless `--no-browser`, and session expiry: [`references/notes.md`](references/notes.md).

**Done when:** you have a specific AWS CLI profile name for this run.

## Step 2 — Authenticate

Run `aws sso login --profile <profile-name>`.

If the CLI opens a browser, continue there. If it prints a device or verification URL instead, present that URL so the user can open it.

**Done when:** the AWS SSO login flow has completed for the selected profile.

## Step 3 — Verify the session

Run `aws sts get-caller-identity --profile <profile-name>`.

**Done when:** that command exits 0 and the identity JSON includes `Account`, `Arn`, and `UserId`.
