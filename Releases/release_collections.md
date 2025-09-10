# Steps to release a collection to Automation hub and Galaxy

* Determine the collection version based on [Semantic Versioning](https://semver.org/). eg: x.y.z
   * For major/breaking change release, increment x. Resulting branch will be x+1.0.0.
   * For minor changes, increment y. Resulting branch will be x.y+1.0.
   * For bugfixes/patch/trivial changes, increment z. Resulting branch will be x.y.z+1.

* For a **major release**, switch to the new branch `stable-X`, where `X` represents the major version number. This branch is typically created during the code freeze. If it doesn’t already exist, create it from the `main` branch at the time of release.

   ```
   git checkout main
   git branch stable-X main  --> If a new branch is needed
   git checkout stable-X
   ```

* For a **major release**, if an ansible-core version (`requires_ansible`) update is not already included, please verify whether an update is needed. If it is, create a separate PR for the version update and ensure it is merged to the `stable-X` branch before starting the release preparation PR. If you're unsure whether an update is required, please consult the team in the team Slack channel.

* For a **minor release**, make sure the backport of the PRs from the `main` branch to the release branch is successful. For more information on backporting PRs, refer to [the backporting page](https://github.com/ansible-collections/cloud-content-handbook/blob/main/backport_changes.md) of the team handbook.

* Create and check out a new branch (an ideal branch name is something like `prep_release_x_y_z`, where `x_y_z` are the version numbers, e.g., `prep_release_3_1_0`) and prepare the collection for release by following the instructions provided [here](https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_releasing.html#preparing-to-release-a-collection).

   ```
   git checkout -b prep_release_x_y_z stable-X
   ```

* Update the version key in the `galaxy.yml` file, located in the root directory of the collection, with the appropriate value (`x.y.z`).

* Update the `CHANGELOG`:
   * Add a changelog fragment `changelogs/fragments/<version>.yml` for the release summary as follows:
   ```
   release_summary: < release content >
   ```
   * Ensure you have the latest version of [`antsibull-changelog`](https://ansible.readthedocs.io/projects/antsibull-changelog/) installed.
   * Confirm there are fragments for all known changes in changelogs/fragments.
   * Run `antsibull-changelog release`:
   ```
   antsibull-changelog release
   ```

* Verify `CHANGELOG.rst` for the presence of all the changelog fragments.

* Commit the changes and create a pull request into the upstream repository. Make sure you choose `stable-X` as your base branch. This will be the preparation PR for the release.

* Ensure the CI passes before merging. Ideally it is best to wait until the release date (or the day before it) to merge the release prep PR.

* Once the `prep` PR is merged, update the local copy of `stable-X` branch with the latest changes from the `prep` PR.
_Note : If the sanity tests fail locally or in the CI, the failures have to be addressed in a separate PR_

* Tag the version in Git and push to GitHub.

   ```
   git tag -m "Release <version>" <version>
   git push upstream <version>
   ```

* Once the [CI for the release](https://ansible.softwarefactory-project.io/zuul/status) passes, post a message on the `#ansible-partners` Slack channel requesting an approval for any supported content collections (e.g., `amazon.aws`) for Automation Hub.

* Manual upload is performed in cases where automated upload to Automation Hub fails. To do this, please refer to the instructions [here](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_automation_hub.md).

* Check for the latest version of the collection on [Galaxy](https://galaxy.ansible.com) and, if applicable, Automation Hub.

* To include an announcement of the release in Bullhorn, tag the newsbot and add a message in the [Ansible-Social Matrix Channel]( https://chat.ansible.im/#/room/#social:ansible.com).

   ```
   Sample message:
   @newsbot
   : amazon.aws 7.0.0 has been released with new bugfixes, features, plugins, and modules. Refer the <changelog> for details!
   ```

* Create a PR in the collection to merge the changes made in the release prep PR to the the `main` branch. This can be done manually or using the `cherry-pick` command as shown below:

   _This example assumes that the released version is 3.0.0_
   ```
   git checkout main
   git pull
   git checkout -b cherry-pick/stable-3/release_sync
   git cherry-pick -x <commitSHA_from_Stable-3>
   ```

   You can also use [CPython’s cherry-picker tool](https://pypi.org/project/cherry_picker/#cherry-picking).

   Push the branch to your fork and create a PR into the `main` branch of the upstream repository. Once the CI passes and the PR is approved by the required number of maintainers (typically at least 4), merge it to the `main` branch.

* **In the case of a major release**, create a separate, standalone PR that increments the development version in the `galaxy.yml` file, located in the root directory of the collection, with the appropriate value (e.g., `version: 9.0.0-dev0` would be changed to `version: 10.0.0-dev0`).

   **NOTE:** For the [`amazon.aws` collection](https://github.com/ansible-collections/amazon.aws) _only_, an additional version value that needs to be incrememented in the case of a major release is `AMAZON_AWS_COLLECTION_VERSION` in [`plugins/module_utils/common.py`](https://github.com/ansible-collections/amazon.aws/blob/5100ca0d861fec6a9ef88d55c98c656fe345c149/plugins/module_utils/common.py#L7).


# Reference:
https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_release_with_branches.html#releasing-major-collection-versions

https://docs.ansible.com/ansible/latest/community/development_process.html
