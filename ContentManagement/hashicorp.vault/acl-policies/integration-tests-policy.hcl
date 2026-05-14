# Policy name in Vault: integration-tests-policy
# Optional baseline (e.g. health checks). Extend with team-specific rules as needed.

path "sys/health" {
  capabilities = ["read", "sudo"]
}
