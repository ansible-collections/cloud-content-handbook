# HashiCorp Vault (integration tests)

Operational notes for the **[ansible-collections/hashicorp.vault](https://github.com/ansible-collections/hashicorp.vault)** integration-test environment: namespaces, mounts, AppRole, and ACL policies used in CI.

| Document | Use when |
|----------|----------|
| [set_up_integration_tests.md](set_up_integration_tests.md) | Greenfield setup, onboarding a repo, or rotating credentials (Vault, GitHub Actions, Bitwarden). |
| [updating_integration_test_role.md](updating_integration_test_role.md) | Adding a new secrets engine or policy after the baseline exists. |

ACL policy sources live under **[acl-policies/](acl-policies/)** (one `.hcl` file per Vault policy name). They are **broad on purpose** for automated tests in an isolated namespace—do not treat them as a production template.
