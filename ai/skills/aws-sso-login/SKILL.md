---
name: aws-sso-login
description: Authenticate to AWS using Single Sign-On (SSO). Use when AWS CLI operations require SSO authentication or when SSO session has expired.
---

## Workflow

### Step 1 — Determine the Profile

Identify the AWS CLI profile configured for SSO. Use the project’s documented default if one exists. If the profile name is not available from project docs or prior context, ask the user which profile to use before continuing.

Follow [`references/notes.md`](references/notes.md): profile documentation guidance, setup prerequisites, and operational notes.

**Done when:** you have a specific AWS CLI profile name to use for this run.

### Step 2 — Authenticate

Run `aws sso login --profile <profile-name>`.

If the CLI opens a browser, continue there. If it prints a device or verification URL instead, present that URL so the user can open it manually.

**Done when:** the AWS SSO login flow has completed for the selected profile.

### Step 3 — Verify the Session

Run `aws sts get-caller-identity --profile <profile-name>` and confirm it succeeds.

**Done when:** `aws sts get-caller-identity --profile <profile-name>` exits successfully and returns identity JSON including fields such as `Account`, `Arn`, and `UserId`.

## Command Example

```bash
# Login with SSO using specified profile
aws sso login --profile <profile-name>
```
