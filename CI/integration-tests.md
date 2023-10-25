# Integration Tests in CI

Integration test workflows in Github Actions have security risks not present in our other workflows because they must authenticate to the cloud providers they are testing against, which requires privileged permissions in the Github repository. The two biggest security risks that need to be mitigated are:

- preventing forks from gaining unauthorized access to our cloud provider accounts
- preventing forks from making unauthorized changes to the repo

## Workflow file structure

To mitigate these risks, integration tests must always be comprised of two separate workflow files as follows. There are also certain [repository settings](#required-repository-settings) that must be in place for all collection repos using these integration test workflows.

### integration-test-prep.yaml

This workflow runs on the `pull_request` event, which always runs in the context of the fork and does not have access to secrets. The workflow is comprised of a single job that writes the pull request base ref to a file and uploads that file as a workflow artifact, which can be accessed by the later workflow. This is the only way to pass data between workflows in Github Actions, and will allow the later workflow to know which branch the pull request was made against.

### integration-tests.yaml

This workflow runs on the `workflow_run` event when the 'Integration test prep' workflow is completed. This is run in the context of the base repository but is given no permissions by default, other than the required `metadata: read` permission. The workflow has a number of jobs:

1. update-status-pending: updates the PR's head commit status to "pending" with the `run-integration-tests` context. This is necessary because the integration-tests workflow does not show up in the PR's checks tab as it is not triggered by the PR directly. The `run-integration-tests` check, if required by branch protection on the base branch, will show up on the main conversation tab of the PR as "required". Marking it as pending indicates in that view that the check has started and provides a link to see details. *This job requires the `statuses: write` permission*.

2. get-base-ref: downloads the artifact from the integration-test-prep workflow, reads it, and returns the value as a job output.

3. splitter: checks out the pull request head commit and the base ref head, runs a diff and determines whether any code has changed relevant to the integration tests (true if either the modules or the integration tests themselves have changed). If so, splits all identified test targets to run into a specified number of jobs that we can run in parallel and returns the job matrix as a job output.

4. authenticate: authenticates to the cloud provider via OIDC and writes the retrieved short-lived credentials to AWS secrets manager. Writing the credentials to secrets manager is the [recommended strategy for passing secrets between jobs in Github Actions](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#example-masking-and-passing-a-secret-between-jobs-or-workflows), and we keep this job separate from later jobs because *this job requires the `id-token: write` permission*.

5. run-integration-tests: runs the actual integration tests! If the splitter job output was not empty (meaning it did identify changes relevant to integration tests), this job does the following:
   - checks out the PR head commit, installs dependencies, builds and installs the collection
   - retrieves the short-lived cloud provider credentials from AWS secrets manager and writes them to the file used by ansible-test
   - runs the integration tests using the splitter output as a matrix so that multiple test jobs can be run in parallel

6. report-status: finally, this job updates the PR head commit status based on the results of the run-integration-tests workflow. The status is reported as successful if the entire run-integration-tests job result is either "success" or "skipped", because that job is skipped only if there are no code changes in the PR relevant to integration testing (for example, only documentation updates). The status is reported as failed if any job in the run-integration-tests matrix fails, if the workflow is cancelled, or if there is an error during the workflow run. The pull request's main conversation tab will show this check's final status with a link to the workflow run logs for details. *This job requires the `statuses: write` permission*.

## Required settings

- Main branch protections must require the run-integration-tests check to pass
- OIDC must be configured for Github and the relevant repo(s) in the cloud provider account
- Repository actions secrets must include:
  - The role to assume for OIDC
  - Credentials for an AWS user that only has access to read/write secrets manager secrets with a specific prefix
