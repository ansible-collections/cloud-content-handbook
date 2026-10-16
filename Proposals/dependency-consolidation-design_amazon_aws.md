# Dependency consolidation design for `amazon.aws`

This proposal outlines a design for consolidating dependencies in the `amazon.aws` collection as part of the unified collection testing effort.

## Purpose

The `amazon.aws` collection currently has dependencies scattered across eight files with manual synchronization.
This adds maintenance burden, risks inconsistent development and test environments, and does not align with modern Python packaging tooling like `tox-ansible`.

The current layout for dependencies in `amazon.aws` have the following issues:

* SDK versions (`botocore`/`boto3`/`aiobotocore`) appear in multiple files.
  The root `requirements.txt` header warns contributors to "update both constraints files" when changing versions, but this manual process is error-prone and not CI-validated.

* The current layout does not follow `tox-ansible` [architecture expectations](https://docs.ansible.com/projects/tox-ansible/architecture/) for dependency discovery.
  Test dependencies are split across multiple constraint files without clear `.in` sources.
  There's no standard `pip-compile` workflow for lockfile generation.

* No `meta/ee-requirements.txt` or `meta/execution-environment.yml` files exist to declare [collection dependencies](https://docs.ansible.com/projects/builder/en/latest/collection_metadata/) for `ansible-builder`.

* Runtime, dev tooling, and test framework dependencies are not clearly separated, making it unclear which packages are actually needed at runtime versus development/testing only.

This design proposal consolidates dependencies into clear separation.
Runtime dependencies reside in `meta/` while test dependencies are scoped to `tests/`.
As a result collection dependencies have single sources of truth, CI validation, EE support, and alignment with modern Python packaging patterns.

## Current dependency layout

```shell
.
├── bindep.txt # System package requirements
├── requirements.txt # Python runtime requirements
├── test-requirements.txt # Common test framework dependencies
├── tests
│   ├── integration
│   │   ├── constraints.txt # Pinned versions for SDK deps
│   │   ├── requirements.txt # Integration test deps
│   │   └── requirements.yml # Collection deps for integration tests
│   └── unit
│       ├── constraints.txt # Pinned versions for SDK deps
│       └── requirements.txt # Unit test deps
```

## Proposed dependency layout

```shell
.
├── meta
│   ├── ee-bindep.txt # System package requirements
│   ├── ee-requirements.txt # Python runtime requirements
│   └── execution-environment.yml # EE collection level dependencies
├── requirements.txt # Convenience file for local development
├── tests
│   ├── constraints.in # Base constraints for test deps
│   ├── test-requirements.in # Common test framework deps
│   ├── integration
│   │   ├── requirements.in # Integration test deps
│   │   ├── requirements.txt # Compiled lockfile for integration test deps (latest versions)
│   │   └── requirements.yml # Collection deps for integration tests (consolidated)
│   └── unit
│       ├── requirements.in # Unit test deps
│       ├── requirements.txt # Compiled lockfile for unit test deps (latest versions)
│       └── requirements.yml # Collection deps for unit tests (unchanged)
```

## Design decisions

The design of the proposed dependency layout address the following criteria:

### Single source of truth

**Runtime:** `meta/ee-requirements.txt` with `>=` minimums  
**Test framework:** `tests/test-requirements.in` references runtime deps  
**Test-specific:** `tests/unit/requirements.in` and `tests/integration/requirements.in`  
**Collections:** `tests/integration/requirements.yml`

### EE/ansible-builder ready

- `meta/execution-environment.yml` points to `meta/ee-requirements.txt` and `meta/ee-bindep.txt`
- `galaxy.yml` `build_ignore` does not include `meta/`
- Runtime deps use `>=` (not `==`) for cross-collection compatibility

### Runtime vs dev vs test separation

**Runtime:** Only in `meta/ee-requirements.txt` (`botocore`, `boto3`, `aiobotocore`)  
**Dev tools:** Not committed to lockfile; devs run `tox -e compile-requirements` locally  
**Test framework:** In `tests/*/requirements.{in,txt}`, loaded by tox

### Oldest and newest SDK paths both survive

Unit tests run against two SDK paths:

- Pinned against minimum versions (`==`)
- Compiled against latest versions

For example, unit test dependencies are installed as follows:

```shell
# Install minimum versions
python3 -m pip install -c tests/constraints.in -r meta/ee-requirements.txt -r tests/unit/requirements.in

# Install latest versions
python3 -m pip install -r meta/ee-requirements.txt -r tests/unit/requirements.txt
```

Integration tests run in GHA via `.github/workflows/integration.yml` and use minimum versions only.

For example, integration test dependencies are installed as follows:

```shell
# Install minimum versions
python3 -m pip install -c tests/constraints.in -r meta/ee-requirements.txt -r tests/integration/requirements.in
```

> `tests/integration/requirements.txt` is not installed but compiled for parity with unit test dependencies.
> This file shows the full dependency tree for reference and allows CI checks to keep deps in sync.
> If developers need to install latest integration test dependencies, this provides a known good lockfile.

### Constraints stay in sync

This proposal sets us up to keep `meta/ee-requirements.txt` minimums in sync with `tests/constraints.in` pins.

`tests/constraints.in` provides a single source of truth to pin SDK floor versions:

```ini
botocore==1.38.23
boto3==1.38.23
aiobotocore==2.23.0
awscli==1.40.22
```

Additional logic is required to ensure that changes to `meta/ee-requirements.txt` are kept in sync with the following files:

- `tests/constraints.in`
- `plugins/module_utils/botocore.py`
- `tests/unit/plugins/module_utils/modules/ansible_aws_module/test_minimal_versions.py`

While this proposal does not outline the implementation details, preference should be given to a shared action in the `cloud-content-ci-automation` repository for re-use in other collections.

For compiled `requirements.txt` files for unit test dependencies, use `tox -e check-requirements` as a CI gate:

- Runs `uv pip compile` without `--upgrade`
- Uses `git diff --exit-code` to detect changes
- Fails if lockfiles are out of sync with `.in` sources

### tox-ansible can find test deps

Test deps are in standard locations:

- `tests/unit/requirements.in`
- `tests/integration/requirements.in`  
- `tests/integration/requirements.yml`

`tox.ini` also explicitly references test deps.

### Contributors can easily find runtime deps

`requirements.txt` at the project root contains `-r meta/ee-requirements.txt`.
This provides a convenient way for contributors to find runtime dependencies in an expected location.
Additionally developers can use `requirements.txt` to add or adjust dependencies during local development.

`requirements.txt` must be added to the build ignore list in `galaxy.yml` to avoid ansible-builder introspection issues.
This creates additional separation between development and runtime environments.

### Consolidating integration test dependencies

`.github/workflows/integration.yml` currently specifies an inconsistent set of collection dependencies to `tests/integration/requirements.yml`.

`tests/integration/requirements.yml` should become the single source of truth for collection dependencies.

The current `integration.yml` workflow relies on `ansible-community/ansible-test-gh-action` which does not currently support collection dependencies from `requirements.yml` files.
See [the PR to add requirements.yml as a supported input](https://github.com/ansible-community/ansible-test-gh-action/pull/132)

Any alternative approach should avoid additional YAML parsing and install `requirements.yml` into the environment via the `ansible-galaxy` CLI.

