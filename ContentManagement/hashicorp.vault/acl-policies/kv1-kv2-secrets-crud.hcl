# Policy name in Vault: kv1-kv2-secrets-crud
# KV v1 and KV v2: default mounts plus integration-test mounts.

# -----------------------------------------------------------------------------
# KV v1 (mount kv1)
# -----------------------------------------------------------------------------

path "kv1/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# KV v1 (mount kv1-integration-tests) - kv1_secret, lookup_kv1_secret_get

path "kv1-integration-tests/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# -----------------------------------------------------------------------------
# KV v2 (mount kv2)
# -----------------------------------------------------------------------------

path "kv2/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv2/metadata/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# KV v2 (mount kv-integration-tests) - kv2_secret, lookup_kv2_secret_get

path "kv-integration-tests/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv-integration-tests/metadata/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
