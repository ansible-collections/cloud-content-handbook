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
- Modules should be imported from trusted sources, and preferably limited to those that are actively maintained.
- Always return useful data, even when there is no change. Provide relevant information n the form of a log message or data to the caller. This practice can enhance the usability and clarity of the code.
- Use Python type hints to document variable types. Type hints are supported in Python 3.5 and greater.
    - At least annotate your public functions
    - Annotate code that is prone to type-related errors
- Prefer specific exception handling over broad exceptions to pinpoint errors accurately.
- Minimize the usage of global variables; prefer encapsulating logic within functions or classes.
- Prefer to use join() instead of concatenating strings within loops.It offers improved readability.
- Consider using f-strings for string formatting.They offer readability, conciseness, and are less susceptible to errors.
- Use pytest for writing unit tests for plugins

**_Ansible_**
- Do not use sys.exit(). Use a module specific method, such as fail_json() or fail_json_aws().
- Don’t raise a traceback (stacktrace). Use fail_json() or fail_aws() from the module object.
- Split long Jinja2 expressions into multiple lines.
- Minimize the usage of shell or command modules when equivalent Ansible modules are available.
- Combine multiple changes to trigger a single handler to avoid unnecessary execution.
- Additional and detailed guidelines for using Ansible are provided [here](https://redhat-cop.github.io/automation-good-practices/) as best practices for automation.
- [These guidelines](https://ansible.readthedocs.io/projects/lint/rules/) outline the rules to adhere to when working with Ansible. They are verified as part of the ansible-lint workflow in our CI pipeline.

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
- Functions should have comments for their intent in the form of a docstring. Always use the three-double-quote """ format for docstrings (per PEP 257).  In addition to the intent of the function, docstring should have args, return values, exceptions raised.
Example:
```
def calculate_area(length, width):
    """
    Calculate the area of a rectangle.
    Args:
        length (float): The length of the rectangle.
        width (float): The width of the rectangle.
    Returns:
        float: The calculated area of the rectangle.
    Raises:
        ValueError: If either length or width is negative.
    """
```
- Classes should have a docstring below the class definition describing the class. If your class has public attributes, they should be documented here in an Attributes section.
Example:
```
class Rectangle:
    """
    Represents a rectangle.

    Attributes:
        length (float): The length of the rectangle.
        width (float): The width of the rectangle.
    """

    def __init__(self, length, width):
    < definition >
```
- The good place to have comments is in tricky parts of the code. If you’re going to have to explain it at the next code review, you should comment it now, as inline comment.
- A TODO comment begins with the word TODO in all caps, a following colon, and a link to a resource that contains the context, ideally a bug reference.
- Document playbooks and roles extensively using comments and README files to provide context and usage instructions for future reference.
- Module documentation guidelines can be referenced [here](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_documenting.html#module-documenting).


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
- Prefer comprehensions or generator expressions over traditional loops for improved performance, except in situations involving nested comprehensions, as they can compromise readability. It's crucial to prioritize readability.
- Use built-in functions (e.g., map(), filter()) for iterative operations instead of manual loops.
- Be mindful of unnecessary copying of data structures.
- Use join() instead of concatenating strings within loops for improved performance.
- Consider using f-strings for string formatting due to their faster performance compared to other methods.
- Use generator functions to generate values on-the-fly, conserving memory by avoiding large data structures.
- Employ context managers (with statement) for file handling to ensure proper resource cleanup.
- Use buffered I/O operations when dealing with large files to minimize disk reads/writes.

**_Ansible_**
- Choose Ansible modules optimized for performance over less efficient ones, especially when dealing with large-scale operations.
 An example would be leveraging the ansible.builtin.copy module to efficiently copy files from a local machine to multiple remote servers, as opposed to employing a combination of the command or shell modules along with native shell commands like cp or rsync.
- Organize playbooks logically and avoid unnecessary nesting to reduce execution time.
- Leverage asynchronous actions and async support in Ansible to run tasks concurrently when applicable.
- Design Ansible roles for reusability and efficiency to minimize duplicate code and optimize execution.

### Function Organization and Ordering
- **Start with Foundational Functions:**
   Place foundational or fundamental functions at the beginning of the file. These functions often perform essential tasks that set the groundwork for higher-level functionalities.
- **Progress to Higher-Level Abstractions:**
  Follow a sequential order where functions build upon each other. Place functions that offer higher-level abstractions or encapsulate more complex logic further down in the file.
- **Group Similar Functions:**
  Group together functions that serve similar purposes or handle related tasks. This grouping enhances the code's organization and makes it easier for readers to locate relevant functions.
- **Use Sections or Comments:**:
  If there are distinct sections within the code, consider using headers or comments to delineate these sections. Provide a brief description of the functionality covered by each section.
- **Optimize for Readability:**:
  Optimize the order for readability, making it easy for others (or yourself) to understand the code. Balance the strict ordering with the need to present a coherent narrative.

## References
1. https://redhat-cop.github.io/automation-good-practices
2. https://docs.ansible.com/ansible/latest/dev_guide/
3. https://ansible.readthedocs.io/projects/lint/rules/
4. https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html
5. https://google.github.io/styleguide/pyguide.html
6. https://docs.python-guide.org/writing/style/
