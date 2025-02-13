# Release cycles for cloud content

We release major, minor, and patch versions of our content on a regular schedule to provide stability and set expectations for the community. The schedule for each type of release is described below. The processes for managing and creating releases are documented in [Release management](./release_management.md) and [Steps to release a collection](./release_collections.md), respectively.

## Collections

### Major releases

All of the cloud content collections have a major release **twice annually** to align with the [ansible-core release cycle](https://docs.ansible.com/ansible/latest/roadmap/ansible_core_roadmap_index.html), which typically publishes a new minor release in May and November. Why do we do this? Because our supported collections must require only [supported versions of ansible-core](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-core-support-matrix), indicated by an up-to-date `requires_ansible` version in their `meta/runtime.yml` file. This update is a breaking change and requires a new major version release shortly after a new version of ansible-core is released.

For collections that are also released in the ansible community package (which includes all of our supported collections except redhat.openshift), new major versions must be released shortly *before* a new version of ansible-core due to the tightly overlapping [freeze and release windows](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#release-cycle-overview) for the ansible-core and ansible community packages. In order to find a compromise that fulfills both of the competing requirements between certification and community inclusion, the following release steps should be taken for supported collection major releases:

1. Note the release cycle for the upcoming [ansible-core release](https://docs.ansible.com/ansible/latest/roadmap/ansible_core_roadmap_index.html) and the upcoming [ansible community release](https://docs.ansible.com/ansible/latest/roadmap/ansible_roadmap_index.html).
2. After the latest ansible-core release candidate (RC) has been released, check with the core team whether another RC is planned.
3. Once the last planned RC has been made, confirm with the PE team (#ansible-partners) that we can discontinue the support for the current ansible-core version mentioned in the README and meta/runtime.yml.
4. If the PE team agrees, increase the `requires_ansible` version by one version to match the oldest supported version [after the next ansible-core release](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-core-support-matrix) and update the README.
5. Prep and perform a release no more than two weeks before the next ansible-core release.

The intent with this schedule is to recognize that there will be a brief window where the latest version of the collection does not support the oldest supported version of ansible-core, but to ensure that this window is as short as reasonably possible.

Note that this procedure only needs to be followed for supported collections with new major versions that need to go out in the next ansible community package (again, includes all of our supported collections except redhat.openshift). For all other collections, new major releases can be made shortly after the latest ansible-core release.

### Minor and patch releases

New minor or patch versions of our collections are released **once a month, on the first Tuesday of the month**. Whether a given collection version needs a minor or patch release depends on what types of changes have been committed since the previous release. If a scheduled release date arrives and a given collection has had no updates since its last release, that cycle's release can be skipped for that collection.

Note that security fixes will likely require an immediate, out-of-cycle release. If unsure, ask in our team Slack channel.
