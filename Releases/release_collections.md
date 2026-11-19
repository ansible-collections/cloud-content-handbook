# Steps to release collections on Automation Hub and Galaxy

Use these guidelines to release collections on Ansible Galaxy and Red Hat Ansible Automation Hub.

To release the first version of a collection, please follow the [steps to release a new collection](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_new_collection.md) before proceeding with the steps below.

## Using collection release skills

[Use collection release skills](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_collections_ai_assisted.md) ahead of manual effort.
If the procedure can be documented, it can be encapsulated in a skill.

## Release Preparation

The following steps outline procedures that should be used to troubleshoot and verify where necessary.

### Determining the Version Increment

* Determine the collection version based on [Semantic Versioning](https://semver.org/). eg: x.y.z
   * For major/breaking change release, increment x. Resulting branch will be x+1.0.0.
   * For minor changes, increment y. Resulting branch will be x.y+1.0.
   * For bugfixes/patch/trivial changes, increment z. Resulting branch will be x.y.z+1.

### Preparing stable branches for a minor release

For a **minor release**, make sure the backport of the PRs from the `main` branch to the release branch is successful.
For more information on backporting PRs, refer to [the backporting page](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/backport_changes.md) of the team handbook.

### Branching for a major release

Complete the following steps to branch for a **major release**:

1. Ensure a fresh `stable-X` branch is ready, where `X` represents the major version number.
  This branch is typically created during the code freeze.
  If a `stable-X` branch doesn’t already exist, create it from the `main` branch as follows:

   ```shell
   git fetch upstream # Where upstream is the remote name
   git checkout -b stable-X upstream/main # If a new branch is needed
   git push upstream stable-X
   ```

1. Create a separate PR for the `stable-X` branch and update any branch name references.
  For example, change documentation urls in the `README.md` file to point to `stable-X` instead of `main`.
  Changes needed for this step vary in each collection but commonly include files such as:

   * `README.md`
   * `docs/docsite/links.yml`

   The purpose of this step is to ensure that references to the `stable-X` branch, in locations such as urls, do not pollute release prep PRs which are synchronized back to the `main` branch after the release.

1. Verify if the ansible-core version in the `requires_ansible` key of `meta/runtime.yml` needs to be updated.
  The best way to do this is consult the team via Slack.
  External contributors can also create issues in the GitHub repository or ask on the community forum.
  If you confirm that the ansible-core version requires an update, create a separate PR for the change.
  Create a separate PR for the `main` branch and ensure it is backported to the `stable-X` branch before starting the release preparation PR.

   > Certified and validated collections that are published to Automation Hub must specify a supported version of ansible-core. Consult the [ansible-core compatibility](https://docs.ansible.com/projects/partner-certification-requirements/ansible-core-compatibility/) section of the certification requirements. **Double check that the version is supported with the PE team before you make any changes.**

1. Create a separate PR for the `main` branch and increment the development version in the `galaxy.yml` file, located in the root directory of the collection, with the appropriate value (e.g., `version: 10.0.0-dev0` would be changed to `version: 11.0.0-dev0`).

   For the [`amazon.aws`](https://github.com/ansible-collections/amazon.aws) and [`community.aws`](https://github.com/ansible-collections/community.aws) collections _only_, increment the version of `AMAZON_AWS_COLLECTION_VERSION` in [`plugins/module_utils/common.py`](https://github.com/ansible-collections/amazon.aws/blob/5100ca0d861fec6a9ef88d55c98c656fe345c149/plugins/module_utils/common.py#L7), for example:

   ```python
   COMMUNITY_AWS_COLLECTION_VERSION = "10.0.0-dev0"
   COMMUNITY_AWS_COLLECTION_VERSION = "11.0.0-dev0"
   ```

### Creating release preparation pull requests

Shortly before each release, the `stable-X` branch of the collection needs to be updated.
Ideally release prep PRs should be created **one day in advance of the release target date**.
This gives adequate review time to ensure that all required changes have been made.

To create a release prep PR, complete the following steps to update the collection version and generate changelogs.

#### Updating the collection version

1. Create a new PR for the `stable-X` branch.
  An ideal name for a release prep PR is something like `prep_release_x_y_z`, where `x_y_z` are the version numbers.
  For example, if you are preparing a major version release for 10.0.0, name your branch `prep_release_10_0_0`.

    ```shell
    git checkout -b prep_release_x_y_z stable-X
    ```

1. Update the `version` key in the `galaxy.yml` file with the appropriate value (`x.y.z`).

   For the [`amazon.aws`](https://github.com/ansible-collections/amazon.aws) and [`community.aws`](https://github.com/ansible-collections/community.aws) collections _only_, also update the version of `AMAZON_AWS_COLLECTION_VERSION` in `plugins/module_utils/common.py` to match the `version` key in `galaxy.yml`, for example:

   ```python
   COMMUNITY_AWS_COLLECTION_VERSION = "10.0.0"
   ```

   For the [`community.aws`](https://github.com/ansible-collections/community.aws) collection, update the `galaxy.yml` file to reflect the major release version for the `amazon.aws` dependency, for example:

   ```yaml
   dependencies:
     amazon.aws: '>=10.0.0-dev0' # Before
     amazon.aws: '>=10.0.0'      # After
   ```

#### Generating changelogs

1. Add a changelog fragment `changelogs/fragments/<version>.yml` for the release summary as follows:

   ```yml
   release_summary: < release content >
   ```

1. Install the latest version of [`antsibull-changelog`](https://ansible.readthedocs.io/projects/antsibull-changelog/).
1. Confirm there are fragments for all known changes in the `changelogs/fragments` folder.
1. Generate release changelogs:

   ```shell
   antsibull-changelog release
   ```

1. Open the `CHANGELOG.rst` file and verify that it includes all the changelog fragments.
1. Ensure that `CHANGELOG.rst` does not have any additional changes outside of your new release.
  Do not manually change the `CHANGELOG.rst` file.
  It is always generated by `antsibull-changelog`.
  If you need to make corrections or any changes, edit the `changelogs/changelog.yml` and then generate a new `CHANGELOG.rst` file:

   ```shell
   antsibull-changelog generate
   ```

#### Opening release prep PRs

After you update the collection version and generate changelogs with a release summary, create a pull request with `stable-X` as the base branch.
Ideally it is best to wait until the release date (or the day before it) to merge the release prep PR.

You should monitor CI and ensure that all checks pass before merging release prep PRs.
Linting, formatting, and sanity check failures **must** be fixed before a release prep PR is merged.

**NOTE:** Run sanity and integration tests locally to ensure all tests are passing.
Test failures and CI check issues **must** be addressed in a separate PR to the release prep PR and then backported.

Unit and integration test failures in a release prep PR should be evaluated.
It is generally acceptable to merge release prep PRs with test failures that stem from unrelated or transient issues, such as flakiness caused by network timeouts.
This is especially true in cases where handling the failures would delay the release.

However, this must always be agreed with the team.
It is always better if all tests pass cleanly before release prep PRs are merged.
This fully validates functionality of the new version.

## Releasing collections

### Git Tagging

1. Ensure the release prep PR is merged.
1. Fetch all changes from the upstream and update the local copy of the `stable-X` branch, for example:

   ```shell
   git fetch upstream
   git checkout stable-X
   git rebase upstream/stable-X
   ```

1. Tag the version and push to GitHub.

   ```shell
   git tag -m "Release <version>" <version>
   git push upstream <version>
   ```

   For example:

   ```shell
   git tag -m "Release 10.0.0" 10.0.0
   git push upstream 10.0.0
   ```

   For **hashicorp.vault**, after pushing the tag, follow the [HashiCorp Vault section](#hashicorp-vault-collection-hashicorpvault--where-it-differs) below to create a GitHub Release and run the release workflow.

1. Open a browser and navigate to the `/tags` page of the collection repository.
1. Select the tag that you pushed to GitHub.
   For `amazon.aws` and `community.aws` collections, it should open to the `/releases` page.
1. Check the release summary and list of changes is complete and accurate.
1. Expand the **Assets** section and download the source code `*.tar.gz` file.
1. Inspect the source code and verify that it matches the contents of the `stable-X` branch.

   **NOTE:** After you create the new tag in the repo, Zuul automatically builds the collections from the tagged source and uploads to Galaxy and Automation Hub.
   The `*.tar.gz` that you download from the **Assets** section is not a built collection.
   It does not contain a `MANIFEST.json` file and cannot be installed via `ansible-galaxy`.

See [Troubleshooting releases](#troubleshooting-releases) at the end of this page if you encounter issues with tags or releases.

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

* Create a PR in the collection to merge the changes made in the release prep PR to the `main` branch. This can be done manually or using the `cherry-pick` command as shown below:

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

The `hashicorp.vault` collection follows the same release process as other collections, with one additional step after tagging.

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
   * Check the latest version on Automation Hub as needed.

---

## Troubleshooting releases

This section has some troubleshooting information for GitHub releases.

### Manually creating releases

In the event that you create and push a tag, but a new release is not generated, you can do this manually.
This is only required if the collection uses releases, such as `amazon.aws` and `community.aws`.
Some collections, such as `ansible.mcp`, use tags only.

Follow the GitHub docs on [Creating a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release) from the tag.

You should ensure that the release includes the appropriate summary and list of changes from the generated `CHANGELOG.rst` file.

### Deleting tags

You should not delete tags after you push them to the upstream repository.
Deleting tags can result in conflicting hashes if a new tag of the same version is subsequently pushed, which causes temporary installation errors for users such as:

```shell
[ERROR]: Failed to download collection tar from 'default' due to the following unforeseen error: Mismatch artifact hash with downloaded file
```

You should delete a tag only in cases where there is an issue with the assets, such as a corrupted or incomplete `*.tar.gz` file.

## Reference

https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_release_with_branches.html#releasing-major-collection-versions

https://docs.ansible.com/ansible/latest/community/development_process.html
