# Validated Content

## What is it?

We maintain several validated content collections which all live under the [Red Hat CoP org](https://github.com/redhat-cop).  For more information on what validated content is, and how it fits into Ansible's overall content strategy, see: https://www.redhat.com/en/blog/automate-expert-ansible-validated-content.

For GitHub related support such as creating a new repo or granting permissions on existing repos, file an issue or create a PR in the https://github.com/redhat-cop/org repo.

## Guidelines for Creating

Keep in mind while writing validated content that this is intended to be used as an example of how to write good Ansible. Consider periodically reviewing the [Automation Good Practices](https://github.com/redhat-cop/automation-good-practices) to make sure you are familiar and up to date with the recommended best practices. In addition, all our validated content repos should follow these practices:

* All roles and playbooks must be linted using Ansible Lint's `production` profile.
* All roles and playbooks must pass sanity tests.
* All roles and playbooks should have associated integration tests.
* All roles should define an [argument spec](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#role-argument-validation).
* All roles and playbooks must be clearly documented.

## Breaking Changes

Validated content follows semantic versioning. While we should endeavor to minimize the impact of breaking changes, validated content does not need to follow the same deprecation and removal timeline that we use for our supported collections. If a breaking change needs to be made, make the change and note it as a breaking change in the changelog.

## Releasing

Validated content is not released to Ansible Galaxy.
