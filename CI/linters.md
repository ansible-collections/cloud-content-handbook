# Transitioning to `ruff`: A Comprehensive Guide and Configuration Plan

## Overview of Current Linters and Their Limitations
In our continuous integration (CI) pipeline, we utilize several linters to maintain code quality and consistency in our projects. These linters include:

- [ansible-lint](https://ansible.readthedocs.io/projects/lint/) - ensures adherence to best practices and conventions in Ansible playbooks. ``ansible-lint``does not run on integration tests.
- [black](https://black.readthedocs.io/en/stable/) - enforces consistent code formatting.
- [flake8](https://flake8.pycqa.org/en/latest/) - checks for code quality and style issues.
- [isort](https://pycqa.github.io/isort/index.html) - ensures that import statements are sorted correctly.
- [mypy](https://mypy.readthedocs.io/en/stable/) - performs static type checking to detect type-related errors early in the development process.
- [flynt](https://pypi.org/project/flynt/) - string formatting converter that converts Python code from old `"%-formatted"` and `.format(...)` strings into Python 3.6+'s `"f-strings"`.

The use of linters is critical for several reasons. First, linters help ensure that our codebase follows coding standards, conventions, and best practices, improving readability and maintainability. By detecting potential problems such as syntax errors, style violations, unused variables, and type inconsistencies early on, linters help prevent bugs and improve codebase quality. In addition, linters promote consistency within the codebase, making it easier for developers to collaborate and understand each other's code.

Although `black`, `isort`, `flake8`, `flynt` and `mypy` are popular and effective linters in their own right, they may have some pain points:

- _Separate Tools_: these are separate tools, each focusing on specific aspects of linting, formatting, or code analysis which lead to a fragmented linting workflow, requiring developers to configure and use multiple tools separately.
- _Complex Configuration_: Each of these linters has its own configuration format and options, leading to additional complexity in setting up and maintaining linting configurations.
- _Inconsistent Behavior_: Since `black`, `isort`, `flake8`, `flynt` and `mypy` are separate tools, they may have different behavior, default settings, and interpretations of linting rules. This can lead to inconsistencies in linting results.
- _Workflow Overhead_: Running multiple linters sequentially can introduce overhead into development workflows, particularly for large codebases, which can affect development iteration cycles and overall productivity.
- _Maintenance Overhead_: Managing updates, dependencies, and compatibility issues for multiple linters can increase maintenance overhead.
- _Limited Extensibility_: Although these linters offer customization options and plugins to extend their functionality, they may have limitations in terms of extensibility and flexibility.

## Ruff: Lint Code Faster

In contrast, [ruff](https://docs.astral.sh/ruff/) addresses these limitations by providing a unified solution for code linting, formatting, and style checking. It offers streamlined configuration, consistent behavior, seamless integration, and enhanced efficiency compared to using multiple separate linters.

`Ruff`'s focus on speed, flexibility, and developer experience makes it a compelling choice for teams looking to simplify and streamline their linting workflows.
It can be used to replace `flake8` (`ruff` has native support for about 50 `flake8` packages. See the full [list in the docs](https://docs.astral.sh/ruff/rules/?ref=blog.jerrycodes.com#rules).), `black`, `isort`, `pydocstyle`, `pyupgrade`, `autoflake`, and more, all while executing tens or hundreds of times faster than any individual tool.

### Motivation for Adopting `ruff`

- _Unified Tooling_: `ruff` provides a single, unified configuration format for all linting rules and settings, simplifying setup and maintenance.
- _Comprehensive Linting_: `ruff` combines the functionality of multiple traditional linters into a single tool, providing comprehensive code analysis and reporting.
- _Speed and Efficiency_: `ruff`'s quick and efficient code linting capabilities enable rapid analysis of code, leading to faster iteration cycles, accelerated code reviews, and timely resolution of code quality issues.
- _Flexibility and Extensibility_: `ruff` supports custom rules, plugins, and configuration options, allowing for flexible customization to suit project-specific requirements.
- _Improved Developer Experience_: `ruff`'s fast feedback loop and informative reports help developers identify and fix issues quickly, leading to a smoother development experience.
- _Ecosystem Integration_: `ruff` integrates seamlessly with popular development tools, version control systems, and CI pipelines, enhancing collaboration and workflow efficiency.
- _Future-Proofing_: Adopting `ruff` positions your development process for future growth and scalability, ensuring compatibility with evolving best practices and tooling trends in the Python ecosystem.
- _Community and Support_: `ruff` benefits from an active community of users and contributors, with ongoing development and support for new features and enhancements.

### Transitioning Plan

The following is an example of a transition plan for migrating from individual linters (`black`, `isort`, `flake8`, `flynt`, `mypy`) to `ruff`, enabling `ruff` in the CI pipeline for a period before making it the main linter:

1. Configuration Migration:
    - Convert existing linting configurations for `black`, `isort`, `flake8`, `flynt`, `mypy` to the `ruff` configuration format.
    - Ensure that the `ruff` configuration aligns with the linting requirements and coding standards of the project.

2. Gradual Rollout:
    - Enable `ruff` in the CI pipeline along with existing linters, initially configuring it to run with a limited set of rules. For example:

        ```
            "E",      # pycodestyle
            "W",      # pycodestyle
            "F",      # Pyflakes
            "Q",      # flake8-quotes
            "I",      # isort
            "TID",    # flake8-tidy-imports
            "TCH",    # flake8-type-checking
            "PL",     # Pylint
            "FLY",    # Flynt
            "COM",    # flake8-commas
            "N",      # pep8-naming
            "YTT",    # flake8-2020
            "PT",     # flake8-pytest-style
            "ISC",    # flake8-implicit-str-concat
            "D",      # pydocstyle
            "C90",    # mccabe
        ```

    - Monitor `ruff`'s output and identify any discrepancies or issues compared to the existing linters. This phase should last for a trial period of 1 month.
    - Validate `ruff`'s behavior and performance in the CI pipeline, ddress any discrepancies and fine-tune the `ruff` configuration as needed.

3. Gradual Transition to Additional Rules:
    - After the trial period, based on feedback and validation results, gradually enable additional rules in the `ruff` configuration. For example:

        ```
            "S",      # flake8-bandit
            "C",      # complexity
            "FBT001", # flake8-boolean-trap
            "UP",     # pyupgrade
            "SIM",    # flake8-simplify
            "C4",     # flake8-comprehensions
            "RUF",    # Ruff-specific rules
            "B",      # flake8-bugbear
        ```

    - Monitor the impact of enabling additional rules on the linting results and developer workflow, addressing any issues or concerns raised.

4. Evaluation and Decision:
    - Evaluate `ruff`'s performance and impact on the development process based on feedback and metrics collected during the trial period.
    - Decide whether to make `ruff` the primary linter in the CI pipeline based on its effectiveness, developer acceptance, and alignment with our goals.

5. Full Migration:
    - Once the decision is made to transition to `ruff`, update the CI pipeline configuration to make `ruff` the primary linter, replacing `black`, `isort`, `flake8`, `flynt`, `mypy`.
    - Ensure that `ruff` is configured to enforce linting rules and standards, and adjust the CI pipeline as needed to accommodate the change.

This approach allows for a smooth and iterative migration process, minimizing disruptions to the development workflow while maximizing the benefits of adopting `ruff`.

### File Configuration Example for `ruff`
One of the advantages of `ruff` is its configuration integration in the `pyproject.toml` format. The file `pyproject.toml` serves as a complete configuration file that stores all configurations and rules for linting and formatting Python code. The enabled rules and configurations are carefully selected to ensure that they do not introduce any significant differences compared to our current set of linters. This compatibility ensures a seamless transition and allows us to maintain consistency in our code quality standards across the development workflow.

```
[tool.ruff]
# This section defines global settings for the ruff linter.
builtins = [ "__",]
line-length = 120
target-version = "py39"

[tool.ruff.lint]
# This section configures specific linting rules and options for ruff.
# See all rules at https://docs.astral.sh/ruff/rules/
select = [
    "E",      # pycodestyle
    "W",      # pycodestyle
    "F",      # Pyflakes
    "Q",      # flake8-quotes
    "I",      # isort
    "TID",    # flake8-tidy-imports
    "TCH",    # flake8-type-checking
    "PL",     # Pylint
    "FLY",    # Flynt
    "COM",    # flake8-commas
    "N",      # pep8-naming
    "YTT",    # flake8-2020
    "PT",     # flake8-pytest-style
    "ISC",    # flake8-implicit-str-concat
    "D",      # pydocstyle
    "C90",    # mccabe

    # To be enabed
    # "S",      # flake8-bandit
    # "C",      # complexity
    # "FBT001", # flake8-boolean-trap
    # "UP",     # pyupgrade
    # "SIM",    # flake8-simplify
    # "C4",     # flake8-comprehensions
    # "RUF",    # Ruff-specific rules
    # "B",      # flake8-bugbear
]

ignore = [
    # Conflicts with the formatter
    "COM812", "ISC001",
    "E741",             # Ambiguous variable name
    "E501",             # Never enforce `E501` (line length violations).
    "F401",             # imported but unused
    "F811",             # redefinition of unnused
    "F841",             # Local variable is assigned to but never used
    "PLR",              # Design related pylint codes
    "PLW",              # Design related pylint codes
    "RUF012",	        # Mutable class attributes should be annotated with `typing.ClassVar`
    "N806",   	        # Variable in function should be lowercase
    "N802",          	# Function name should be lowercase
    "N818", 	        # Exception name should be named with an Error suffix
    "N803",          	# Argument name `keyId` should be lowercase
    "N801",             # Class name should use CapWords convention
    "UP009",            # UTF-8 encoding declaration is unnecessary
    "ISC003",           # Explicitly concatenated string should be implicitly concatenated
    "D401",             # First line of docstring should be in imperative mood
    "C901",             # `_compare_condition` is too complex (15 > 10)
    "D205",             # 1 blank line required between summary line and description
    "D400",    	        # First line should end with a period
]

# Disable fix for unused imports (`F401`).
fixable = ["ALL"]

# Avoid trying to fix flake8-bugbear (`B`) violations.
unfixable = ["F401", "B"]

# Allow unused variables when underscore-prefixed.
dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

[tool.ruff.lint.isort]
# This subsection configures isort-specific settings for ruff, such as section ordering and known third-party libraries.
force-single-line = true # Force from .. import to be 1 per line
section-order = ["future", "standard-library", "third-party", "first-party", "ansible_core", "ansible_amazon_aws", "ansible_community_aws", "local-folder"]
known-local-folder = [ "plugins", "tests/unit", "tests/integration",]
known-third-party = [ "botocore", "boto3",]

[tool.ruff.lint.isort.sections]
ansible_core = [ "ansible",]
ansible_amazon_aws = [ "ansible_collections.amazon.aws",]
ansible_community_aws = [ "ansible_collections.community.aws",]

[tool.ruff.lint.pydocstyle]
# This subsection specifies the convention used for docstring style checking by ruff.
convention = "pep257"

[tool.ruff.lint.per-file-ignores]
# This subsection defines per-file ignore rules for specific file paths or patterns.
# 402: Module level import not at top of file
"plugins/**/*.py" = [ "D1", "E402"]
"tests/**/*.py" = [
    "D1",
    "E402",
    "S101",  # asserts allowed in tests...
    "ARG",   # Unused function args -> fixtures nevertheless are functionally relevant...
    "FBT",   # Don't care about booleans as positional arguments in tests, e.g. via @pytest.mark.parametrize()
    "PT",    # pytest error codes
]

[tool.ruff.format]
# This section configures code formatting options for ruff, such as quote style, line ending, and docstring formatting.
# Like Black, use double quotes for strings.
quote-style = "double"

# Like Black, indent with spaces, rather than tabs.
indent-style = "space"

# Like Black, respect magic trailing commas.
skip-magic-trailing-comma = false

# Like Black, automatically detect the appropriate line ending.
line-ending = "auto"

# Enable auto-formatting of code examples in docstrings. Markdown,
# reStructuredText code/literal blocks and doctests are all supported.
#
# This is currently disabled by default, but it is planned for this
# to be opt-out in the future.
docstring-code-format = false

# Set the line length limit used when formatting code snippets in
# docstrings.
#
# This only has an effect when the `docstring-code-format` setting is
# enabled.
docstring-code-line-length = "dynamic"
```

### Integrating Ruff with Pre-Commit Hooks

By integrating `ruff` with pre-commit hooks, we can enforce code quality standards and ensure consistent linting practices across all code changes. This seamless integration automates the linting process, providing developers with immediate feedback on code quality issues before they are committed to the repository.
