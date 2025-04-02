# GitHub to Jira Automation

**Note:** This functionality is a work in progress and not yet live. This document will be updated once the automation is fully operational.

## Summary

For repositories maintained by the Cloud Content team, GitHub issues tagged with the `jira` label will be picked up by an automation process that creates corresponding Jira tickets in the **ACA** project backlog.

## Automation Workflow

1. A user adds the `jira` label to a GitHub issue.
2. An AWS Lambda function, running on a schedule like a cron job, periodically checks for new issues with the `jira` label.
3. When a new labeled issue is found, a corresponding Jira issue is created and placed in the **ACA backlog**.

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