# Team Decision Record

This page is a running log of decisions made by the Cloud Content Team that someone might reasonably question later. It exists so that when a new team member (or our future selves) asks "why do we do it this way?", there's a written answer instead of relying on memory or digging through Slack history.

## What to Record

Not every decision belongs here. Use judgment:

- **Record**: Decisions that change a process, tool, or convention the team relies on, especially when the reasoning isn't obvious from the decision itself (e.g. "we moved off tool X because it was hard to maintain").
- **Don't record**: Routine or self-explanatory choices that nobody is likely to question (e.g. which day to run a one-off meeting, small wording fixes).

A good test: if someone could reasonably ask "why did we decide this?" six months from now, it belongs here.

## How to Add an Entry

1. Open a PR adding a new row to the relevant table below, with the most recent decision or update at the top. For changes to the unified testing strategy, use the dedicated section.
2. Fill in the `Related work` column with a Jira ticket key, PR, or public issue link if one exists. This repo is public, so don't link to Red Hat-internal systems (Slack, Jira, etc.) — reference a Jira ticket by key only (e.g. `ACA-7179`), and for Slack discussions just note "Agreed in Slack" or add the conversation summary without a link.

## General

| Date | Decision | Context / Why | Owner | Related work |
|------|----------|----------------|-------|---------------|
| Oct 1 | Keep the standalone `ansible-lint` workflow alongside the certification checker's lint check, accepting the duplication | The certification checker pins `ansible-lint` to an old version matching what galaxy-importer uses in Automation Hub, and getting that version updated upstream is difficult. A standalone job running a newer version of `ansible-lint` catches issues earlier instead of only surfacing them at certification time. This mirrors the sanity-test redundancy already accepted as part of adopting the certification checker. | dnaro | Agreed in Slack |
| Oct 1 | Retire cloud.common once its remaining consumers have removed Turbo Mode | Turbo Mode is being deprecated in the consuming collections. A deprecation warning has already been added, providing a transition path before the functionality is removed. Once Turbo Mode is removed from both vmware.vmware and kubernetes.core, there will be no remaining consumers of the functionality provided by cloud.common. | Nebula Team | ACA-7179 |

## Unified Testing Strategy

Use this section to record decisions and subsequent updates to the team's unified testing strategy. Add updates as new entries so the history of the decision remains visible, with the most recent entry first.

| Date | Decision / Update | Context / Why | Owner | Related work |
|------|-------------------|----------------|-------|---------------|
| Oct 12 | Backport the unified testing strategy CI changes from `main` to `stable-12` after the 12.0.0 release, and backport the pre-commit hook changes to `stable-11` in addition to `stable-12`. Once the backports land and the unified testing work is complete, ship them in a `stable-12` minor/patch release rather than waiting for `stable-13`. The team is targeting completion of this work within four weeks. | Monthly releases are built off `stable-12`, so keeping the changes strictly on `main` would delay them until the next major release (v13). Since the unified testing strategy is being piloted with amazon.aws, the team preferred to release sooner via a 12.x release instead of waiting for a major version bump. | Gomathi, abuzachis | Agreed in Slack |
| Oct 9 | Keep the existing two-team-member PR approval requirement rather than raising it collection-wide; for PRs labeled `unified-testing`, the submitter is responsible for proactively looping in relevant reviewers | Raising the bar across all PRs risked becoming a review bottleneck. The two-approval policy already balances review coverage against throughput; extra scrutiny should be targeted at the PRs that need it rather than applied broadly. The team will revisit if gaps surface after merging. | Gomathi, dnaro | Agreed in Slack |
| Oct 9 | Use the existing `unified-testing` GitHub label on amazon.aws/community.aws issues and PRs to flag and prioritize review of unified testing strategy work | Makes it easier for reviewers to find and prioritize unified-testing-related changes amid the volume of PRs, and gives context during review without needing to track every PR individually. | abikouo, dnaro | Agreed in Slack |
| Oct 9 | Keep the handbook updated as the single source of truth for unified testing strategy decisions and reasoning, including its impact on backports and branch maintenance | Changes are spread across multiple PRs/phases, making overall progress and rationale hard to follow. A current handbook makes onboarding to the Foundation Pod easier and preserves the reasoning behind past choices. | abuzachis | Agreed in Slack |
