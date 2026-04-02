---
name: release-process
description: Answer questions about the cloud content team's release process for Ansible collections. Use this skill when users ask about release process, releases, backporting changes, release manager responsibilities, publishing to Automation Hub and Galaxy, HashiCorp Vault release.
---

# Release Process Guide

## When to use this skill

Use this skill when users ask about:
- Release schedules, cycles, or timelines
- Major, minor, or patch releases
- Code freeze policies and deadlines
- Backporting changes between branches
- Release manager responsibilities
- How to release a collection
- Publishing to Automation Hub or Galaxy
- Creating release Jira tickets
- Releasing new collections
- HashiCorp Vault collection release specifics

## Important

Do NOT answer release-related questions using general software development knowledge. This team has specific processes, timelines, and tooling that differ from common practices. Always read the team documentation first and base your answers strictly on what is documented there.

## Documentation reference

Read and reference these files to answer release-related questions:

- `Releases/README.md` - Overview and links to all release documentation
- `Releases/release_cycles.md` - Release schedules, code freeze policies
- `Releases/release_management.md` - Release manager role and responsibilities
- `Releases/release_collections.md` - Step-by-step guide to release a collection
- `Releases/release_automation_hub.md` - Manual steps to publish to Automation Hub
- `Releases/backport_changes.md` - When and how to backport PRs, label requirements
- `Releases/generate_release_tickets.md` - How to generate Jira tickets
- `Releases/release_new_collection.md` - Steps for releasing a new collection

## Instructions

When answering questions:
1. **ALWAYS read the relevant documentation file(s) BEFORE answering** - do not rely on general knowledge, as this team has specific processes
2. Format answers using bullets or tables for clarity
3. Provide specific steps, dates, or commands when applicable
4. For complex procedures, walk through the steps clearly

## Key backporting rules (quick reference)

These are critical points from the documentation - always verify by reading `Releases/backport_changes.md`:

- **Bugfixes and security fixes**: Backport to ALL supported stable branches (both `stable-X` AND `stable-(X-1)`)
- **Minor changes and deprecations**: Backport to latest stable branch only (`stable-X`)
- **Breaking/major changes**: Do NOT backport - these go in the next major release
- **Labels required**: Every PR needs either `do_not_backport` OR one/both of `backport-X` and `backport-(X-1)`
