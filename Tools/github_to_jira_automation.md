# GitHub to Jira Automation

- [GitHub to Jira Automation](#github-to-jira-automation)
  - [Automatic Jira Ticket Creation](#automatic-jira-ticket-creation)
    - [Automation Workflow](#automation-workflow)
      - [Details](#details)
    - [Manual Instructions](#manual-instructions)
  - [Populating Jira Tickets from GitHub PRs/Branch/Commits via the DVCS (Distributed Version Control System) Connector](#populating-jira-tickets-from-github-prsbranchcommits-via-the-dvcs-distributed-version-control-system-connector)
    - [How it works](#how-it-works)
    - [Benefits](#benefits)
    - [Usage notes](#usage-notes)
    - [Currently Configured Collection Repositories](#currently-configured-collection-repositories)

## Automatic Jira Ticket Creation

For repositories maintained by the Cloud Content team, GitHub issues tagged with the `jira` label are picked up by the **github-to-jira-utility**, which creates corresponding Jira tickets in the **ACA** project backlog.

The automation lives in the **cloud-content-ci-automation** repository under `tools/github-to-jira-utility`. See the [utility README](https://github.com/ansible/cloud-content-ci-automation/blob/main/tools/github-to-jira-utility/README.md) for full details.

### Automation Workflow

1. A user adds the `jira` label to a GitHub issue.
2. An **AWS Lambda function** (github-to-jira-utility), triggered on a schedule via **EventBridge**, scans the configured cloud-content repositories for issues with the `jira` label.
3. For every labeled issue that does not already have a corresponding JIRA ticket, the Lambda function creates an ACA-type Bug in Jira, including the summary, description, labels, components, and a link to the related GitHub issue, and then moves it to **Backlog**.

#### Details

- Uses a dedicated **Jira bot/service account** and the team’s **GitHub Personal Access Token (PAT)** with `repo` scope.
- Credentials are stored in the team’s **Bitwarden vault** and in **AWS Secrets Manager** (secret `cloud_team_jira_login`) for the Lambda. The secret must contain: `cloud_team_jira_bot_token`, `cloud_team_jira_server`, and `cloud_team_gh_token`.
- The Lambda scans a fixed set of cloud-content repositories (defined in the utility’s `lambda/handler.py`).

### Manual Instructions

To run the sync manually or to deploy/update the automation, use the **github-to-jira-utility** in the **cloud-content-ci-automation** repo.

1. **Clone the repo** and go to the utility directory (replace `<repo-url>` with your team’s clone URL for the cloud-content-ci-automation repository):

```bash
git clone <repo-url>
cd cloud-content-ci-automation/tools/github-to-jira-utility
```

2. **Deploy and run (recommended: Ansible)**

   - See [ansible/README.md](https://github.com/ansible/cloud-content-ci-automation/blob/main/tools/github-to-jira-utility/ansible/README.md) in the utility for the full Ansible deployment guide.
   - Prerequisites: ansible-core ≥ 2.15, AWS CLI configured, and an AWS Secrets Manager secret (e.g. `cloud_team_jira_login`) with the Jira and GitHub credentials.
   - One-command deploy:

   ```bash
   cd ansible
   ansible-galaxy collection install -r requirements.yml
   ansible-playbook deploy.yml -e secret_name=cloud_team_jira_login
   ```

   - To trigger a one-off sync, invoke the Lambda using AWS CLI below or manually through AWS Dashboard

   ```bash
   aws lambda invoke --function-name github-to-jira-utility --region us-east-2 --payload '{}' response.json && cat response.json
   ```

3. **Manual Lambda deployment**

   - For building and deploying the Lambda without Ansible, see [lambda/README.md](https://github.com/ansible/cloud-content-ci-automation/blob/main/tools/github-to-jira-utility/lambda/README.md) in the utility. You will build the package from `lambda/`, deploy to AWS, and invoke the function as above.

## Populating Jira Tickets from GitHub PRs/Branch/Commits via the DVCS (Distributed Version Control System) Connector

The DVCS connector allows developers to automatically populate Jira tickets with **associated pull requests**, **source branch information**, and **commits**. This keeps tickets up to date with development activity without manual updates.

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
