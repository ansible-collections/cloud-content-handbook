# Backport changes

Backporting changes in a GitHub pull request (PR) involves applying specific changes from one branch to another, typically from a main or development branch to a stable or release branch. This process is commonly used to bring bug fixes from a newer version of the codebase to an older, more stable version.


## Patchback Bot

For the minor release (X.y.0) of the cloud collection, we utilize the patchback bot for backports. To enable the bot on selected PRs from the `main` branch, label the PRs with tags such as backport-X, where X refers to the target stable-X branch.

### Backport requirements:

If `stable-7` is the latest major release,

* Bugfixes, securtiy fixes and trivial changes from the main branch are backported to the two latest stable releases - `stable-7` and `stable-6`.
* New features, deprecations and minor changes can be backported to the latest stable release - `stable-7`.

After the bot successfully creates the backport PRs, they can be merged to the respective branches upon passing CI and receiving approvals.

## References:
https://docs.ansible.com/ansible/latest/community/development_process.html
