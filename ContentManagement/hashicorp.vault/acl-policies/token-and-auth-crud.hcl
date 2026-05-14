# Policy name in Vault: token-and-auth-crud
# Token self-service, token create, and auth method configuration. Highly sensitive.

path "auth/token/lookup-self" {
  capabilities = ["read", "update"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

# Only if tests must mint tokens
path "auth/token/create" {
  capabilities = ["create", "update"]
}

path "sys/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
