# How to deal with pull requests running workflow triggered by a pull_request_target ?

## Why the pull_request_target Github trigger ?

[Extracted from Github documentation](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request_target)

> This event runs in the context of the base of the pull request, rather than in the context of the merge commit, as the pull_request event does. **This prevents execution of unsafe code from the head of the pull request** that could alter your repository or steal any secrets you use in your workflow. This event allows your workflow to do things like label or comment on pull requests from forks.
> For workflows that are triggered by the pull_request_target event, the GITHUB_TOKEN is granted read/write repository permission unless the permissions key is specified and **the workflow can access secrets, even when it is triggered from a fork**.
> There exists a potentially dangerous misuse of the pull_request_target workflow trigger that may lead to malicious PR authors (i.e. attackers) being able to obtain repository write permissions or stealing repository secrets.

## Preventing security issues

Assuming we have the following `integration.yml` workflow:

```yaml
name: Integration

on:
    pull_request_target:

jobs:
    run:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout code from pull request head branch
        uses: actions/checkout@v3
        with:
            ref: ${{ github.event.pull_request.head.sha }}

        - (...)
```

This is insecure as the `Integration.run` job will be executed without any validation that the user is not a malicious PR author. To prevent that, we add the job `safe-to-test`, the workflow now looks like this:

```yaml
name: Integration

on:
  pull_request_target:
    types: [labeled, opened, reopened, synchronize]

jobs:
  safe-to-test:
    if: ${{ github.event.label.name == 'safe to test' }} || ${{ github.event.action != 'labeled' }}
    uses: ansible-network/github_actions/.github/workflows/safe-to-test.yml@main
  run:
    needs:
      - safe-to-test
    runs-on: ubuntu-latest
    if: ${{ contains(github.event.pull_request.labels.*.name, 'safe to test') }}
    steps:
      - name: Checkout code from pull request head branch
        uses: actions/checkout@v3
        with:
          ref: ${{ github.event.pull_request.head.sha }}

      - (...)
```

The `safe-to-test` job works as follow:

- if the PR author is a [collaborator](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository), the workflow adds the label `safe-to-test` to the pull request.
- if the PR author is not a collaborator, the label `safe-to-test` will be removed when the pull request is updated or reopened.
