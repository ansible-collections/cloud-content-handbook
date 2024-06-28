# Overview of Current Linters

In our continuous integration (CI) pipeline, we utilize several linters to maintain code quality and consistency in our projects. These linters include:

- [ansible-lint](https://ansible.readthedocs.io/projects/lint/) - ensures adherence to best practices and conventions in Ansible playbooks. ``ansible-lint``does not run on integration tests.
- [black](https://black.readthedocs.io/en/stable/) - enforces consistent code formatting.
- [flake8](https://flake8.pycqa.org/en/latest/) - checks for code quality and style issues.
- [isort](https://pycqa.github.io/isort/index.html) - ensures that import statements are sorted correctly.
- [mypy](https://mypy.readthedocs.io/en/stable/) - performs static type checking to detect type-related errors early in the development process.
- [flynt](https://pypi.org/project/flynt/) - string formatting converter that converts Python code from old `"%-formatted"` and `.format(...)` strings into Python 3.6+'s `"f-strings"`.

The use of linters is critical for several reasons. First, linters help ensure that our codebase follows coding standards, conventions, and best practices, improving readability and maintainability. By detecting potential problems such as syntax errors, style violations, unused variables, and type inconsistencies early on, linters help prevent bugs and improve codebase quality. In addition, linters promote consistency within the codebase, making it easier for developers to collaborate and understand each other's code.

## Type Hinting

Use of [type hinting](https://docs.python.org/3/library/typing.html) is strongly encouraged. For existing repos, running mypy as a required check during CI is optional. All new repos should enable mypy as a required check during CI, however. In general, all PRs should include type hints, though there may be cases where type hinting is impractical due to, for example, third party libraries that lack types or type stubs. In these cases, consider whether the work required to create and maintain type stubs would be beneficial to the project.
