# Backport changes

Backporting changes in a GitHub pull request (PR) involves applying specific changes from one branch to another, typically from a main or development branch to a stable or release branch. This process is commonly used to bring bug fixes from a newer version of the codebase to an older, more stable version.


## Patchback Bot

For the minor release (X.y.0) of the cloud collection, we utilize the patchback bot for backports. To enable the bot on selected PRs from the main branch, label the PRs with tags such as backport-X, where X refers to the target stable-X branch. These PRs typically contain bug fixes from the main branch. Note that new features are not backported. After the bot successfully creates the backport PRs, they can be merged upon receiving approvals.

-   

