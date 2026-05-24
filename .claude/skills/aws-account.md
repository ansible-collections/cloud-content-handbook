---
name: aws-account
description: Answer questions about the Cloud Content team's AWS account usage, user creation, credentials management, resource tagging, and security practices. Use this skill when users ask about AWS access, creating AWS users, credential handling, or tagging policies.
---

# AWS Account Guide

## When to use this skill

Use this skill when users ask about:
- Creating new AWS users
- AWS account access and permissions
- Credential management and security
- AWS resource tagging policies
- Sharing AWS credentials securely
- Pre-commit hooks for credential protection
- Reporting credential exposures
- AWS groups and permissions (all_privs, CloudContentTeam)
- OIDC authentication for CI

## Important

Do NOT answer AWS account questions using general knowledge. This team has specific AWS practices, permissions, and security requirements that differ from common practices. Always read the team documentation first and base your answers strictly on what is documented there.

## Documentation reference

Read and reference these files to answer AWS account questions:

- `TeamPractices/Guidelines/aws_account_creation.md` - How to create new users, permissions, credential sharing
- `TeamPractices/Guidelines/aws_resource_tagging_policy.md` - Links to tagging policy documentation
- `CI/integration_tests.md` - OIDC setup and AWS Secrets Manager usage in CI

## Instructions

When answering questions:
1. Read the relevant documentation file(s) for the most accurate and up-to-date information
2. Format answers using bullets or tables for clarity
3. Emphasize security best practices for credential handling
4. Remind users about pre-commit hook requirements
5. Reference external links (Ansible Engineering Handbook, InfoSec) as appropriate
