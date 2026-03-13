# Steps to release a collection to Automation hub and Galaxy

**Note:** If you are releasing a brand new collection for the first time, please follow the [steps to release a new collection](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_new_collection.md) before proceeding with the steps below.

## Release Preparation
### Determining the Version Increment
* Determine the collection version based on [Semantic Versioning](https://semver.org/). eg: x.y.z
   * For major/breaking change release, increment x. Resulting branch will be x+1.0.0.
   * For minor changes, increment y. Resulting branch will be x.y+1.0.
   * For bugfixes/patch/trivial changes, increment z. Resulting branch will be x.y.z+1.

### Branching / Branch Preparation
* For a **major release**, switch to the new branch `stable-X`, where `X` represents the major version number. This branch is typically created during the code freeze. If it doesn’t already exist, create it from the `main` branch at the time of release.

   ```
   git checkout main
   git branch stable-X main  --> If a new branch is needed
   git checkout stable-X
   ```

* For a **major release**, create a separate PR to update any branch references from `main` to `stable-x` and ensure it is merged to the `stable-X` branch before starting the release preparation PR. The file changes needed for this step vary in each collection. Commonly updated files include:
   * galaxy.yml
   * README.md
   * docs/docsite/links.yml

* For a **major release**, if an ansible-core version (`requires_ansible`) update is not already included, please verify whether an update is needed. If it is, create a separate PR for the version update and ensure it is merged to the `stable-X` branch before starting the release preparation PR. If you're unsure whether an update is required, please consult the team in the team Slack channel.

* For a **major release**, create a separate, standalone PR for the main branch that increments the development version in the `galaxy.yml` file, located in the root directory of the collection, with the appropriate value (e.g., `version: 10.0.0-dev0` would be changed to `version: 11.0.0-dev0`).

   **NOTE:** For the [`amazon.aws`](https://github.com/ansible-collections/amazon.aws) and [`community.aws`](https://github.com/ansible-collections/community.aws) collections _only_, an additional version value that needs to be incrememented is `AMAZON_AWS_COLLECTION_VERSION` in [`plugins/module_utils/common.py`](https://github.com/ansible-collections/amazon.aws/blob/5100ca0d861fec6a9ef88d55c98c656fe345c149/plugins/module_utils/common.py#L7).


* For a **minor release**, make sure the backport of the PRs from the `main` branch to the release branch is successful. For more information on backporting PRs, refer to [the backporting page](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/backport_changes.md) of the team handbook.

### Preparing the Collection
* Create and check out a new branch (an ideal branch name is something like `prep_release_x_y_z`, where `x_y_z` are the version numbers, e.g., `prep_release_10_0_0`) and prepare the collection for release by following the instructions provided [here](https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_releasing.html#preparing-to-release-a-collection).

   ```
   git checkout -b prep_release_x_y_z stable-X
   ```

* Update the version key in the `galaxy.yml` file, located in the root directory of the collection, with the appropriate value (`x.y.z`).

   **NOTE:** For the [`amazon.aws`](https://github.com/ansible-collections/amazon.aws) and [`community.aws`](https://github.com/ansible-collections/community.aws) collections _only_, an additional version value that needs to be incrememented is `AMAZON_AWS_COLLECTION_VERSION` in [`plugins/module_utils/common.py`](https://github.com/ansible-collections/amazon.aws/blob/5100ca0d861fec6a9ef88d55c98c656fe345c149/plugins/module_utils/common.py#L7).

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

* Verify that `CHANGELOG.rst` does not have any additional changes outside of your new release. If it does, correct the changes in `changelogs/changelog.yml` and run `antsibull-changelog generate`. `CHANGELOG.rst` should not be manually changed.

* Commit the changes and create a pull request into the upstream repository. Make sure you choose `stable-X` as your base branch. This will be the preparation PR for the release.

* Ensure the CI passes before merging. Ideally it is best to wait until the release date (or the day before it) to merge the release prep PR.
   **NOTE:**  It is recommended to also run the sanity and integration tests locally to ensure all tests are passing.

## Release

### Git Tagging
* Once the `prep` PR is merged, update the local copy of `stable-X` branch with the latest changes from the `prep` PR.
   **NOTE:**  If the sanity tests fail locally or in the CI, the failures have to be addressed in a separate PR.

* Tag the version in Git and push to GitHub.

   ```
   git tag -m "Release <version>" <version>
   git push upstream <version>
   ```

* For **hashicorp.vault**, after pushing the tag follow the [HashiCorp Vault section](#hashicorp-vault-collection-hashicorpvault--where-it-differs) below to create a GitHub Release and run the release workflow.

### Validating Automation Hub / Galaxy Upload
* Once the [CI for the release](https://ansible.softwarefactory-project.io/zuul/status) passes, post a message on the `#ansible-partners` Slack channel requesting an approval for any supported content collections (e.g., `amazon.aws`) for Automation Hub.

* Manual upload is performed in cases where automated upload to Automation Hub fails. To do this, please refer to the instructions [here](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_automation_hub.md).

* Check for the latest version of the collection on [Galaxy](https://galaxy.ansible.com) and, if applicable, Automation Hub.

### Announcing the Release
* To include an announcement of the release in Bullhorn, tag the newsbot and add a message in the [Ansible-Social Matrix Channel]( https://chat.ansible.im/#/room/#social:ansible.com).

   ```
   Sample message:
   @newsbot
   : amazon.aws 10.0.0 has been released with new bugfixes, features, plugins, and modules. Refer the <changelog> for details!
   ```

* For `amazon.aws` and `community.aws` collection releases, please also announce the release in the [Ansible Forum, under the `News & Announcements > Ecosystem Releases` category](https://forum.ansible.com/c/news/5). You can either follow the template in [this post](https://forum.ansible.com/t/amazon-aws-10-1-2-and-9-5-2-bugfix-releases-are-live/44653), or create your own post.

   **NOTE:** Please note that posts to the News & Announcements category undergo a standard moderator review before appearing publicly. Any questions can be directed to [#ansible-community](https://redhat.enterprise.slack.com/archives/C7CTDTP2R).

### Synchronizing main
* Create a PR in the collection to merge the changes made in the release prep PR to the the `main` branch. This can be done manually or using the `cherry-pick` command as shown below:

   _This example assumes that the released version is 10.0.0_
   ```
   git checkout main
   git pull
   git checkout -b cherry-pick/stable-10/release_sync
   git cherry-pick -x <commitSHA_from_Stable-10>
   ```

   You can also use [CPython’s cherry-picker tool](https://pypi.org/project/cherry_picker/#cherry-picking).

   **NOTE:** Cherry-picking will likely trigger conflicts in metadata files. Ensure the changes reflect the development version on the `main` branch.

* Push the branch to your fork and create a PR into the `main` branch of the upstream repository. Once the CI passes and the PR is approved by the required number of maintainers (typically at least 4), merge it to the `main` branch.

---

## HashiCorp Vault collection (`hashicorp.vault`) — where it differs

For **hashicorp.vault**, use the **same steps as for any other collection** (including minor releases): version increment, branching, preparing the collection, prep branch, `galaxy.yml`, CHANGELOG, prep PR, merge, and "Synchronizing main" — all as described above.

After you **create and push the tag** (same as other collections — see [Git Tagging](#git-tagging) above), create a **GitHub Release** that uses that tag. Publishing the release triggers the GitHub Action that publishes to Automation Hub. Steps:

### After pushing the tag: create a GitHub Release using that tag

1. **Draft a new release**
   * Go to the [Releases page](https://github.com/ansible-automation-platform/hashicorp.vault/releases) and click **Draft a new release**.

2. **Select the tag you pushed**
   * In "Choose a tag", select the **existing tag** you created and pushed (e.g. `1.1.0`). Do **not** use a `v` prefix — use `1.1.0`, not `v1.1.0`. Partner Engineering expects semantic versioning format `x.y.z`.
   * Set the target to the appropriate branch (e.g. **`stable-X`**) if prompted.

3. **Release title and notes**
   * Set the release title to the version (e.g. `1.1.0`).
   * Add release notes (typically copy from `CHANGELOG.rst` for this version).

4. **Publish the release**
   * Click **Publish release**.

5. **GitHub Action**
   * Publishing the release triggers the **[`release_ah` workflow](https://github.com/ansible-automation-platform/hashicorp.vault/actions/workflows/release_ah.yml)**, which builds and publishes the collection to Automation Hub.
   * Monitor the workflow run to ensure it completes successfully.

6. **After the workflow succeeds**
   * Skip the Zuul CI step; the GitHub Actions workflow handles publishing.
   * After the workflow completes successfully, inform the Partner Engineering team on the **`#ansible-partners`** Slack channel about the release.

7. **Validation**
   * Check the latest version on [Galaxy](https://galaxy.ansible.com) and Automation Hub as needed.

**Note:** For hashicorp.vault, the backport workflow is not currently running. Before starting release preparation, follow the same "Before starting the release preparation" checks above and do manual backports as needed (see [backporting guidelines](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/backport_changes.md)); do not merge `main` directly into `stable-X`.

---

# Reference:
https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_release_with_branches.html#releasing-major-collection-versions

https://docs.ansible.com/ansible/latest/community/development_process.html
