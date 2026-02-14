# Steps to release a collection to Automation hub and Galaxy

**Note:** If you are releasing a brand new collection for the first time, please follow the [steps to release a new collection](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_new_collection.md) before proceeding with the steps below.

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

* For a **minor release**, make sure the backport of the PRs from the `main` branch to the release branch is successful. For more information on backporting PRs, refer to [the backporting page](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/backport_changes.md) of the team handbook.

   > **HashiCorp Vault Collection (`hashicorp.vault`)**: Since the backport workflow is not currently [as of December 2025] running for this collection, **before starting the release preparation**, verify that the `stable-X` branch has all necessary changes from `main`:
   > * Review PRs merged to `main` since the `stable-X` branch was created (or since the last release)
   > * Ensure that all appropriate backports have been completed manually (see [backporting guidelines](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/backport_changes.md))
   > * **Important**: Do NOT merge `main` directly into `stable-X`, as this would bring breaking changes that should not be included in the stable release. Only selective backports of appropriate changes (bugfixes, security fixes, minor features, etc.) should be included.

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

   > **HashiCorp Vault Collection (`hashicorp.vault`)**:
   > Instead of tagging directly, create a GitHub Release:
   > 1. Navigate to the [Releases page](https://github.com/ansible-automation-platform/hashicorp.vault/releases) and select `Draft a new release`
   > 2. Use `stable-X` as the target branch
   > 3. Create a new tag with the version number (e.g., `1.1.0`)
   > 4. **IMPORTANT**: Do NOT use the 'v' prefix in the tag (use `1.1.0`, not `v1.1.0`). Partner Engineering accepts only semantic versioning format `x.y.z`
   > 5. Add release notes (typically copied from the CHANGELOG)
   > 6. Publish the release
   >
   > Once published, the [`release_ah` workflow](https://github.com/ansible-automation-platform/hashicorp.vault/actions/workflows/release_ah.yml) will automatically trigger to build and publish to Automation Hub. Monitor the workflow to ensure it completes successfully.

* **Once the [CI for the release](https://ansible.softwarefactory-project.io/zuul/status) passes** (standard collections), inform the Partner Engineering team on the `#ansible-partners` Slack channel about the release. For supported content collections (e.g., `amazon.aws`), this includes requesting approval for Automation Hub.

   > ** HashiCorp Vault Collection (`hashicorp.vault`)**: Skip the Zuul CI step - the GitHub Actions workflow handles publishing automatically. After the workflow completes successfully, inform the Partner Engineering team on the `#ansible-partners` channel about the release.

* Manual upload is performed in cases where automated upload to Automation Hub fails. To do this, please refer to the instructions [here](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_automation_hub.md).

* Check for the latest version of the collection on [Galaxy](https://galaxy.ansible.com) and, if applicable, Automation Hub.

* To include an announcement of the release in Bullhorn, tag the newsbot and add a message in the [Ansible-Social Matrix Channel]( https://chat.ansible.im/#/room/#social:ansible.com).

   ```
   Sample message:
   @newsbot
   : amazon.aws 7.0.0 has been released with new bugfixes, features, plugins, and modules. Refer the <changelog> for details!
   ```

* For `amazon.aws` and `community.aws` collection releases, please announce the release in the [Ansible Forum, under the `News & Announcements` category](https://forum.ansible.com/c/news/5). You can either follow the template in [this post](https://forum.ansible.com/t/amazon-aws-10-1-2-and-9-5-2-bugfix-releases-are-live/44653), or create your own post.

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


## Collection-Specific Notes

* **HashiCorp Vault Collection (`hashicorp.vault`)**: This collection uses GitHub Actions instead of Zuul CI for automated publishing. Look for the  HashiCorp Vault Collection callouts throughout the steps above for specific instructions. The key differences are:
  * Create a GitHub Release instead of tagging directly (do NOT use 'v' prefix in tags)
  * The [`release_ah` workflow](https://github.com/ansible-automation-platform/hashicorp.vault/actions/workflows/release_ah.yml) automatically publishes to Automation Hub when a GitHub release is created

# Reference:
https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_release_with_branches.html#releasing-major-collection-versions

https://docs.ansible.com/ansible/latest/community/development_process.html
