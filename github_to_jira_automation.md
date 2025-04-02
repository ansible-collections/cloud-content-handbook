# GitHub to Jira Automation

**Note:** This functionality is a work in progress and not yet live. This document will be updated once the automation is fully operational.

## Summary

For repositories maintained by the Cloud Content team, adding the `jira` label to a GitHub issue will trigger an automation that creates a corresponding Jira ticket in the **ACA** project backlog.

## Automation Workflow

1. A user adds the `jira` label to a GitHub issue.
2. An AWS Lambda function (running in the team AWS account) is triggered.
3. A new Jira issue is created and placed in the **ACA backlog**.

## Details

- Uses a dedicated **Jira bot/service account**.
- The script authenticates with Jira using a **Personal Access Token (PAT)**.
- The Jira PAT and Jira bot/service account credentials are:
  - Stored securely in the team’s **Bitwarden vault**
  - Also added to AWS **Secrets Manager** for use by the Lambda
- The script authenticates with GitHub using a **Personal Access Token (PAT)**.
- The GitHub PAT is:
  - Stored securely in the team’s **Bitwarden vault**
  - Also added to AWS **Secrets Manager** for use by the Lambda