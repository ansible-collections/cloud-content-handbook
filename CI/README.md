# Continuous Integration

## What is it?

[Continuous integration (or CI for short)](https://en.wikipedia.org/wiki/Continuous_integration) helps us ensure that code committed to our repositories meets our standards. By running automated checks on pull requests into our repos, we can easily verify that certain requirements are met. This allows code reviewers to focus primarily on the functionality of code changes rather than things like syntax or running tests.

## How does it work?

We primarily use Github Actions to run CI checks on our repositories, with a few exceptions[^1]. Our Github Actions workflows are defined in workflow files within each repository, and these workflows are designed to run whenever a pull request is made to the repository and also when a commit is pushed to a pull request branch (in other words, when an existing pull request is updated). Some workflows are run when a pull request is merged to the `main` or `stable-*` branch of a repository or when a release is tagged, see details below.

## What checks are run?

The following checks are run on all repositories for all new and updated pull requests. Each check is represented by a single workflow file within the `.github/workflows` directory in the repository:

- `ansible-lint.yaml`
  - lints Ansible playbooks and roles using [ansible-lint](https://ansible.readthedocs.io/projects/lint/) to ensure they follow accepted syntax and style practices
- `changelog.yaml`
  - ensures that there is a [changelog fragment](https://docs.ansible.com/ansible/latest/community/development_process.html#creating-changelog-fragments) for the pull request, which is generally required for all pull requests into our repositories
- `galaxy-import.yaml`
  - builds the collection and validates that it can be successfully imported to [Ansible Galaxy](https://galaxy.ansible.com/) using [galaxy-importer](https://github.com/ansible/galaxy-importer)
- `integration-tests.yaml`
  - runs functional [integration tests](https://docs.ansible.com/ansible/latest/dev_guide/testing_integration.html#testing-integration) to verify that collection modules and plugins perform as expected against the relevant cloud service provider APIs
  - because this workflow requires authentication to the cloud service providers, it has special security requirements that must be followed (detailed documentation forthcoming)
  - this workflow is run against the entire matrix of supported Ansible and python versions
- `python-lint.yaml`
  - lints python modules with [flake8](https://flake8.pycqa.org/en/latest/) and [black](https://black.readthedocs.io/en/stable/) to ensure the code complies with standard python style and formatting conventions
- `sanity-tests.yaml`
  - runs [sanity tests](https://docs.ansible.com/ansible/latest/dev_guide/testing_sanity.html#testing-sanity) (static code analysis) on Ansible collections to ensure they meet Ansible coding standards and requirements
  - this workflow is run against the entire matrix of supported Ansible and python versions, although the `milestone` and `devel` Ansible version jobs may be marked as non-voting, meaning they can fail and the workflow run is still considered successful
- `unit-tests.yaml`
  - runs python [unit tests](https://docs.ansible.com/ansible/latest/dev_guide/testing_units.html#testing-units) targeting individual module or plugin functions
  - this workflow is run against the entire matrix of supported Ansible and python versions

These additional CI and automation workflows run only on the AWS repositories (amazon.aws, amazon.cloud, community.aws):

- `update-aws-variables.yaml`
  - runs on new pull requests and push to the `main` or `stable-*` branches
  - ensures that the AWS user agent variable matches the collection name and version in the galaxy.yml file
  - ensures that the boto3 and botocore test version variables match the versions in the test contraints.txt files
- `validate-docs.yaml`
  - runs on new or updated pull requests
  - validates that the documentation can be successfully built and meets all requirements
  - if the validation identified any changes to the documentation compared to the pull request base branch, creates a comment on the pull request with a list of the changed files and a diff comparison
- `publish-docs.yaml`
  - runs when a pull request is merged to the `main` or `stable-*` branches, when a new tag is pushed, and once daily
  - builds the documentation and creates a build artifact in preparation for publication
  - if the documentation changed compared to the pull request base branch, creates a comment on the pull request noting that the documentation will be updated when it is next published

Additional automations using Github Actions:

- `label-new-issues.yaml`
  - runs when an issue is opened or re-opened in a repository
  - adds a `needs_triage` label to the issue
  - should run on all of our supported and validated content repositories
- `generate-release.yaml`
  - runs when a new tag is pushed and can also be run manually in the UI
  - generates a release log, creates and publishes a Github release
- `release-collection`
  - runs when a new release is published
  - publishes the collection to Ansible Galaxy - should run on all of our repositories except validated content repositories
  - publishes the collection to Automation Hub - should run on all of our supported and validated content repositories

[^1]: The [community.okd collection](https://github.com/ansible-collections/community.okd) uses a different CI system, Prow. Different CI workflows are run for the [terraform-provider-ansible repository](https://github.com/ansible/terraform-provider-ansible) because it is a Terraform provider, not an Ansible collection.
