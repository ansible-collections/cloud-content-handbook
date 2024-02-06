# Code Review Guidelines

Code review plays a pivotal role in our development process, guaranteeing the quality, maintainability, and collaborative excellence of our codebase. The guidelines presented here are evolving, offering a structured approach to code reviews and cultivating a culture of continuous improvement and knowledge sharing within our development team.

### 1. Be Kind
Maintaining a positive and respectful tone in feedback is essential. Acknowledge the submitter's efforts, fostering a constructive and collaborative atmosphere that emphasizes improvement over criticism.

### 2. Prompt Initiation of Code Reviews
Try to initiate code reviews promptly, ideally on the same day or the next, to prevent bottlenecks and facilitate quicker iteration on code changes.

### 3. Clarity and Readability:
Ensure that the code is clear and concise. Prioritize readability to enhance understanding and maintainability.

### 4. Code Examples
Provide comprehensive and illustrative snippets to support feedback and recommendations. When offering guidance or suggesting improvements, aim to go beyond mere textual explanations. Instead, supplement your comments with tangible code examples that vividly showcase the recommended practices, design patterns, or alternative approaches.

### 5. Make it manageable
Look for opportunities to split up large reviews to achieve focused and efficient assessments, reduced cognitive load, quicker turnaround, improved collaboration, easier debugging, enhanced code quality, and iterative progress.
Example:
When a large codebase undergoes a significant refactoring, instead of reviewing the entire refactoring in one go, the review process can be broken down into manageable segments - Module A Refactoring, Class B Improvements, New Functionality in Module C, Code Duplication Elimination etc

### 6. Navigating Stalemates
Effectively navigate stalemates in code reviews through timely identification of the same, open communication, seeking common ground, involving additional perspectives, defining actionable steps, establishing a decision-making process, and documenting agreements in the [coding guidelines](https://github.com/ansible-collections/cloud-content-handbook/blob/main/GUIDELINES/coding_guidelines.md). 

### 7. Collaboration and Communication:
Foster a positive and collaborative atmosphere during code reviews. Provide constructive feedback that promotes improvement and encourages knowledge sharing within the team.

### 8. Continuous Learning:
Encourage ongoing learning and knowledge sharing. Use code reviews as opportunities for mentoring and skill development.

### 9. Guided Feedback
Ensure feedback in code reviews is tethered to coding guidelines rather than individual opinions. Promote objectivity and consistency in the evaluation process.

### 10. Checklist 
- Confirm that the proposed changes in the pull request have been locally verified. If this is not feasible, ensure that reason is mentioned in the PR comments, explicitly.
- Gain a thorough understanding of the feature or bug fix by reviewing related requirements and documentation mentioned in the PR. In case of ambiguity, request additional details through a comprehensive PR summary, changelog, or documentation.
- Verify that the code addresses the specified requirements and functions as intended.
- Enforce adherence to [coding standards and style guidelines]((https://github.com/ansible-collections/cloud-content-handbook/blob/main/GUIDELINES/coding_guidelines.md). [Automated tools](https://github.com/ansible-collections/cloud-content-handbook/blob/main/CI/README.md#what-checks-are-run) are leveraged to catch common issues related to coding standards.
- Identify and address any instances of code duplication. Encourage the use of shared functions or modules where applicable.
- Confirm consistency with coding patterns and practices across the entire codebase.
- Verify that the code adheres to licensing requirements and complies with legal standards. Refer [the note](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_in_groups.html) for more information on licensing requirements.
- Verify that tests have been added or updated to cover all changes to the code.
- Verify that any new or updated tests were executed and passed in the Continuous Integration (CI) environment.

# Pull Request Submission Guidelines

Submitting a Pull Request (PR) is a collaborative process that benefits from clarity and adherence to best practices.

### **1. Clearly Define the Purpose**
Clearly articulate the purpose of your changes. Explain what problem your PR is solving or what enhancement it brings.

### **2. Provide Detailed Descriptions**
Offer detailed descriptions for your changes. Explain the reasoning behind decisions and any potential trade-offs.

### **3. Small, Focused Changes**
Keep your changes focused and avoid bundling unrelated updates. Small, incremental changes are easier to review and merge.

### **4. Check for Code Quality**
Run linters and static code analysis tools to check for code quality issues. Address any identified problems before submitting. Do not request for review until all the sanity and linters tests pass. If these tests cannot be fixed, please mention the reasons in the description.

### **5. Follow Coding Standards**
Adhere to the project's [coding standards and style guidelines](https://github.com/ansible-collections/cloud-content-handbook/blob/main/GUIDELINES/coding_guidelines.md). Consistent code formatting makes reviews smoother.

### **6. Include Tests**
If applicable, include tests that cover your changes. Ensure existing tests pass and add new ones to validate your modifications.

### **7. Update Documentation**
If your changes impact project documentation, update it accordingly. Clear and updated documentation helps users and other contributors.

### **8. Respect Branching Strategies**
Adhere to the project's branching strategies. Submit your PR against the appropriate branch, and understand the project's release cycle.

### **9. Verify CI Status**
Ensure that your changes pass the Continuous Integration (CI) checks. Address any CI failures promptly.

### **10. Don't Squash Commits Once a PR is Under Review**:
Avoid squashing commits during the review process to maintain a clear history of changes.

### **11. Respond to Feedback**
Be responsive to feedback from reviewers. Address comments, make necessary adjustments, and engage in discussions to improve the PR.

### **12. Be Patient**
Understand that code reviews take time. Be patient and responsive during the review process.

## References
1. https://www.processimpact.com/articles/humanizing_reviews.pdf
2. https://leaddev.com/team/making-code-reviews-teachable-moments
