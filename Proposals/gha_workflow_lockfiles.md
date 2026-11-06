# Adopt GitHub Action workflow lockfiles

This proposal outlines adopting GitHub Actions workflow lockfiles to replace SHA pinning for actions across cloud content collections.

## Purpose

Cloud content collections currently pin GitHub Actions to commit SHAs for security.
This requires contributors to manually inspect releases on GitHub, locate the commit SHA for a specific version tag, and copy it into workflow files.
This manual process is error-prone and lacks native tooling support.

The current SHA pinning approach has two main issues:

* Error-prone manual process

Contributors must navigate to action repositories, find releases, and manually copy commit SHAs.
This workflow is tedious and susceptible to human error.
We have observed cases where AI-assisted pinning generated hallucinated SHAs that broke workflow execution.
When workflows fail to run, CI checks silently disappear from pull requests, allowing changes to merge without validation.

* No native tooling

GitHub provides no built-in command to resolve a version tag to its commit SHA.
Contributors resort to browser inspection, `git ls-remote`, or custom scripts.

### GHA workflow lockfiles

GitHub Actions [workflow lockfiles](https://github.blog/changelog/2026-10-28-github-actions-workflow-lockfiles-are-generally-available/) address these issues while maintaining the security benefits of commit-level pinning.
Lockfiles provide automated SHA resolution via `gh workflow lock`, eliminating manual lookup and preventing invalid references.
The native tooling integration includes cryptographic integrity verification, human-readable semantic versions, and automated Dependabot updates.

## Current approach: SHA pinning

```yaml
- uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
```

**Security:** Prevents tag manipulation  
**Maintainability:** Manual SHA resolution, inline comments for version tracking  
**Tooling:** Requires Dependabot workarounds, no native lockfile support

## Proposed approach: Workflow lockfiles

```yaml
# .github/workflows/test.yml
- uses: actions/checkout@v7.0.1
```

```yaml
# .github/workflows/test.yml.lock
actions/checkout@v7.0.1:
  resolved: 3d3c42e5aac5ba805825da76410c181273ba90b1
  integrity: sha256:a12b3c4d5e6f...
```

**Security:** Same commit-level pinning via lockfile resolution, plus cryptographic integrity checks  
**Maintainability:** Human-readable workflow files, automated lockfile updates via `gh workflow lock`  
**Tooling:** Native Dependabot support for lockfile-tracked actions

## Benefits over SHA pinning

### Security improvements

- **Integrity verification:** Lockfiles include `sha256` checksums that GitHub validates on every workflow run, detecting tampering
- **Audit trail:** Lockfile diffs show both semantic version and resolved SHA changes in a single commit
- **Tamper detection:** Any mismatch between declared version, resolved SHA, and integrity hash fails the workflow

### Maintainer benefits

- **Readable workflows:** Semantic versions (`@v7.0.1`) instead of opaque SHAs in workflow files
- **Automated updates:** `gh workflow lock --update` regenerates lockfiles with new resolutions
- **Native Dependabot:** No custom configuration needed; Dependabot tracks lockfile entries like `package-lock.json`
- **Rollback safety:** Lockfile history provides explicit version-to-SHA mappings for quick rollback

## Tooling

#### Dependabot configuration

- Dependabot automatically tracks `*.yml.lock` files without additional config
- PRs show semantic version bumps with lockfile resolution changes

#### CI/CD workflows

- No changes required to workflow execution
- GitHub automatically resolves lockfile references at runtime
- Failed integrity checks halt workflow before action execution

## Considerations

### Lockfile structure

GitHub generates one `.yml.lock` file per workflow file (e.g., `test.yml` → `test.yml.lock`).
There is no repo-wide lockfile option.
Collections with many workflows will have multiple lockfiles to maintain, though Dependabot handles updates across all lockfiles automatically.

### Lockfile sync validation

Lockfiles can become out of sync if workflow files are updated without regenerating lockfiles.

We should validate and fail CI if lockfiles don't match workflow file references:

```yaml
- name: Validate workflow lockfiles
  run: gh workflow lock --check
```

## Phased adoption

This proposal suggests a phased approach to adoption starting with `amazon.aws`.

1. Enable lockfiles in `amazon.aws` repository settings.
1. Generate initial lockfiles: `gh workflow lock --all`.
1. Remove SHA comments from workflow files (keep semantic versions).
1. Simplify Dependabot config to remove SHA-pinning workarounds.
1. Update `CONTRIBUTING.md` with lockfile update instructions.

Success criteria:

- All workflows use lockfile resolution
- Dependabot creates PRs with lockfile updates
- Team confirms improved workflow readability
- No security regressions

After evaluation in `amazon.aws` we can roll out to other collections.
