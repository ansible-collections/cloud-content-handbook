# Steps to release a collection to Automation hub and Galaxy

1. Determine the collection version based on [Semantic Versioning](https://semver.org/). eg: x.y.z
- For major/breaking change release, increment x.
- For bugfix/minor changes, increment y.
- For patch/trivial changes, increment z.
2. Incase of a major release , create a new branch `stable-X`, where `X` denotes the major version number.

```
git branch stable-X
```
3. For a minor release, selectively backport bug fixes from the main branch to the `stable-X` branch, where X is the major version number, based on the severity of the bug. Avoid backporting new features. Ensure that pull requests intended for backporting are labeled with tags such as `backport-X`, where X refers to the target `stable-X` branch.
4. Check out the `stable-X` branch and prepare the collection for release by following the instructions provided [here](https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_releasing.html#preparing-to-release-a-collection).

```
git checkout stable-X
```
5. Update the CHANGELOG:
   i.   Add a changelog fragment `changelogs/fragments/<version>.yml` for the release summary as follows
   ```
   release_summary: < release content >
   ```
   ii.  Ensure you have `antsibull-changelog` is installed.
   iii. Confirm there are fragments for all known changes in changelogs/fragments.
   iv. Run antsibull-changelog release.
   ```
   antsibull-changelog release --version <version>
   ```
6. Verify `CHANGELOG.rst` for the presence of all the changelog fragments.
7. Commit the changes and push the changes to the upstream repository. Ensure the CI passes.
8. Tag the version in Git and push to GitHub.
```
git tag -m "Release <version>" <version>
git push upstream <version>
```
9. Once the [CI for the release](https://ansible.softwarefactory-project.io/zuul/status) passes, notify #ansible-partners about the release, for approval for the release on Automation Hub. To manually upload the collection to Automation Hub refer [here](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Release/release_automation_hub.md).
10. Check for the latest version of the collection on Galaxy and Automation Hub.
11. To include an announcment of the release in Bullhorn, add a message in the [Ansible-Social Matric Channel]( https://chat.ansible.im/#/room/#social:ansible.com).
12. Create a PR in the collection to merge the changes made in the release PR to the the main branch. Once the CI passes and the PR is approved, merge it to the main branch.

# Reference:
https://docs.ansible.com/ansible/latest/community/collection_contributors/collection_release_with_branches.html#releasing-major-collection-versions

