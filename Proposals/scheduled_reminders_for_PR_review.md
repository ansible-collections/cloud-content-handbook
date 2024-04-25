# Scheduled Reminders

Scheduled reminders will aid the team in prioritizing review requests that demand attention. For pull requests, these reminders will dispatch a Slack message to the team channel, containing all open pull requests that the team need to review, at a designated time.

For this process to function, the individual submitting the PR must either add additional team members individually or include the 'cloud-triage' team as reviewers.

## Settings:

**Slack Channel**: ansible-cloud-team

**Reminder Scheduled Days**: Monday, Wednesday, Friday

**Time**: 9:00 AM EST

**Repositories**: `amazon.aws`, `amazon.cloud`, `cloud-content-handbook`, `cloud.common`, `community.aws`

**Ignore Drafts**: yes

**Require Review Requests**: yes

**Remind Authors after Review**: yes, after one review

**Ignore Approved Pull Requests**: yes, after two approvals

**Miniumum Age**: 0 hours. All new PRs will be included in the reminder.

**Minimum Staleness**: 0 hours. All old PRs, that are not waiting on reviews will be included in the reminder.

**Ignored Terms**: `WIP`, `DNM`

**Ignored Labels**: None

**Required Labels**: None 
