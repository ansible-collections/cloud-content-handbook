# Moving to a New Python Tooling Stack: Ruff & Pre-Commit

## Pre-commit hooks
Maintaining code quality can be challenging no matter the size of the project or the number of contributors. We need to agree on a set of standards for the codebase, and then you have to enforce them consistently. This is a challenge for humans: we make mistakes, forget things, and have differences in opinion. Computers, however, can help both the developer and the reviewer efficiently enforce many of these standards:

1. Pre-commit hooks give the developer near-instant feedback on the code locally.
2. Continuous integration (CI) tools give the reviewer feedback on the code without having to pull it down locally. Evaluation of the code with a CI tool is often more thorough (e.g., running tests, confirming that documentation can be built, etc.), and therefore, takes much longer.

### What are pre-commit hooks?

Pre-commit hooks are code checks that run as part of the "pre-commit" stage of the git commit process. If any of these checks fail, git aborts the commit, at which point you can address the cause(s) of the failure and then retry the commit.
