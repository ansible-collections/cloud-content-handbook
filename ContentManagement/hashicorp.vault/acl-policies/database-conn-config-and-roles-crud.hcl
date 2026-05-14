# Policy name in Vault: database-conn-config-and-roles-crud
# Database secrets engine: default mount `database` and integration-tests mount
# `database-conn-config-integration-tests` (database_connection / vault_database_mount_path).

# -----------------------------------------------------------------------------
# Enable mounts
# -----------------------------------------------------------------------------

path "sys/mounts/database" {
  capabilities = ["create", "update"]
}

path "sys/mounts/database-conn-config-integration-tests" {
  capabilities = ["create", "update"]
}

path "sys/mounts" {
  capabilities = ["read"]
}

# -----------------------------------------------------------------------------
# UI navigation
# -----------------------------------------------------------------------------

path "database/*" {
  capabilities = ["read", "list"]
}

path "database-conn-config-integration-tests/*" {
  capabilities = ["read", "list"]
}

# -----------------------------------------------------------------------------
# Connection config
# -----------------------------------------------------------------------------

path "database/config/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "database/config" {
  capabilities = ["list"]
}

path "database-conn-config-integration-tests/config/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "database-conn-config-integration-tests/config" {
  capabilities = ["list"]
}

# -----------------------------------------------------------------------------
# Reset connections
# -----------------------------------------------------------------------------

path "database/reset/*" {
  capabilities = ["update"]
}

path "database-conn-config-integration-tests/reset/*" {
  capabilities = ["update"]
}

# -----------------------------------------------------------------------------
# Dynamic roles
# -----------------------------------------------------------------------------

path "database/roles/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "database/roles" {
  capabilities = ["list"]
}

path "database-conn-config-integration-tests/roles/*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "database-conn-config-integration-tests/roles" {
  capabilities = ["list"]
}

# -----------------------------------------------------------------------------
# Static roles
# -----------------------------------------------------------------------------

path "database/static-roles/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "database-conn-config-integration-tests/static-roles/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# -----------------------------------------------------------------------------
# Credentials and root rotation
# -----------------------------------------------------------------------------

path "database/creds/*" {
  capabilities = ["read"]
}

path "database-conn-config-integration-tests/creds/*" {
  capabilities = ["read"]
}

path "database/rotate-root/*" {
  capabilities = ["update"]
}

path "database-conn-config-integration-tests/rotate-root/*" {
  capabilities = ["update"]
}
