# Coding Guidelines

## Overview

This document encompasses evolving coding guidelines and best practices intended for adoption by developers contributing to our projects. The primary goal of these guidelines is to ensure code consistency, readability, and maintainability across our codebase.

## Introduction

Our coding guidelines are a work in progress and subject to ongoing refinement. They provide a recommended approach to writing code within our projects. Adhering to these standards is encouraged and followed based on project-specific necessities.

## Automated checks

Our GitHub Action workflows conduct automated checks within our Continuous Integration (CI) pipeline. These checks utilize various tools such as ansible-lint, black, flake8, among others. Prior to submitting a PR containing your modifications, it is essential to run these tools locally. Please note that the guidelines provided may not encompass all the aspects covered by these tools.

## Coding Standards

### Language-specific Guidelines

**_Python_**
- “Don’t repeat yourself” is generally a good philosophy.
- Write clear and straightforward code, avoiding overly complex or convoluted constructs.
- If your code is too nested, that’s usually a sign the loop body could benefit from being a function. 
- Leverage Python's built-in functions and standard libraries whenever suitable to reduce code verbosity and improve efficiency.
- Do NOT use wildcards (*) for importing other python modules; instead, list the function(s) you are importing 
- Always return useful data, even when there is no change.
- Use Python type hints to document variable types. Type hints are supported in Python 3.5 and greater.
    - At least annotate your public functions
    - Annotate code that is prone to type-related errors
- Prefer specific exception handling over broad exceptions to pinpoint errors accurately.
- Minimize the usage of global variables; prefer encapsulating logic within functions or classes.
- Use pytest for writing unit tests for plugins

**_Ansible_**
- Do not use sys.exit(). Use fail_json() from the module object.
- Don’t raise a traceback (stacktrace). Ansible can deal with stacktraces and automatically.
- Split long Jinja2 expressions into multiple lines.
- Spell out all task arguments in YAML style and do not use key=value type of arguments
- Use true and false for boolean values in playbooks.
- When naming files, use the .yml extension and not .yaml. 
- Do not override role defaults or vars or input parameters using set_fact. Use a different name instead.
- Do not use the eq, equalto, or == Jinja tests introduced in Jinja 2.10, use Ansible built-in match, search, or regex instead.
- Avoid the use of lineinfile wherever that might be feasible.
- All defaults and all arguments to a role should have a name that begins with the role name to help avoid collision with other names. 
- Minimize the usage of shell or command modules when equivalent Ansible modules are available.
- Activate argument validation for roles by utilizing an argument specification.
- Combine multiple changes to trigger a single handler to avoid unnecessary execution.
- Implement error handling strategies (e.g., ignore_errors, failed_when, changed_when) to handle failures gracefully.

### Naming Conventions
- Function names, variable names, and filenames should be descriptive.
- Module name MUST use underscores instead of hyphens or spaces as a word separator. Using hyphens and spaces will prevent ansible-core from importing your module.
- Function names should use underscores: my_function_name
- Use snake_case_naming_schemes for all YAML or Python files, variables, arguments, repositories, and other such names (like dictionary keys).
- Do not use special characters other than underscore in variable names, even if YAML/JSON allow them.
- Avoid numbering roles and playbooks, you’ll never know how they’ll be used in the future.
- Name all tasks, plays, and task blocks to improve readability.
- Write task names in the imperative (e.g. "Ensure service is running"), this communicates the action of the task.


### Documentation
- Documentation should be written for broad audience–readable both by experts and non-experts.
- Pay attention to punctuation, spelling, and grammar; it is easier to read well-written comments than badly written ones.
- Module documentation should briefly and accurately define what each module and option does, and how it works with others in the underlying system.
- Descriptions should always start with a capital letter and end with a full stop.
- Verify that arguments in doc and module spec dict are identical.
- For password / secret arguments no_log=True should be set.
- For arguments that seem to contain sensitive information but do not contain secrets, such as “password_length”, set no_log=False to disable the warning message.
- If an option is only sometimes required, describe the conditions. For example, “Required when I(state=present).”
- Functions should have comments for their intent in the form of a docstring. Always use the three-double-quote """ format for docstrings (per PEP 257).  In addition to the intent of the function, docstring should have args, return values, exceptions raised.
- Classes should have a docstring below the class definition describing the class. If your class has public attributes, they should be documented here in an Attributes section
- The good place to have comments is in tricky parts of the code. If you’re going to have to explain it at the next code review, you should comment it now, as inline comment.
- A TODO comment begins with the word TODO in all caps, a following colon, and a link to a resource that contains the context, ideally a bug reference.
- Document playbooks and roles extensively using comments and README files to provide context and usage instructions for future reference.

### Security
- Passwords should never be stored in plain text.
- The exec and eval functions should be used sparingly, as they can execute arbitrary Python code. If they are used, the data passed to them should be safe and sanitized.
- If network communication is involved, secure protocols like HTTPS should be used.
- When fetching URLs, use fetch_url or open_url from ansible.module_utils.urls. Do not use urllib2, which does not natively verify TLS certificates and so is insecure for https.
- Sensitive information like usernames, passwords, session tokens, etc., should not be included in URLs, as they can be logged or leaked through the Referer header.
- Sensitive values marked with no_log=True will automatically have that value stripped from module return values. If your module could return these sensitive values as part of a dictionary key name, you should call the ansible.module_utils.basic.sanitize_keys() function to strip the values from the keys. 
- When a random number is needed for a security purpose, such as a session id or token, a secure random number generator should be used.
- Check if obsolete or broken algorithms like md5 are used. Python's built-in hashlib module provides secure hash functions and message digest algorithms.
- Safely manage sensitive data and credentials using Ansible Vault to encrypt and secure files containing secret information while using ansible playbooks.

### Performance Considerations
**_Python_**
- Prefer list comprehensions or generator expressions over traditional loops for better performance.
- Use built-in functions (e.g., map(), filter()) for iterative operations instead of manual loops.
- Be mindful of unnecessary copying of data structures. Use slicing or references instead of creating new copies.
- Use join() instead of concatenating strings within loops for improved performance.
- Consider using f-strings for string formatting due to their faster performance compared to other methods.
- Use generator functions to generate values on-the-fly, conserving memory by avoiding large data structures.
- Employ context managers (with statement) for file handling to ensure proper resource cleanup.
- Use buffered I/O operations when dealing with large files to minimize disk reads/writes.

**_Ansible_**
- Choose Ansible modules optimized for performance over less efficient ones, especially when dealing with large-scale operations.
- Organize playbooks logically and avoid unnecessary nesting to reduce execution time.
- Leverage asynchronous actions and async support in Ansible to run tasks concurrently when applicable.
- Design Ansible roles for reusability and efficiency to minimize duplicate code and optimize execution.
