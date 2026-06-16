# AI-Assisted Collection Releases

This guide covers using Claude Code skills to automate and streamline the collection release process. These skills handle backport status checks, version analysis, changelog generation, and release preparation with minimal manual intervention.

**Note:** For the manual release process without AI assistance, see [release_collections.md](./release_collections.md).

## Prerequisites

- [Claude Code](https://claude.ai/code) CLI installed and configured
- `gh` CLI authenticated with GitHub
- `git` configured with appropriate remotes
- Collection cloned locally with `upstream` remote pointing to the canonical repository

## Quick Start

For a complete release workflow, run these skills in sequence:

```bash
# 1. Check if there are any backport blockers
/collection-backport-status-check

# 2. Run the full release workflow (analyzes, prepares, validates)
/stable-release
```

## Skills Overview

| Skill | Purpose |
| ----- | ------- |
| `/collection-backport-status-check` | Check for open backport PRs and patchback failures that block releases |
| `/stable-release` | End-to-end release orchestration (analyze → prep → validate → PR) |
| `/stable-release-analyze` | Analyze stable branches to determine if releases are needed |
| `/stable-release-prep` | Create prep branch, update version, generate changelog |

## Step-by-Step Workflow

### Step 1: Check Backport Status

Before starting any release, verify that all backport PRs are merged and patchback failures are resolved.

```bash
/collection-backport-status-check
```

**What it checks:**

- Open backport PRs targeting stable branches
- Patchback failures on merged main-branch PRs since the last tag
- PRs with backport labels that still need to be merged

**Example output:**

```
## Backport Status: stable-11

### Ready for prep PR?
READY

### Context
- Last tag: 11.0.0 (created 2026-05-15, ~4 weeks ago)
- Open backport PRs targeting this branch: 0
- Backport-labeled PRs needing manual cherry-pick: 0

### Next steps
- Proceed with release prep PR creation
- Use `stable-release-analyze` if you need version calculation
```

**If NOT READY:**

The skill will list blockers and provide commands to resolve them:

```bash
# Manually cherry-pick patchback failures
git fetch upstream
git checkout -b fix-backport upstream/stable-11
git cherry-pick -x <sha>  # use -m 1 for merge commits
```

### Step 2: Run the Full Release Workflow

Once backports are clear, run the orchestrated release:

```bash
/stable-release
```

**What it does:**

1. **Analyzes** stable branches to determine version needed (MAJOR/MINOR/PATCH)
2. **Creates** prep branch (`prep_vX.Y.Z`)
3. **Updates** `galaxy.yml` with new version
4. **Generates** release summary changelog fragment
5. **Runs** `antsibull-changelog release` to produce `CHANGELOG.rst`
6. **Validates** with linting and sanity checks
7. **Creates** pull request (if `--create-pr` flag used)

**Common options:**

```bash
# Analyze only (no changes)
/stable-release --analyze-only

# Prepare specific version
/stable-release --version 10.1.0 --branch stable-10

# Skip quality checks for faster iteration
/stable-release --skip-lint --skip-sanity

# Full automation with PR creation
/stable-release --auto --create-pr

# Dry run to preview what would happen
/stable-release --dry-run
```

### Step 3: Review and Merge

After the skill creates the prep PR:

1. Review the generated `CHANGELOG.rst` for accuracy
2. Verify `galaxy.yml` version is correct
3. Ensure CI passes
4. Get required approvals and merge to `stable-X` branch

### Step 4: Tag and Release

After the prep PR is merged, follow the standard tagging process:

```bash
git checkout stable-X
git pull upstream stable-X
git tag -m "Release <version>" <version>
git push upstream <version>
```

## Individual Skill Usage

### collection-backport-status-check

Check backport readiness for specific or multiple branches:

```bash
# Check specific branch
/collection-backport-status-check stable-11

# Check default (two most recent stable branches)
/collection-backport-status-check
```

**Inputs:**

| Input | Required | Description |
| ----- | -------- | ----------- |
| `collection_git_url` | Yes | Clone URL or path to local clone |
| `target_stable_branch` | No | Specific branch (e.g., `stable-11`). Defaults to checking two most recent. |

### stable-release-analyze

Analyze pending releases without making changes:

```bash
/stable-release-analyze
```

**Output shows:**

- Current version from `galaxy.yml`
- Commits since last tag
- Changelog fragments and their SemVer impact
- Recommended next version

**Example:**

```
Collection: amazon.aws
Current version: 10.0.0

Checking stable-10...
✅ stable-10: 10.0.0 → 10.0.1 (PATCH)
   Commits: 14, Fragments: 3
   - 20260610-ec2-bugfix.yml: bugfixes (impact: PATCH)
   - 20260612-s3-fix.yml: bugfixes (impact: PATCH)
   - 20260615-rds-fix.yml: bugfixes (impact: PATCH)

Summary: 1 release(s) needed
```

### stable-release-prep

Prepare release branch with specific version:

```bash
/stable-release-prep --version 10.0.1 --branch stable-10
```

**Options:**

| Flag | Description |
| ---- | ----------- |
| `--version` | Target release version (required) |
| `--branch` | Stable branch to release from (required) |
| `--summary` | Custom release summary text |
| `--release-date` | Custom date in YYYY-MM-DD format (default: today) |

**Example with custom release date:**

```bash
# Prepare today but schedule for specific future date
/stable-release-prep --version 10.0.1 --branch stable-10 --release-date 2026-07-01
```

## Workflow Integration

The recommended sequence for releases:

```
┌─────────────────────────────────────┐
│  1. /collection-backport-status-check │
│     Check for workflow blockers       │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│  2. /stable-release --analyze-only   │
│     Determine version needed          │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│  3. /stable-release                   │
│     Full prep (or --create-pr)        │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│  4. Review & Merge prep PR            │
│     (Manual step)                     │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│  5. Tag & Push                        │
│     git tag / git push upstream       │
└─────────────────────────────────────┘
```

## Troubleshooting

### "No stable branches found"

Verify the collection uses `stable-X` branch naming:

```bash
git branch -a | grep stable
```

### "Remote 'upstream' not found"

Add the upstream remote:

```bash
git remote add upstream https://github.com/ansible-collections/<collection>.git
git fetch upstream --tags
```

### "gh CLI not authenticated"

Authenticate with GitHub:

```bash
gh auth login
```

### Patchback failures need manual resolution

When patchback fails, manually cherry-pick:

```bash
git fetch upstream
git checkout -b fix-backport upstream/stable-X
git cherry-pick -x <commit-sha>  # use -m 1 for merge commits
git push origin fix-backport
# Create PR targeting stable-X
```

### antsibull-changelog fails

Verify changelog configuration exists:

```bash
cat changelogs/config.yaml
```

Validate fragment YAML syntax:

```bash
yamllint changelogs/fragments/*.yml
```

## Configuration

Optional configuration in `~/.ansible-release.conf`:

```bash
export GITHUB_USERNAME="your-username"
export ANSIBLE_COLLECTIONS_PATH="~/dev/collections/ansible_collections"
export SANITY_MODE="smart"
export AUTO_CREATE_PR="prompt"  # true | false | prompt
export LINT_ON_COMMIT="true"
export SANITY_ON_COMMIT="true"
```

## Comparison: Manual vs AI-Assisted

| Step | Manual Process | AI-Assisted |
| ---- | -------------- | ----------- |
| Check backports | Review open PRs manually | `/collection-backport-status-check` |
| Determine version | Analyze changelog fragments | `/stable-release --analyze-only` |
| Create prep branch | `git checkout -b prep_vX.Y.Z` | Automated by `/stable-release` |
| Update galaxy.yml | Manual edit | Automated |
| Create release summary | Manual write | Auto-generated from fragments |
| Run antsibull-changelog | Manual command | Automated with validation |
| Run quality checks | `tox -e lint`, `ansible-test sanity` | Integrated in workflow |
| Create PR | `gh pr create` | `--create-pr` flag |

## References

- [Manual Release Process](./release_collections.md) - Step-by-step manual release instructions
- [Backporting Changes](./backport_changes.md) - Backport policy and patchback bot usage
- [Release Cycles](./release_cycles.md) - When major/minor/patch releases occur
- [Release Management](./release_management.md) - Team release tracking and responsibilities
