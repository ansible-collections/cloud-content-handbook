# Backport changes

Backporting changes in a GitHub pull request (PR) involves applying specific changes from one branch to another, typically from a main or development branch to a stable or release branch. This process is commonly used to bring bug fixes from a newer version of the codebase to an older, more stable version.


## Patchback Bot

For the minor release (X.y.0) of the cloud collection, we utilize the patchback bot for backports. To enable the bot on selected PRs from the `main` branch, label the PRs with tags such as backport-X, where X refers to the target stable-X branch.

### Backport requirements:

If `stable-7` is the latest major release,

* Bugfixes and trivial changes  are backported to the previous two active stable branches - `stable-6` and `stable-5`.
* Feature updates (minor_changes) are backported to previous one active branch - `stable-6`.
* Backward-compatible new features (minor_changes) that pose no maintenance risk are backported to the preceding active branch - `stable-6`.

After the bot successfully creates the backport PRs, they can be merged to the respective branches upon receiving approvals.

## References:
https://docs.ansible.com/ansible/latest/community/development_process.html