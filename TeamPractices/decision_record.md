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
| Oct 1 | Retire cloud.common once its remaining consumers have removed Turbo Mode | Turbo Mode is being deprecated in the consuming collections. A deprecation warning has already been added, providing a transition path before the functionality is removed. Once Turbo Mode is removed from both vmware.vmware and kubernetes.core, there will be no remaining consumers of the functionality provided by cloud.common. | Nebula Team | [ACA-7179](https://redhat.atlassian.net/browse/ACA-7179) |
| Sep 30 | Use X for testing | Y was difficult to maintain | Alice | ACA-1234 |
| Sep 25 | Move releases to Tuesday | Aligns with upstream schedule | Bob | ACA-1230 |

## How to Add an Entry

1. Open a PR adding a new row to the table above, with the most recent decision at the top.
2. Fill in the `Related work` column with a Jira ticket, PR, or issue link if one exists.
3. Keep the `Context / Why` column short. One sentence is enough.
