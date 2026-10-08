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
│   │   ├── requirements.txt # Compiled lockfile for integration test deps
│   │   └── requirements.yml # Collection deps for integration tests (unchanged)
│   └── unit
│       ├── requirements.in # Unit test deps
│       └── requirements.txt # Compiled lockfile for unit test deps
```

## Design decisions

The design of the proposed dependency layout address the following criteria:

### Single source of truth

**Runtime:** `meta/ee-requirements.txt` with `>=` minimums  
**Test framework:** `tests/test-requirements.in` references runtime deps  
**Test-specific:** `tests/unit/requirements.in` and `tests/integration/requirements.in`  
**Collections:** `tests/integration/requirements.yml`

### CI catches dependency changes

**Mechanism:** `tox -e check-requirements` CI gate  

- Runs `uv pip compile` without `--upgrade`
- Uses `git diff --exit-code` to detect changes
- Fails if lockfiles are out of sync with `.in` sources

### EE/ansible-builder ready

**Files:**

- `meta/execution-environment.yml` points to `meta/ee-requirements.txt` and `meta/ee-bindep.txt`
- `galaxy.yml` build_ignore does not include `meta/`
- Runtime deps use `>=` (not `==`) for cross-collection compatibility

### Runtime vs dev vs test separation

**Runtime:** Only in `meta/ee-requirements.txt` (`botocore`, `boto3`, `aiobotocore`)  
**Dev tools:** Not committed to lockfile; devs run `tox -e compile-requirements` locally  
**Test framework:** In `tests/*/requirements.{in,txt}`, loaded by tox

### Oldest and newest SDK paths both survive

```ini
# tox.ini configuration
deps =
  -rmeta/ee-requirements.txt
  ansible2.17: ansible-core>2.17,<2.18
  ...
  with_constraints: -ctests/constraints.in -rtests/unit/requirements.in
  without_constraints: -rtests/unit/requirements.txt
```

- `with_constraints` → installs from `.in` files → applies `tests/constraints.in` → gets pinned floor (==1.38.23)
- `without_constraints` → installs from `.txt` lockfiles → gets recent versions from compile

### Constraints stay in sync

This proposal sets us up to keep `meta/ee-requirements.txt` minimums in sync with `tests/constraints.in` pins.

`tests/constraints.in` provides a single source of truth to pin SDK floor versions:

```ini
botocore==1.38.23
boto3==1.38.23
aiobotocore==2.23.0
awscli==1.40.22
```

Validation logic is TBD but could be a straightforward action in `cloud-content-ci-automation` or a tox environment.

### tox-ansible can find test deps

Test deps are in standard locations:

- `tests/unit/requirements.txt`
- `tests/integration/requirements.txt`  
- `tests/integration/requirements.yml`

`tox.ini` also explicitly references test deps.

### Contributors can easily find runtime deps

`requirements.txt` at the project root contains `-r meta/ee-requirements.txt`.
This provides a convenient way for contributors to find runtime dependencies in an expected location.
Additionally developers can use `requirements.txt` to add or adjust dependencies during local development.

`requirements.txt` is also added to the build ignore list in `galaxy.yml`.
