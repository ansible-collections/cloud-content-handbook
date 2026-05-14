# Policy name in Vault: namespaces-crud
# Child namespaces; deny admin; explicit rules for hashicorp-vault-integration-tests.
#
# Path globs: a trailing * matches one segment only. Creating e.g. ns1 under
# hashicorp-vault-integration-tests/ is sys/namespaces/hashicorp-vault-integration-tests/ns1
# (two segments after sys/namespaces/), so sys/namespaces/* alone does not cover it.
# PATCH /sys/namespaces/:path (custom_metadata) requires the "patch" capability, not only "update".

path "sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list", "patch"]
}

path "sys/namespaces/hashicorp-vault-integration-tests/*" {
  capabilities = ["create", "read", "update", "delete", "list", "patch"]
}

path "sys/namespaces/admin" {
  capabilities = ["deny"]
}

path "sys/namespaces/hashicorp-vault-integration-tests" {
  capabilities = ["create", "read", "list", "update", "patch"]
}
