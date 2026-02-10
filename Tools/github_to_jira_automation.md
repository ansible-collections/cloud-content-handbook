# GitHub to Jira Automation

 There are currently two distinct GitHub -> Jira integrations outlined here:
 1. [Automatic Jira Ticket Creation](#automatic-jira-ticket-creation)
 2. [Populating Jira Tickets from GitHub PRs/Branch/Commits](#populating-jira-tickets-from-github-prsbranchcommits)

## Automatic Jira Ticket Creation

**Note:** This functionality is a work in progress and not yet live. This document will be updated once the automation is fully operational. In the meantime, the script can be manually run. Please see the `Manual Instructions` section for details. 

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

## Populating Jira Tickets from GitHub PRs/Branch/Commits via the DVCS (Distributed Version Control System) Connector

A separate integration allows developers to automatically populate a Jira ticket with **associated pull requests**, **source branch information**, and **commits**. This keeps tickets up to date with development activity without manual updates.

### How it works

- When pull requests are opened, updated, or merged in repositories linked to the team’s Jira project, the connector syncs that activity to the corresponding Jira ticket.
- The ticket is updated with:
  - **Linked PRs** – References to each related pull request (e.g. title, link, status).
  - **Source branch** – The branch name and, where applicable, a link or reference so reviewers can see which branch the work came from.
  - **Commits** - The commit information will be picked up by the connector, providing a link to the exact hash.

### Benefits

- **Traceability** – One place to see all PRs and branches tied to a ticket.
- **Less manual work** – No need to paste PR links or branch names into the ticket.
- **Consistency** – The same format and fields are used across tickets.

### Usage notes

- Jira tickets are typically linked to GitHub work via the ticket key in the branch name or in the PR title (e.g. `ACA-1234-add-feature` or “Fixes ACA-1234”). Only having the ticket key in the PR description will not guarantee information is transferred.
- Ensure your repo and Jira project are correctly configured for the connector (e.g. in Jira project settings or the integration’s admin UI) so PRs and branches are matched to the right tickets. (See details [here](https://spaces.redhat.com/spaces/OMEGA/pages/213427580/GitHub+integration+with+Red+Hat+Jira+via+DVCS) - must be on Red Hat VPN)

### Currently Configured Collection Repositories
- [amazon.aws](https://github.com/ansible-collections/amazon.aws)
- [cloud.common](https://github.com/ansible-collections/cloud.common)
- [kubernetes.core](https://github.com/ansible-collections/kubernetes.core)
- [amazon.cloud](https://github.com/ansible-collections/amazon.cloud)
- [ansible.mcp](https://github.com/ansible-collections/ansible.mcp)
