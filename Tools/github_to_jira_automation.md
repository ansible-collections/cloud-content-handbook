# GitHub to Jira Automation

**Note:** This functionality is a work in progress and not yet live. This document will be updated once the automation is fully operational. In the meantime, the script can be manually run. Please see the `Manual Instructions` section for details.  

## Summary

For repositories maintained by the Cloud Content team, GitHub issues tagged with the `jira` label will be picked up by an automation process that creates corresponding Jira tickets in the **ACA** project backlog.

## Automation Workflow

1. A user adds the `jira` label to a GitHub issue.
2. An AWS Lambda function, running on a schedule like a cron job, periodically checks for new issues with the `jira` label.
3. When a new labeled issue is found, a corresponding Jira issue is created and placed in the **ACA backlog**.

### Details

- Uses a dedicated **Jira bot/service account**.
- The script authenticates with **Jira** and **GitHub** using the team account’s **Personal Access Tokens (PATs)**.
- The PATs and Jira service account credentials are:
  - Stored securely in the team’s **Bitwarden vault**.
  - Also added to **AWS Secrets Manager** for use by the Lambda function.

## Manual Instructions

1. Clone the utilities [repo](https://github.com/jillr/utilities) 

```
$ git clone git@github.com:jillr/utilities.git
$ cd utilities/jira
```

2. Create a config file 

```
$ cat config
jira_token: personal access token
jira_user: yournamehere
jira_pw: foobarbaz
jira_server: https://jira.example.com
gh_token: ghp_1234567890abcdefghijklmnop
```

3. Run the [script](https://github.com/jillr/utilities/blob/main/jira/github_jira.py)

```
$ python github_jira.py
```
