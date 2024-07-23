# Asynchronous Story Pointing using [Kollabe](https://kollabe.com)

**Introduction:** 

Story pointing is a crucial part of our agile development process, helping us estimate the effort required for various tasks. However, synchronous story pointing meetings can often be time-consuming and challenging to schedule, especially for distributed teams across different time zones. To address these challenges, I propose using [async planning poker from Kollabe](https://kollabe.com/posts/asynchronous-planning-poker).

**Benefits of asynchronous story pointing:**

- **Flexibility:** Team members can log their story points at a time that suits them best, leading to better participation rates.
- **Inclusivity:** By removing the need for everyone to be present at the same time, we can ensure that all team members, regardless of their location or time zone, can contribute equally.
- **Efficiency:** Reducing the need for lengthy meetings can free up valuable time for development and other critical tasks.
- **Improved Accuracy:** With more time to consider and provide estimates, team members can offer more thoughtful and accurate story points.

**Agile Poker Plugin for Jira:**

An easier and more straightforward method is to use the Agile Poker plugin directly with Jira. This plugin seamlessly integrates with Jira, allowing for real-time and asynchronous story pointing without the need for manual data handling. Despite its benefits, the Jira stakeholders do not currently prioritize this solution, showing no interest in adding it to Jira.

**Kollabe's Planning Poker:**

Kollabe’s Planning Poker is a powerful tool designed to facilitate asynchronous story pointing sessions, making it easier for distributed teams to collaborate effectively. Here’s how Kollabe’s Planning Poker enhances the estimation process:

1. **User-Friendly Interface:**
    
    Kollabe’s Planning Poker offers an intuitive interface that is easy to navigate, ensuring that all team members, regardless of their technical proficiency, can participate without difficulty.
    
2. **Real-Time and Asynchronous Modes:**
    
    While supporting real-time sessions, Kollabe excels in asynchronous mode, allowing team members to provide their estimates at their convenience. This flexibility is crucial for teams spread across different time zones.
    
3. **Detailed Task Descriptions:**
    
    Product Owners can input comprehensive task descriptions and acceptance criteria, providing all necessary information for accurate estimation.
    
4. **Integrated Discussion Threads:**
    
    If there are discrepancies in estimates, team members can engage in discussion threads within the tool. This feature facilitates detailed conversations and helps reach a consensus without needing a live meeting.
    
5. **Automated Results Aggregation:**
    
    Once all estimates are submitted, Kollabe automatically aggregates the results and highlights any significant variances, streamlining the consensus-building process.
    
6. **Integration with Jira:**

	Kollabe enables direct import of Jira issues into Planning Poker sessions, ensuring all relevant tasks are available for estimation without manual entry. However, this requires the tool to have access to our Jira board. As a workaround, tasks can be manually exported as a CSV file from Jira and uploaded to Kollabe.
    
**How shall we use Kollabe's Asynchronous Planning Poker:**

1. **Task Preparation:**
    
    - The Product Owner filters the backlog issues that are to be worked on and exports them into a csv file. 
    - Relevant details and acceptance criteria for each task are provided to ensure all team members have the necessary context.
    -  A room or session is created in the Kollabe's Planning Poker tool and the team members are invited. The session is configured to facilitate asynchronous voting.
    - The csv file from the Jira board is uploaded into the Planning Poker session.
    - Team members are asked to vote for all the tasks uploaded within a given timeframe.
    
2. **Individual Estimation:**
    
    - Team members access the Planning Poker session and review the user stories/tasks at a time that suits them.
    - Each team member independently selects their estimate for the task using the tool’s interface, typically by choosing a story point value from a predefined scale (e.g., Fibonacci sequence: 1, 2, 3, 5, 8, 13, etc.).
    
3. **Discussion Phase:**
    
    - Once all team members have submitted their estimates, the tool reveals the estimates to everyone.
    - If there is a significant variance in estimates, the team can discuss the discrepancies asynchronously through comments or threads within the tool.
    - Team members can revisit their estimates based on the discussion, ensuring that all perspectives are considered.
    
4. **Consensus Building:**
    
    - After the discussion phase, team members submit their final estimates.
    - The tool aggregates the estimates, and a consensus is reached on the story points for each task.
    - 
5. **Documentation and Review:**
    
    - The final estimates are documented into Jira, and any significant discussions or notes are recorded for future reference.
    - The Product Owner reviews the results and can follow up on any tasks that require further clarification. 
    
**Conclusion:**

Implementing an asynchronous story pointing tool can significantly enhance our agile process by making it more flexible, inclusive, and efficient. This change will lead to better participation, more accurate estimates, and ultimately, more successful project outcomes.