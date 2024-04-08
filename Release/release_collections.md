# Release cycle for supported collections

Supported collections must have an up to date `requires_ansible` version in their `meta/runtime.yml` file. This update is a breaking change and requires making a new major version release. For collections that are also released in the ansible community package, new major versions must be released shortly before a new version of ansible-core. In order to find a solution that fulfills both of these competing requirements, the following release schedule should be used:

1. Note the release cycle for the upcoming [ansible-core release](https://docs.ansible.com/ansible/latest/roadmap/ansible_core_roadmap_index.html) and the upcoming [ansible community release](https://docs.ansible.com/ansible/latest/roadmap/ansible_roadmap_index.html).
2. After the latest ansible-core release candidate (RC) has been released, verify with the core team if another RC is planned.
3. Once the last planned RC has been made, increase the `requires_ansible` version by one version.
4. Prep and perform a release within two weeks of the next ansible-core release.

Note that this procedure only needs to be followed for supported collections with new major versions that need to go out in the next ansible community package. For all other collections, new major releases can be made shortly after the latest ansible-core release.

# Steps to release a collection to Automation hub and Galaxy

* Determine the collection version based on [Semantic Versioning](https://semver.org/). eg: x.y.z
   * For major/breaking change release, increment x. Resulting branch will be x+1.0.0.
   * For minor changes, increment y. Resulting branch will be x.y+1.0.
   * For bugfixes/patch/trivial changes, increment z. Resulting branch will be x.y.z+1.

* In case of a major release, create a new branch `stable-X`, where `X` denotes the major version number. The new branch is based on the main branch.

   ```
   git checkout main
   git branch stable-X main
   ```

* For a minor release, make sure the backport of the PRs from the main branch to the release branch is successful. For backporting of PRs refer to [the backporting documentation](https://github.com/ansible-collections/cloud-content-handbook/blob/main/backport_changes.md).

* Create and check out a new branch and prepare the collection for release by following the instructions provided [here](https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_releasing.html#preparing-to-release-a-collection).

   ```
   git checkout -b prep_release_x stable-X
   ```

* Update the CHANGELOG:
   * Add a changelog fragment `changelogs/fragments/<version>.yml` for the release summary as follows
   ```
   release_summary: < release content >
   ```
   * Ensure you have the latest version of [`antsibull-changelog`](https://ansible.readthedocs.io/projects/antsibull-changelog/) installed.
   * Confirm there are fragments for all known changes in changelogs/fragments.
   * Run antsibull-changelog release.
   ```
   antsibull-changelog release --version <version>
   ```

* Verify `CHANGELOG.rst` for the presence of all the changelog fragments.

* Commit the changes and create a pull request into the upstream repository. Make sure you choose `stable-X` as your base branch. This will be the preparation PR for the release. Ensure the CI passes. Once the `prep` PR is merged, update the local copy of `stable-X` branch with the latest changes from the `prep` PR.
_Note : If the sanity tests fail locally or in the CI, the failures have to be addressed in a separate PR_

* Tag the version in Git and push to GitHub.

   ```
   git tag -m "Release <version>" <version>
   git push upstream <version>
   ```

* Once the [CI for the release](https://ansible.softwarefactory-project.io/zuul/status) passes, notify the #ansible-partners slack channel about the release, for approval for the release on Automation Hub. `Validated Content collections` and `redhat.openshift` collection are manually uploaded to Automation Hub. To manually upload a collection to Automation Hub, please refer to the instructions [here](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Release/release_automation_hub.md). Manual upload is performed in cases where automated upload to Automation Hub fails.

* Check for the latest version of the collection on Galaxy and Automation Hub.

* To include an announcement of the release in Bullhorn, tag the newsbot and add a message in the [Ansible-Social Matrix Channel]( https://chat.ansible.im/#/room/#social:ansible.com).

   ```
   Sample message:
   @newsbot
   : amazon.aws 7.0.0 has been released with new bugfixes, features, plugins, and modules. Refer the <changelog> for details!
   ```

* Create a PR in the collection to merge the changes made in the release PR to the the main branch. This can be done manually or using the `cherry-pick` command as given below.

   _This example assumes that the released version is 3.0.0_
   ```
   git checkout main
   git pull
   git checkout -b cherry-pick/stable-3/release_sync
   git cherry-pick -x <commitSHA_from_Stable-3>
   ```
   You can also use [CPython’s cherry-picker tool](https://pypi.org/project/cherry_picker/#cherry-picking).

   Push the branch to your fork and create a PR into the main branch of the upstream repository. Once the CI passes and the PR is approved, merge it to the main branch.

# Reference:
https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_release_with_branches.html#releasing-major-collection-versions

https://docs.ansible.com/ansible/latest/community/development_process.html
