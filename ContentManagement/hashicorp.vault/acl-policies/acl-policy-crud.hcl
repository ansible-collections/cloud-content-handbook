# Legacy API: GET /v1/sys/policy (list names), GET/POST/DELETE /v1/sys/policy/:name
path "sys/policy" {
  capabilities = ["read"]
}

path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Newer API: LIST /v1/sys/policies/acl and paths under sys/policies/acl/*
path "sys/policies/acl" {
  capabilities = ["list"]
}

path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
