# Team Decision Record

This page is a running log of decisions made by the Cloud Content Team that someone might reasonably question later. It exists so that when a new team member (or our future selves) asks "why do we do it this way?", there's a written answer instead of relying on memory or digging through Slack history.

## What to Record

Not every decision belongs here. Use judgment:

- **Record**: Decisions that change a process, tool, or convention the team relies on, especially when the reasoning isn't obvious from the decision itself (e.g. "we moved off tool X because it was hard to maintain").
- **Don't record**: Routine or self-explanatory choices that nobody is likely to question (e.g. which day to run a one-off meeting, small wording fixes).

A good test: if someone could reasonably ask "why did we decide this?" six months from now, it belongs here.

## Log

| Date | Decision | Context / Why | Owner | Related work |
|------|----------|----------------|-------|---------------|
| Oct 1 | Keep the standalone `ansible-lint` workflow alongside the certification checker's lint check, accepting the duplication | The certification checker pins `ansible-lint` to an old version matching what galaxy-importer uses in Automation Hub, and getting that version updated upstream is difficult. A standalone job running a newer version of `ansible-lint` catches issues earlier instead of only surfacing them at certification time. This mirrors the sanity-test redundancy already accepted as part of adopting the certification checker. | dnaro | Agreed in Slack |
| Oct 1 | Retire cloud.common once its remaining consumers have removed Turbo Mode | Turbo Mode is being deprecated in the consuming collections. A deprecation warning has already been added, providing a transition path before the functionality is removed. Once Turbo Mode is removed from both vmware.vmware and kubernetes.core, there will be no remaining consumers of the functionality provided by cloud.common. | Nebula Team | ACA-7179 |

## How to Add an Entry

1. Open a PR adding a new row to the table above, with the most recent decision at the top.
2. Fill in the `Related work` column with a Jira ticket key, PR, or public issue link if one exists. This repo is public, so don't link to Red Hat-internal systems (Slack, Jira, etc.) — reference a Jira ticket by key only (e.g. `ACA-7179`), and for Slack discussions just note "Agreed in Slack" or add the conversation summary without a link.
