# Backport changes

Backporting changes in a GitHub pull request (PR) involves applying specific changes from one branch to another, typically from a main or development branch to a stable or release branch. This process is commonly used to bring minor changes and bug fixes from a newer version of the codebase to an older, more stable version. Selective backporting also allows us to make major/breaking changes on the development (main) branch without impacting code on a release branch.

## When to backport

Our collections all use [semantic versioning](https://semver.org/), summarized as follows. Given a version number MAJOR.MINOR.PATCH, increment the:

* MAJOR version when making incompatible API changes.
* MINOR version when adding functionality in a backward compatible manner or when deprecating (but not removing) functionality.
* PATCH version when making backward compatible bug fixes.

Only the two latest major versions of our collections receive backports. If you are contributing a PR to a new collection that does not have at least two major versions, you can skip backporting. 

The latest major release receives minor new features, security and bug fixes, and deprecations. The previous major release generally only receives security and bug fixes. [Changelog fragments](https://docs.ansible.com/ansible/latest/community/development_process.html#creating-changelog-fragments) are our guide to which PRs get backported where, which means it's very important that each PR has a changelog fragment that accurately reflects the type of change contained in the PR.

To illustrate this, let's imagine a scenario where our latest major release branch is `stable-7` with latest release `7.1.0`, and our previous major release branch is `stable-6` with latest release `6.5.0`:

* We *never* backport PRs that have the following changelog fragment sections. Because these changes break the existing collection's user-facing functionality, they will be released in version `8.0.0` via a new `stable-8` branch created from the main branch.
  * `breaking_changes`
  * `major_changes`
  * `removed_features`

* We backport PRs that have the following changelog fragment sections to the latest major branch only, in this case `stable-7`. They may also be backported to `stable-6` at our discretion, but this is rare. Because these changes are backward compatible but add or deprecate functionality, they will be released in version `7.2.0` from the `stable-7` branch.
  * `minor_changes`
  * `deprecated_features`

* PRs that have the following changelog fragment sections are backported to *both* the latest major branch and the previous major branch, in this case `stable-7` and `stable-6`. Security fixes and bugfixes should *always* be backported to both supported release branches. These changes will be released in version `6.5.1` from the `stable-6` branch, and may either be released in version `7.1.1` or `7.2.0` from the `stable-7` branch depending on whether there are any minor changes or deprecations ready to be released during the next release cycle.
  * `security_fixes`
  * `bugfixes`
  * `trivial` - occasionally these may not be backported to the previous major branch, depending on the content

## How to backport

To create backport PRs from regular PRs, we utilize the [patchback bot](https://github.com/apps/patchback), which automatically generates backport PRs based on PR labels. All PRs to the main branch of our collection repositories should include at least one backport-related label:

* `do_not_backport`: used to indicate that a PR includes major or breaking changes and should not be backported; these changes will be included in the next major release of the collection. Example: if latest major release branch is `stable-7`, these changes will be released in version `8.0.0`.

OR one or both of:

* `backport-X`: indicates that the PR should be backported to the latest major release branch. Example: if latest major release branch is `stable-7`, these changes will be backported to the `stable-7` branch and released in the next minor or patch release for version 7.
* `backport-(X-1)`: indicates that the PR should be backported to the previous major release branch. Example: if latest major release branch is `stable-7`, these changes will be backported to the `stable-6` (7 - 1) branch and released in the next patch release for version 6.

NOTE: Sometimes the patchback bot fails to autogenerate a PR, usually due to a conflict between the PR code and the branch code. When this happens, you must follow the instructions in the original PR's comment from patchback bot to create a manual backport PR.

## Who is responsible for backports

Within our team, if you create PR into one of our repositories, it is your responsibility to ensure that all appropriate backport PRs are created, pass CI, and get reviewed and merged. However we all have a responsibility for ensuring the process is followed through each step of a PR:

* When you submit an initial PR, you should label it according to the guidelines described here.
* When you review a PR, you should verify that the backport labels are correct.
* Before merging a PR, you should verify that the backport labels are correct.
* Once a PR you submitted has merged, you should verify that backport PRs were created successfully and if any were not, create a manual backport PR for them.
* Once a backport PR has been created from a PR you submitted, you should request reviews and ensure it gets merged.

## Quick reference

Prefer a visual reference to a bunch of words? Here's a handy table, where X.Y.Z represents the latest release:

| **PR changes** | **Backport label(s)** | **Release version** |
| -------------- | --------------------- | ------------------- |
| `breaking_changes` | `do_not_backport` | Next major release `(X+1).0.0` |
| `major_changes` | `do_not_backport` | Next major release `(X+1).0.0` |
| `removed_features` | `do_not_backport` | Next major release `(X+1).0.0` |
| `minor_changes` | `stable-X` | Next minor release `X.(Y+1).0` |
| `deprecated_features` | `stable-X` | Next minor release `X.(Y+1).0` |
| `security_fixes` | `stable-X` <br>`stable-(X-1)` | Next minor release `X.(Y+1).Z` OR next patch release `X.Y.(Z+1)` <br> Next patch release `(X-1).y.(z+1)` |
| `bugfixes` | `stable-X` <br>`stable-(X-1)` | Next minor release `X.(Y+1).Z` OR next patch release `X.Y.(Z+1)` <br> Next patch release `(X-1).y.(z+1)` |
| `trivial` | `stable-X` <br>`stable-(X-1)` | Next minor release `X.(Y+1).Z` OR next patch release `X.Y.(Z+1)` <br> Next patch release `(X-1).y.(z+1)` |

## References:

https://docs.ansible.com/ansible/latest/community/development_process.html
