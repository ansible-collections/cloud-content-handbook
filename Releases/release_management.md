# How we manage releases across our collections

## Release manager role

We have a large team (10+ members as of writing this!) and a large number of collections to support (5 supported collections, 1 support Terraform provider, and 4 validated content collections as of writing this!). This means that determining which collections need to be released when, ensuring that release prep work is done, and that releases are tracked and completed is a big job. To make sure this job is done consistently across all collections, we have a release manager role on the team.

### Who is the release manager?

Everyone! But not all at the same time. The release manager role rotates through the team each [release cycle](./release_cycles.md). Rotating the role ensures that:

1. We share the burden -- no one person on the team burns out from managing all of the releases each cycle.
2. It is clear each cycle who is accountable for making sure the releases happen.
3. Everyone on the team understands what is involved in release management.
4. Our documentation is clear and accurate -- each team member should be able to follow it and perform the responsibilities of the role; if not, the docs need to be updated.

### What does the release manager do?

The release manager is *not* responsible for doing all the work involved in releasing all of our collections! Rather, the release manager is *accountable* for ensuring that the work required to release our collections is in Jira, assigned, and gets completed on schedule. Unclear on the difference between responsible and accountable? Check out [these RACI definitions](https://www.teamgantt.com/blog/raci-chart-definition-tips-and-example#raci-definitions-explained).

It's important that the release manager for a given cycle does the tasks below *before* the release sprint, otherwise the related Jira tickets may not get created and added to the sprint until too late.

The specific things a release manager needs to do during their release cycle are as follows:

* Create a Jira epic for the release cycle, under which all release-related tickets should be created.
* Determine whether the cycle requires a major release following the guidelines [here](./release_cycles.md#major-releases).
* If the current month is not a major release month, proceed to the [Minor and patch releases](#2-minor-and-patch-releases) section below. Otherwise...

### 1. Major releases

* Follow steps 1-3 outlined [here](./release_cycles.md#major-releases) to confirm that it's ok to go ahead with major releases for our collections.
* Assuming the major release is approved by partner engineering, do the following for each of our supported collections/providers and validated content collections:
  * Create a Jira ticket for the major release. Example ticket name: `Release version 10.0.0 of amazon.aws collection`. We use Jira automations to ensure that the ticket contains the right information for the release type.
  * Check whether a minor, patch, or no release is needed for the current latest major release branch. If there are backported PRs to the latest stable branch that have `minor_changes` or `deprecated_features`, then a minor release is needed. If there are `security_fixes` or `bugfixes` only, then a patch release is needed. Otherwise no additional release is needed. Note that we do not do a release if there only `trivial` changes.
  * Create a Jira ticket for the minor or patch release.
  * Note: if a minor release is necessary, link the minor release ticket to the major release ticket and mark the major release ticket as blocked by the minor release ticket. This is important because we will want to include the changelog entry from the minor release in the changelog for the new major release, which will only happen if the minor release is completed and the release updates cherry-picked to the main branch *before* the new stable release branch is created from main. Also add an acceptance criterion that the minor release summary should state that this is the last planned minor release for the major version.

### 2. Minor and patch releases

* For each of our supported collections/providers and validated content collections:
  * Check the latest two stable branch changelog fragments and commit histories to see if there have been any `minor_changes`, `deprecated_features`, `security_fixes`, or `bugfixes` commits since the last release. If so, a release is needed!
  * Create jira ticket(s) for the collection release(s) -- if a release is needed for both branches, create a separate Jira ticket for each release.

### 3. For all release types

* Ensure all release-related tickets are prioritized, story pointed, and added to the appropriate sprint to be completed in time for the expected release cycle.
* At this point, the entire team (including the release manager) is responsible for pulling tickets from the backlog, completing the release work according to their assigned tickets, and reviewing each other's release prep PRs.
* The release manager should keep an eye on all of the release-related tickets and ensure work is progressing in time to meet the release date. If release work is not being pulled from the backlog or issues arise, the delivery team 3-in-the-box can help reprioritize as needed.
