# Guide: Enabling a New Secret Engine for Integration Tests

This guide explains how to give integration tests permission to enable and use a new Vault secrets engine by creating a policy and attaching it to the AppRole used by the tests.

For **initial** namespace, engines, AppRole, and baseline policies, use [Guide: Setting Up Vault for Integration Tests](set_up_integration_tests.md). Baseline ACL policies live under **[acl-policies/](acl-policies/)** in this repository.


## When to use this guide

Use this guide when:

- Integration tests need to **enable** a new secrets engine (e.g. database, KV, PKI).
- Integration tests need to **configure or manage** a new mount (create/read/update/delete config, roles, etc.).
- You are adding or changing what the integration-test AppRole is allowed to do in Vault.


## Background

Integration tests authenticate to Vault using **AppRole** (`role_id` and `secret_id`). The permissions they get come from the **policies attached to that AppRole**. To allow tests to use a new secrets engine, you must:

1. Create a **Vault ACL policy** that grants the needed paths/capabilities.
2. **Attach that policy** to the integration-test AppRole (e.g. `integration-tests`).
3. **Re-authenticate** so tests receive a new token with the updated policies.


## Prerequisites

- **Admin access** to the Vault instance used for integration tests (to create policies and update the AppRole).
- **Vault CLI** installed and configured (e.g. `VAULT_ADDR`, `VAULT_TOKEN` or login method) for the attach and verify steps.
- Knowledge of the **mount path** and **paths/capabilities** the new secrets engine requires (from Vault docs or existing config).


## Step 1: Create a Vault policy

1. Log in to Vault **as an admin** (UI or CLI with `VAULT_TOKEN` / namespace set).
2. Add a new **HCL** file under **[acl-policies/](acl-policies/)** in this repository (or create the policy in the Vault UI: **Access → Policies → Create ACL Policy**).
3. Define the policy with the paths and capabilities your new secrets engine needs.
4. Save the policy with a **descriptive name** (e.g. `my-engine-crud`). Apply with `vault policy write <name> acl-policies/<name>.hcl` from `ContentManagement/hashicorp.vault` if you use the repo layout from [Guide: Setting Up Vault for Integration Tests](set_up_integration_tests.md).

### Example: Database secrets engine

For a database secrets engine mounted at `database-conn-config-integration-tests`, a policy might look like:

```hcl
# Allow enabling the secrets engine
path "sys/mounts/database-conn-config-integration-tests" {
  capabilities = ["create", "update"]
}

# Allow clients/UI to read mount information
path "sys/mounts" {
  capabilities = ["read"]
}

# Manage DB connections
path "database-conn-config-integration-tests/config/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "database-conn-config-integration-tests/config" {
  capabilities = ["list"]
}

# Reset DB connections
path "database-conn-config-integration-tests/reset/*" {
  capabilities = ["update"]
}

# Manage DB roles
path "database-conn-config-integration-tests/roles/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "database-conn-config-integration-tests/roles" {
  capabilities = ["list"]
}
```

Save the policy with a name such as: `db-conn-config-crud`.

For **other secrets engines**, follow the same pattern: use the correct mount path and the paths/capabilities required by that engine (see [Vault documentation](https://developer.hashicorp.com/vault/docs) for the specific engine).


## Step 2: Attach the policy to the AppRole (Vault CLI)

Integration tests use the AppRole named **`integration-tests`** (auth path: `auth/approle-integration-tests/role/integration-tests`). Attach the new policy to this role so tokens issued via `role_id` and `secret_id` get the new permissions.

Run (replace `my-engine-crud` with your **new** policy name; **keep every existing policy name** from the role today):

```bash
vault write auth/approle-integration-tests/role/integration-tests \
  token_policies="integration-tests-policy,acl-policy-crud,database-conn-config-and-roles-crud,kv1-kv2-secrets-crud,namespaces-crud,pki-crud,token-and-auth-crud,my-engine-crud"
```

If your deployment already differs from the baseline, read the current list first: `vault read -field=token_policies auth/approle-integration-tests/role/integration-tests`, then add only the new policy name to that list in the `vault write` above.

**Important:**

- **Always include all existing policies** in `token_policies`. Vault **replaces** the entire list; omitting existing policies will remove them from the role.


## Step 3: Re-authenticate with the AppRole

Existing tokens do **not** get new permissions automatically. After attaching the policy, integration tests (or your local session) must log in again to receive a new token.

Example:

```bash
vault write auth/approle-integration-tests/login \
  role_id="<ROLE_ID>" \
  secret_id="<SECRET_ID>"
```

The new token will include the updated policies.


## Step 4: Verify

**Check policies on the AppRole:**

```bash
vault read -field=token_policies \
  auth/approle-integration-tests/role/integration-tests
```

The output should list all intended policies, including the new one.

**Check policies on the current token:**

```bash
vault token lookup
```

Confirm the token’s policies match what you expect.


## Quick reference checklist

| Step | Action |
|------|--------|
| 1 | Create ACL policy (UI or `acl-policies/<name>.hcl` + `vault policy write`) with paths/capabilities for the new secrets engine. |
| 2 | Attach policy to AppRole: `vault write auth/approle-integration-tests/role/integration-tests token_policies="existing,...,new-policy"` (include **all** policies). |
| 3 | Re-authenticate: `vault write auth/approle-integration-tests/login role_id="..." secret_id="..."`. |
| 4 | Verify: `vault read -field=token_policies auth/approle-integration-tests/role/integration-tests` and/or `vault token lookup`. |


## Summary

When integration tests need a new Vault secrets engine:

1. **Create** a Vault ACL policy (UI or `acl-policies/<name>.hcl` + `vault policy write`).
2. **Attach** the policy to the integration-test AppRole (`integration-tests`) via the Vault CLI, including **all** existing policies in `token_policies`.
3. **Re-authenticate** with the AppRole so the new token has the updated permissions.

This keeps integration-test access explicit and limited to what the tests need.
