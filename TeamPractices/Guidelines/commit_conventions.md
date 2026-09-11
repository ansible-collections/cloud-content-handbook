# Commit conventions

Team Nebula is encouraged to use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification for commit messages.
Conventional commits provide a lightweight structure that makes the type and scope of a change immediately clear from the commit message.

A conventional commit message has the following format:

```shell
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Descriptions should use the imperative voice: "fix bug" not "fixed bug" or "fixes bug".
This aligns with git's own internal commit messages (e.g. `Merge branch...`, `Revert "..."`), resulting in consistency across the entire history.

## Why conventional commits

Standard commit messages carry more meaning than unstructured ones.
A prefix like `fix:`, `feat:`, or `docs:` tells the reader what kind of change was made without opening the diff.
This makes it easier for team members and contributors to scan project history, understand the purpose of changes during code reviews, and work across projects.

### Conventional commits promote atomicity

The requirement to choose a single type for each commit encourages developers to keep commits small and focused on one logical change.
Atomic commits simplify code review, make reverts safer, and produce a history that is easier to bisect when tracking down regressions.

### Conventional commits offer consistency

A shared convention that applies to Red Hat engineers and community contributors alike reduces friction during code review because maintainers do not need to interpret unfamiliar commit styles or request reformatting from contributors who are new to the project.

## Using conventional commits

While conventional commits are recommended and encouraged, they should **not** be enforced in collection repos via CI gates for existing repositories.
Adding CI gates to enforce conventional commits would be problematic for existing pull requests and potentially discourage contributors.

Where possible, contributors should be encouraged to use conventional commits.
This is especially true in cases where commit messages might not be clear and need to be written anyway.

In repositories that use squash merge via Zuul, such as `amazon.aws`, the PR title becomes the commit message.
Before merging multiple commits in these repos, consider rewriting the PR title to use an appropriate conventional commit message.

See the forum discussion, [Conventional Commits in Collections](https://forum.ansible.com/t/conventional-commits-in-collections/46190), for more details.

## References to Jira tickets

Jira ticket references are acceptable in two places, in commit titles as scope or in the body.
The commit body is the preferred location because Jira tickets typically carry downstream context that is not accessible to external contributors.
Using a project-relevant scope in the title, such as a module or component name, makes the commit message meaningful to all contributors regardless of whether they have access to Jira.

For example, using a Jira ticket as the scope:

```shell
fix(AAP-12345): correct timeout for long-running jobs
```

A project-relevant scope is more informative:

```shell
fix(tasks): correct timeout for long-running jobs

AAP-12345
```

References to Jira tickets in commit messages must include the ticket number only (e.g. `AAP-12345`) and **NEVER** the full URL.

## Additional resources

Check out these other resources for good practices with commits:

* [Git commit message best practices](https://gist.github.com/webknjaz/cb7d7bf62c3dda4b1342d639d0e78d79)
* [The subtle art of making atomic commits](https://gist.github.com/webknjaz/a7362787a80067af8621a85a71746ca1)
* [Git fundamentals](https://gist.github.com/webknjaz/a5a4fb374b7579de827e6bedb93a5220)
* [Easier crediting of contributors](https://hynek.me/til/easier-crediting-contributors-github/)