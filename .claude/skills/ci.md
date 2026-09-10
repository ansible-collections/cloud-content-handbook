---
name: ci
description: Answer questions about CI (Continuous Integration) for Ansible collections. Use this skill when users ask about CI workflows, linters, integration tests, unit tests, sanity tests, GitHub Actions, or automated checks run on pull requests.
---

# CI Guide

## When to use this skill

Use this skill when users ask about:
- CI workflows and what checks run on PRs
- GitHub Actions workflow files
- Linters (ansible-lint, black, flake8, isort, mypy, flynt)
- Integration tests and how they work
- Unit tests or sanity tests
- Changelog requirements
- Galaxy import validation
- Documentation validation
- Type hinting requirements
- Why a CI check failed
- How to skip certain CI checks
- Security requirements for integration tests
- OIDC authentication in CI

## Important

Do NOT answer CI-related questions using general software development knowledge. This team has specific workflows, linters, and tooling that differ from common practices. Always read the team documentation first and base your answers strictly on what is documented there.

## Documentation reference

Read and reference these files to answer CI-related questions:

- `CI/README.md` - Overview of CI, what checks run, and all GitHub Actions workflows
- `CI/linters.md` - Details on linters used (ansible-lint, black, flake8, isort, mypy, flynt) and type hinting guidance
- `CI/integration_tests.md` - Integration test security, workflow structure, OIDC setup, and required settings

## Instructions

When answering questions:
1. Read the relevant documentation file(s) for the most accurate and up-to-date information
2. Format answers using bullets or tables for clarity
3. For CI failures, help identify which workflow failed and suggest fixes
4. Reference the documentation files so users can read more details
5. Explain security considerations when discussing integration tests
