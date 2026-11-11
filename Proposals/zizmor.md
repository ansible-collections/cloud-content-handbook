# Adopt zizmor auditing for collection CI

This proposal outlines adopting `zizmor` tooling to audit GitHub Actions workflows, pre-commit hooks, Dependabot config, and other CI artifacts.

## Purpose

Recent supply chain security efforts across collections have been highly beneficial but were reactive in nature as well as prone to human error.

For instance, addressing the `pull_request_target` trigger [blocked by `actions/checkout` v7](https://github.blog/changelog/2026-06-18-safer-pull_request_target-defaults-for-github-actions-checkout/) required intervention to get workflows running again.

Manual security updates to workflows can also be inconsistent across repositories.
For example, changes applied to one workflow might be missed in another workflow within the same repo, which creates security gaps.

Zizmor provides proactive, automated auditing to catch these issues, reducing the reactive security firefighting.

## zizmor

[zizmor](https://github.com/zizmorcore/zizmor) is a static analysis tool that performs security-focused audits to detect dangerous patterns, excessive permissions, script injection vulnerabilities, and other supply chain risks.

For Ansible collections, zizmor acts as an automated security checkpoint that runs alongside existing CI checks.
It provides actionable findings with severity levels, allowing teams to prioritize critical security fixes while deferring informational warnings.
The tool outputs both human-readable reports and machine-parseable formats (SARIF), enabling integration into CI pipelines and GitHub's **Security** tab.

## Adoption

There are some options for adding zizmor.
This proposal does not provide implementation details.
Rather, this proposal outlines some pros and cons for each option.

### Third-Party zizmor-action (Turnkey)

This option adds a workflow file such as `.github/workflows/zizmor.yml` to each collection repo.
For more info, see [zizmor integration docs](https://docs.zizmor.sh/integrations/#via-zizmorcorezizmor-action).

**Pros:**

- Zero maintenance burden - updates handled by zizmorcore team
- Simple rollout - copy workflow to each collection repository
- GitHub Security tab integration out-of-the-box
- Fast adoption - no custom tooling development

**Cons:**

- Third-party dependency on zizmorcore GitHub organization
- Cannot customize audit rules or severity levels
- Limited control over zizmor version updates
- Potential for breaking changes in Action updates
- Requires trusting external Action with repository access

### Custom shared action

This option creates a shared action in `ansible/cloud-content-ci-automation` that collections can use, such as:

```
# In ansible/cloud-content-ci-automation
.github/actions/zizmor-audit/
├── action.yml
└── README.md
```

**Pros:**

- Full control over zizmor version and update timing
- Can customize configuration, thresholds, and reporting
- Reduces risk of external supply chain compromise
- Centralized maintenance - update once, apply everywhere
- Can extend with team-specific checks or wrappers

**Cons:**

- Maintenance burden - team owns updates and bug fixes
- Must monitor zizmor releases and apply updates manually
- Runs in CI only (no local check for developers working on actions)

> Note that this proposal suggests creating a shared action in `ansible/cloud-content-ci-automation`.
> However this action could be beneficial to other collection teams, in which case it might be sensible for any shared action to reside somewhere else.

### Tox environment

This option adds a zizmor env to `tox.ini` in each collection.
Along with the tox config, a zizmor version should be added to the dependency groups in `pyproject.toml`.

```ini
[testenv:zizmor]
description = Run zizmor security audit on GitHub Actions workflows
skip_install = true
...
```

This option allows for more flexible usage:

```bash
# Local development
tox -e zizmor

# CI integration (add to existing linters workflow)
- name: Run zizmor audit
  run: tox -e zizmor
```

**Pros:**

- Integrates with existing tox-based development workflows
- Developers can run locally before pushing changes
- Follows the same pattern as other tooling like `ruff`

**Cons:**

- Does not automatically upload SARIF to GitHub Security tab
- Each collection must add tox environment separately (no shared configuration)
