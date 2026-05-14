# Policy name in Vault: pki-crud
# PKI secrets engine (mount pki).

path "pki/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
