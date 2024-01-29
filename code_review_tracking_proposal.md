# Tracking Code Reviews

## Introduction

Code reviews are an integral part of our development process, ensuring code quality, collaboration, and knowledge sharing. To enhance this crucial process, various options for tracking code reviews are proposed. In this document, two primary options will be explored: creating a separate code review channel and integrating GitHub with Slack notifications.

### Option 1: Separate Code Review Channel
Establish a dedicated Slack channel to streamline code review communication and progress tracking.

**_Benefits:_**
1. **Focused Communication:**  Keep code review discussions organized and separate from other team conversations.
2. **Clear Visibility:** Easily monitor the status of ongoing reviews and track the progress of each review thread.
3. **Enhanced Collaboration:** Encourage team members to engage in discussions within the dedicated channel, fostering collaboration.

**_Implementation Steps:_**
1. **Create a New Channel:** Establish a new Slack channel dedicated to code reviews (e.g., "#cloud-content-code-reviews").
2. **Invite Relevant Members:** Invite clound content team members involved in the code review process to join the channel.

_**Using Emojis to Indicate Review Stages:**_
**1. Start of Review:**
When initiating a review, use a specific emoji 👀 in a threaded reply to the PR announcement in the channel. This signals that a team member has started reviewing the code.
_Example:_
Requesting Reviews: New feature implementation! - <link> 🚀
Threaded Reply: 👀 Starting the review now!

**2. End of Review:**
Upon completing the review, reply with emoji ✅ to indicate that the review is finished. Include any comments or feedback directly in the thread for clarity.
_Example:_
Threaded Reply: ✅ Review completed. All looks good!

**3. Request Changes:** 
The 🛑 emoji communicates the need for changes in the code. Team members can use this emoji alongside specific feedback or comments to highlight areas requiring attention or modification.
_Example:_
Threaded Reply: �� Please address the formatting issue

**_Drawbacks:_**
Using a separate Slack channel for PR reviews comes with certain disadvantages, like the risk of channel overload, communication fragmentation, limited visibility for non-involved team members, potential notification fatigue, difficulty in context switching, challenges for new team members, and maintenance overhead.

### Option 2: GitHub Integration with Slack Notifications
Leverage GitHub and Slack integration to receive real-time notifications for code review events.

**_Benefits:_**

  1. **Automated Notifications:** Receive instant notifications in Slack for code review events, such as pull request creation, comments, and approvals.
  2. **Seamless Integration:** Align code review updates directly with the version control system, ensuring real-time visibility.
  3. **Customizable Notifications:** Tailor the integration to receive notifications for specific code review events based on team preferences, ensuring that relevant information is highlighted.

**_Implementation Steps:_**
1. **GitHub Slack Integration:** Configure GitHub to send notifications to the desired Slack channel.
2. **Selective Notifications:** Customize the integration to receive notifications for specific code review events (e.g., new pull requests, comments, approvals).
3. **Review and Collaboration:** Engage in code review discussions directly within the GitHub interface and Slack, creating a seamless workflow.

**_Drawbacks:_**
Potential drawbacks of this option include notification overload, contextual disruption, security concerns, integration maintenance, learning curve, and dependency on external services.
