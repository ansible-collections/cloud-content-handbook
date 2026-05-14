# Guide: Setting Up Vault for Integration Tests

This guide walks through **end-to-end setup**: signing in to HashiCorp Cloud Platform, creating a dedicated namespace, enabling secrets engines and AppRole, defining ACL policies, issuing AppRole credentials, wiring **GitHub Actions** and **Bitwarden**, verifying access, and **running integration tests**. Use it for a **greenfield** cluster or namespace (for example a new HCP Vault Dedicated environment, or when your team is setting up integration tests for the [hashicorp.vault](https://github.com/ansible-collections/hashicorp.vault) collection for the first time) or when **replacing** credentials and aligning Vault, CI, and team storage.

For **adding** a single new secrets engine or policy after the baseline exists, use [Guide: Enabling a New Secret Engine for Integration Tests](updating_integration_test_role.md).

Do **not** treat the policies under [acl-policies/](acl-policies/) as a production template; they are **broad** by design for automated tests inside an isolated namespace.


## When to use this guide

- You are **creating** the `hashicorp-vault-integration-tests` namespace (or equivalent) and standard mounts from nothing.
- You are **onboarding** a repository that runs Vault integration tests in GitHub Actions.
- You are **rotating** `role_id` / `secret_id` and must keep Vault, GitHub Actions, and team Bitwarden in sync.


## Prerequisites

- **HashiCorp Cloud Platform (HCP) Vault** or **Vault Enterprise** (namespaces require Enterprise).
- **Admin** access to create the child namespace under your organization’s admin namespace (for example `admin/` on HCP). If you’re new to the team or don’t have Vault access, work with your PM or team lead to request access through your organization’s provisioning process.
- **Vault CLI** [installed](https://developer.hashicorp.com/vault/install).
- Permission to **create and manage** GitHub Actions **secrets** for the repository that runs the tests.
- Access to the **team Bitwarden vault** used for operational backups of CI secrets.
- Agreement on **namespace path** and **mount paths** (this document uses the conventions in the table below).


## Conventions used in this guide

| Item | Value |
|------|--------|
| Namespace (HCP example) | `admin/hashicorp-vault-integration-tests` |
| KV v1 mount (default) | `kv1` |
| KV v1 mount (integration tests; `kv1_secret`, `lookup_kv1_secret_get`) | `kv1-integration-tests` |
| KV v2 mount (default) | `kv2` |
| KV v2 mount (integration tests; `kv2_secret`, `lookup_kv2_secret_get`) | `kv-integration-tests` |
| Database secrets engine (default) | `database` |
| Database secrets engine (integration tests; `database_connection` / `vault_database_mount_path`) | `database-conn-config-integration-tests` |
| PKI secrets engine | `pki` |
| AppRole auth mount | `approle-integration-tests` |
| AppRole **role** name | `integration-tests` |

Adjust `VAULT_ADDR` and the namespace string to match your environment. Placeholders below use angle brackets; do not commit real tokens or secrets.


## Policy HCL in this repository

Canonical ACL policy definitions live as **HCL** under **[acl-policies/](acl-policies/)** (one file per Vault policy name, filename matches the policy). **Step 5** applies these files; edit the `.hcl` sources there rather than duplicating rules in this guide. For an introduction to HCL policy syntax and concepts, see [HashiCorp's Vault policy tutorial](https://developer.hashicorp.com/vault/tutorials/get-started/introduction-policies).

**Note:** The [ansible-collections/hashicorp.vault](https://github.com/ansible-collections/hashicorp.vault) `acl_policy` / `acl_policy_info` modules call the **legacy** HTTP API `GET /v1/sys/policy` (and `/v1/sys/policy/:name`), not only `/sys/policies/acl`. [acl-policies/acl-policy-crud.hcl](acl-policies/acl-policy-crud.hcl) therefore includes both **`sys/policy`** and **`sys/policies/acl`** paths.

From `ContentManagement/hashicorp.vault`:

```bash
vault policy write <policy-name> acl-policies/<policy-name>.hcl
```


## Step 1: Sign in to HCP, then create the namespace (admin access required)

### HashiCorp Cloud Platform

When using **HCP Vault**:

1. Sign in to [HashiCorp Cloud Platform](https://portal.cloud.hashicorp.com/).
2. In the portal, open **Vault** and select your **Vault Dedicated** cluster (the Vault cluster used for integration tests). From there you can confirm the cluster URL (for `VAULT_ADDR`), use the Vault UI, and perform admin tasks such as creating namespaces.

### Create the namespace

From an **admin** session (UI or CLI), create a dedicated namespace for integration tests, for example **`hashicorp-vault-integration-tests`**, under your parent namespace (on HCP, often under `admin`). For detailed instructions on creating namespaces, see HashiCorp's [namespace tutorial](https://developer.hashicorp.com/vault/tutorials/enterprise/namespaces#create-namespaces).

After creating your new namespace, all following CLI steps assume you target that namespace.


## Step 2: Environment variables

Unset any stale token, then set address and namespace. Example for HCP:

```bash
unset VAULT_TOKEN

export VAULT_ADDR="https://cloud-content-public-vault-<cluster-id>.z1.hashicorp.cloud:8200"
export VAULT_NAMESPACE="admin/hashicorp-vault-integration-tests"
```

Sign in with an **admin** method appropriate to your org. For Red Hat Ansible teams using HCP Vault, this typically means **OIDC via `vault login -method=oidc`** (with your Red Hat SSO credentials), though initial root tokens or other bootstrap methods may be used in some environments. After successful login, `VAULT_TOKEN` is set for the next steps. Example after login:

```bash
export VAULT_TOKEN=<admin-token>
```

**Note:** The examples in later sections assume a valid token with permission to enable engines, create policies, and configure AppRole in this namespace.


## Step 3: Enable secrets engines

Enable KV v1, KV v2, database, and PKI at the **default** paths, and the **integration-test** mounts used by modules such as `kv1_secret`, `lookup_kv1_secret_get`, `kv2_secret`, `lookup_kv2_secret_get`, and `database_connection` (see [conventions table](#conventions-used-in-this-guide)):

```bash
# Default mounts
vault secrets enable -path=kv1 -version=1 kv
vault secrets enable -path=kv2 kv
vault secrets enable database
vault secrets enable pki

# Integration-test mounts (same engine types; used by collection integration tests)
vault secrets enable -path=kv1-integration-tests -version=1 kv   # KV v1
vault secrets enable -path=kv-integration-tests kv               # KV v2
vault secrets enable -path=database-conn-config-integration-tests database
```

Expected success messages reference mounts `kv1/`, `kv2/`, `database/`, `pki/`, `kv1-integration-tests/` (KV v1), `kv-integration-tests/` (KV v2), and `database-conn-config-integration-tests/` (database).

**Requires an admin (or provisioner) token** in this namespace: enabling mounts uses `sys/mounts/...`; the integration-test AppRole policies do not grant that. If you see `403 permission denied` on `vault secrets enable`, authenticate with an identity that can create mounts in `VAULT_NAMESPACE`.


## Step 4: Enable AppRole authentication

```bash
vault auth enable -path=approle-integration-tests approle
```

This exposes AppRole at `auth/approle-integration-tests/`.


## Step 5: Create ACL policies

Policies are defined in **[acl-policies/](acl-policies/)**. Create them in the Vault UI (**Access → Policies**) by pasting from those files, or apply them with the CLI from `ContentManagement/hashicorp.vault` (adjust the path if your checkout differs).

| Vault policy name | Source |
|-------------------|--------|
| `integration-tests-policy` | [acl-policies/integration-tests-policy.hcl](acl-policies/integration-tests-policy.hcl) |
| `kv1-kv2-secrets-crud` | [acl-policies/kv1-kv2-secrets-crud.hcl](acl-policies/kv1-kv2-secrets-crud.hcl) |
| `acl-policy-crud` | [acl-policies/acl-policy-crud.hcl](acl-policies/acl-policy-crud.hcl) |
| `namespaces-crud` | [acl-policies/namespaces-crud.hcl](acl-policies/namespaces-crud.hcl) |
| `database-conn-config-and-roles-crud` | [acl-policies/database-conn-config-and-roles-crud.hcl](acl-policies/database-conn-config-and-roles-crud.hcl) |
| `pki-crud` | [acl-policies/pki-crud.hcl](acl-policies/pki-crud.hcl) |
| `token-and-auth-crud` | [acl-policies/token-and-auth-crud.hcl](acl-policies/token-and-auth-crud.hcl) (broad; narrow if your tests allow) |

Apply all policies in one pass:

```bash
vault policy write integration-tests-policy acl-policies/integration-tests-policy.hcl
vault policy write kv1-kv2-secrets-crud acl-policies/kv1-kv2-secrets-crud.hcl
vault policy write acl-policy-crud acl-policies/acl-policy-crud.hcl
vault policy write namespaces-crud acl-policies/namespaces-crud.hcl
vault policy write database-conn-config-and-roles-crud acl-policies/database-conn-config-and-roles-crud.hcl
vault policy write pki-crud acl-policies/pki-crud.hcl
vault policy write token-and-auth-crud acl-policies/token-and-auth-crud.hcl
```

For `namespaces-crud`, edit reserved paths in the HCL if your tests use different namespace names than `admin` and `hashicorp-vault-integration-tests`.


## Step 6: Create the AppRole and attach policies

Create the role with the policies you created (single policy first, then update to the full set as in the example below).

Initial write with one policy:

```bash
vault write auth/approle-integration-tests/role/integration-tests \
  token_policies="integration-tests-policy" \
  token_ttl=1h \
  token_max_ttl=2h
```

Attach **all** policies in one `token_policies` value (comma-separated, no spaces). Vault **replaces** the entire list on each write.

```bash
vault write auth/approle-integration-tests/role/integration-tests \
  token_policies="integration-tests-policy,acl-policy-crud,database-conn-config-and-roles-crud,kv1-kv2-secrets-crud,namespaces-crud,pki-crud,token-and-auth-crud"
```

Verify:

```bash
vault read -field=token_policies \
  auth/approle-integration-tests/role/integration-tests
```

Optional full read:

```bash
vault read auth/approle-integration-tests/role/integration-tests
```


## Step 7: Obtain `role_id` and `secret_id`

```bash
vault read -field=role_id auth/approle-integration-tests/role/integration-tests/role-id

vault write -f -field=secret_id auth/approle-integration-tests/role/integration-tests/secret-id
```

You will use these values in the next steps. Do not commit real values into this repository.


## Step 8: Configure GitHub Actions secrets

Add **repository** (or environment) **secrets** in GitHub so workflows can reach Vault and authenticate:

| Typical secret purpose | Examples (names may vary by repo) |
|------------------------|-----------------------------------|
| Vault API address | `VAULT_ADDR` or team-equivalent |
| AppRole credentials | `role_id`, `secret_id` (or names your workflow expects) |
| Namespace | Namespace name or path the client must use |

Match **exact secret names** to what your integration-test workflow reads. If in doubt, inspect the workflow YAML in the repository that runs the tests.


## Step 9: Back up the same values in team Bitwarden

Store the **same** Vault address, namespace, `role_id`, and `secret_id` (and related notes: AppRole mount path `approle-integration-tests`, role name `integration-tests`) in the **team Bitwarden vault** so credentials are recoverable if GitHub secrets are lost or need to be re-entered.

Treat these items as **sensitive**; use Bitwarden’s access controls your team already uses for infrastructure secrets.


## Step 10: Verify AppRole login (CLI)

Unset the admin token if you want to confirm test-only access:

```bash
unset VAULT_TOKEN
export VAULT_ADDR="https://cloud-content-public-vault-<cluster-id>.z1.hashicorp.cloud:8200"
export VAULT_NAMESPACE="admin/hashicorp-vault-integration-tests"
```

Login:

```bash
vault write auth/approle-integration-tests/login \
  role_id="<ROLE_ID>" \
  secret_id="<SECRET_ID>"
```

Capture the returned token:

```bash
export VAULT_TOKEN=<token-from-response>
```

Confirm policies on the token:

```bash
vault token lookup
```

You should see policies including `integration-tests-policy`, `acl-policy-crud`, `database-conn-config-and-roles-crud`, `kv1-kv2-secrets-crud`, `namespaces-crud`, `pki-crud`, `token-and-auth-crud`, and Vault’s **`default`** policy.


## Step 11: Run integration tests

1. Confirm **GitHub Actions secrets** from Step 8 are present on the branch or environment the workflow uses.
2. Trigger the integration-test workflow for the **[hashicorp.vault](https://github.com/ansible-collections/hashicorp.vault)** collection the way the repository defines it (for example **Actions** → select the workflow → **Run workflow**, or open a pull request that runs it).
3. Confirm the job completes successfully and Vault-backed tests pass. If a job fails on authentication, re-check `VAULT_ADDR`, `VAULT_NAMESPACE`, `role_id`, and `secret_id` against the workflow’s expected secret names and namespace path.

For **local** runs of hashicorp.vault integration tests, export the same variables (and token from AppRole login) as your test harness expects. See the collection’s [README - Running tests locally](https://github.com/ansible-collections/hashicorp.vault/blob/main/README.md#running-tests-locally) for detailed instructions and additional references.


## Ongoing changes (new engines or policies)

When you **add** a new secrets engine or policy after initial setup, create the policy and **rewrite** `token_policies` on the AppRole with **every** policy name still required in a single `vault write`—Vault replaces the list. Step-by-step instructions are in [Guide: Enabling a New Secret Engine for Integration Tests](updating_integration_test_role.md).


## Quick reference checklist

| Step | Action |
|------|--------|
| 1 | Sign in to [HCP](https://portal.cloud.hashicorp.com/), open **Vault Dedicated**, create namespace `hashicorp-vault-integration-tests` (under `admin` on HCP if applicable). |
| 2 | Set `VAULT_ADDR`, `VAULT_NAMESPACE`, authenticate as admin. |
| 3 | Enable `kv1`, `kv2`, `database`, `pki`, plus `kv1-integration-tests`, `kv-integration-tests`, `database-conn-config-integration-tests`. |
| 4 | Enable `approle-integration-tests` AppRole. |
| 5 | Write ACL policies from [acl-policies/](acl-policies/) (`vault policy write …` as in Step 5). |
| 6 | Create role `integration-tests`, attach all policies in one `token_policies` write. |
| 7 | Read `role_id`, generate `secret_id`. |
| 8 | Add **GitHub Actions** secrets (`VAULT_ADDR`, namespace, AppRole credentials). |
| 9 | Mirror values in **team Bitwarden**. |
| 10 | Verify AppRole login and `vault token lookup`. |
| 11 | Run integration tests in CI (or locally with matching env). |


## Summary

End-to-end setup means: an isolated **namespace**; default and integration-test **KV**, **database**, and **PKI** mounts (see conventions table); **ACL policies** from **`acl-policies/*.hcl`** attached to **AppRole** **`approle-integration-tests`** / role **`integration-tests`**; **`role_id`** and **`secret_id`** in **GitHub Actions** and **Bitwarden**; CLI verification; then **running** the repo’s integration test workflow. Further policy or engine changes use [Guide: Enabling a New Secret Engine for Integration Tests](updating_integration_test_role.md).
