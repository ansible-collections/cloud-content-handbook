# Steps to release a collection to Automation hub and Galaxy

**1.** Determine the collection version based on [Semantic Versioning](https://semver.org/). eg: x.y.z
- For major/breaking change release, increment x. Resulting branch will be x+1.0.0.
- For minor changes, increment y. Resulting branch will be x.y+1.0.
- For bugfixes/patch/trivial changes, increment z. Resulting branch will be x.y.z+1.

**2.** In case of a major release, create a new branch `stable-X`, where `X` denotes the major version number. The new branch is based on the main branch.

```
git checkout main
git branch stable-X main
```

**3.** For a minor release, make sure the backport of the PRs from the main branch to the release branch is successful. For backporting of PRs refer [the document](https://github.com/ansible-collections/cloud-content-handbook/blob/main/backport_changes.md).

**4.** Create and check out a new branch and prepare the collection for release by following the instructions provided [here](https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_releasing.html#preparing-to-release-a-collection).

```
git checkout -b prep_release_x stable-X
```

**5.** Update the CHANGELOG:
  **i.** Add a changelog fragment `changelogs/fragments/<version>.yml` for the release summary as follows
   ```
   release_summary: < release content >
   ```
   **ii.** Ensure you have `antsibull-changelog` is installed.
   **iii.** Confirm there are fragments for all known changes in changelogs/fragments.
   **iv.** Run antsibull-changelog release.
   ```
   antsibull-changelog release --version <version>
   ```

**6.** Verify `CHANGELOG.rst` for the presence of all the changelog fragments.

**7.** Commit the changes and push the changes to the upstream repository. Make sure you choose `stable-X` as your base branch. This will be the preparation PR for the release. Ensure the CI passes. Once the `prep` PR is merged, update the local copy of `stable-X` branch with the latest changes from the `prep` PR.

**8.** Tag the version in Git and push to GitHub.

```
git tag -m "Release <version>" <version>
git push upstream <version>
```

**9.** Once the [CI for the release](https://ansible.softwarefactory-project.io/zuul/status) passes, notify #ansible-partners about the release, for approval for the release on Automation Hub. To manually upload the collection to Automation Hub refer [here](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Release/release_automation_hub.md).

**10.** Check for the latest version of the collection on Galaxy and Automation Hub.

**11.** To include an announcement of the release in Bullhorn, tag the newsbot and add a message in the [Ansible-Social Matrix Channel]( https://chat.ansible.im/#/room/#social:ansible.com).

```
Sample message:
@newsbot
: amazon.aws 7.0.0 has been released with new bugfixes, features, plugins, and modules. Refer the <changelog> for details!
```

**12.** Create a PR in the collection to merge the changes made in the release PR to the the main branch. This can be done manually or using the `cherry-pick` command as given below.
```
_This example assumes that the released version is 3.0.0_
git checkout main
git pull
git checkout -b cherry-pick/stable-3/release_sync
git cherry-pick -x <commitSHA_from_Stable-3>
```
Push the branch to your fork. Once the CI passes and the PR is approved, merge it to the main branch.

# Reference:
https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_release_with_branches.html#releasing-major-collection-versions
