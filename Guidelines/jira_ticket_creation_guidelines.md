# Jira Ticket Creation Guide

This document provides a standard template and best practices for creating Jira tickets for the Cloud Content team, applicable to epics, user stories, spikes, and tasks.
The template serves as a reference and can be adjusted to fit the specific feature or goal being worked on.

---

## 1. General Guidelines

- **Component:** `cloud-content`  
- **Workstream:** `"Cloud Content"`  
- **Priority & Due Date:** Use your judgment or check with the BU/team.  
- **Description & Acceptance Criteria:** Spend a few minutes making these clear and detailed so that whoever picks up the ticket or reviews it has all necessary information.  
- **Labels:** Use meaningful and consistent labels.  
- **Support:** If you are in doubt, check with `#ansible-jira-support` or `#ansible-cloud-team`.  

> **Note:**  
> - *Acceptance Criteria* are **specific to each ticket** — they define what success looks like for that particular epic, story, task, or spike. Make demos a part of the delivery whenever relevant.
> - The *Definition of Done (DoD)* should remain **consistent across tickets** and reflect the team’s shared understanding of completion (for example: code reviewed, tested, documented, and handed off).  

---

## 2. Epic Template

**Title:**  
[Epic Name] - Provide a short, descriptive name for the epic.
**Example:** `AWS S3 Resource Counting`  

**Summary:**  
Brief description of the epic’s purpose.

**Description:**  
- Goal of the epic  
- Why it matters  
- Scope and key areas covered  

**Acceptance Criteria:**  
> **Note:** These are specific to this epic and define what success looks like.

**Definition of Done:**  
- All associated user stories and tasks are completed 
- Outcomes meet the acceptance criteria  
- Documentation or handoff notes are complete

**Labels:**
Provide relevant labels for tracking and reporting purposes.

**Due Date:** Specify an appropriate milestone as the due date.

---

## 3. User Story Template

**Title:**  
[Name] – [Goal/Activity] - Provide a short, descriptive name and goal or activity.
**Example:** `S3 Bucket Listing – View Bucket Usage Summary`

**User Story:**  
As a [role], I want [goal] so that [benefit].  

**Supporting Documentation:**
Provide any relevant materials or references that can help complete the user story

**Acceptance Criteria:**  
- > **Note:** These are specific to this user story and describe what needs to be achieved.

**Definition of Done:**  
- Task has been completed and tested (if applicable)  
- Key takeaways or outcomes are documented, demoed or shared  
> **Note:** DoD should remain consistent across all user stories.

**Labels:**  
Provide relevant labels for the user story.

---

## 4. Task Template

**Title:**  
[Name] – [Specific Activity] - Provide a clear and descriptive name for the task.
**Example:** `S3 Bucket Listing – Write a Module to Fetch Bucket Details`

**Description:**  
Write a short, actionable description of the task and the expected outcome.

**Supporting Documentation:**
Provide any relevant materials or references that can help complete the task.

**Checklist / Subtasks (optional):**  
- [ ]
- [ ]

**Acceptance Criteria:**  
> **Note:** These are specific to this task and define what completion looks like.

**Definition of Done:**  
- Task is completed and meets all acceptance criteria  
- Progress is updated 
- Optional outcomes or insights are shared with the team  
> **Note:** DoD should follow the team-wide standard for completed tasks.

**Labels:**  
Provide relevant labels for the task.

---

## 5. Spike Template

**Title:**  
[Spike] – [Brief Description of Research/Investigation Topic] - Provide a brief description of the research or investigation topic.
**Example:** `Spike – Evaluate Methods for Counting AWS S3 Buckets Efficiently`

**Component:**  
`cloud-content`  

**Workstream:**  
`Cloud Content`  

**Priority & Due Date:**  
Set the priority and due date based on urgency or in consultation with the BU/team.

**Description / Goal:**  
Provide a brief summary of the research or investigation to be done. Include:  
- The problem or question you are trying to answer  
- Why this spike is needed  
- Any assumptions or context  

**Supporting Documentation:**
Provide any relevant materials or references that can help complete the task.

**Acceptance Criteria:**  
> **Note:** These are specific to this spike and define what it should achieve.

**Definition of Done:**  
- Spike investigation is complete and documented  
- Findings, recommendations, or decisions are clearly shared  
- Any next steps or follow-up actions are identified  
> **Note:** DoD should follow the team-wide standard for completed spikes.

**Checklist / Tasks (optional):**  
- [ ] Gather information and data  
- [ ] Test possible approaches or solutions (if applicable)  
- [ ] Document findings and insights  
- [ ] Share outcomes with team or stakeholders  

**Labels:**  
Provide relevant labels for the spike.

---

## 6. Best Practices

1. Keep titles and descriptions clear and concise.  
2. Use standard components, workstreams, and labels.  
3. Ensure progress is trackable.  
4. Encourage sharing of outcomes.  
5. Use checklists for multi-step tasks for easier tracking.  
6. If unsure about any details, check with `#ansible-jira-support` or `#ansible-cloud-team`.  

---

## 7. References

- [Ansible: Jira Issue Use Guide](https://docs.google.com/document/d/1gl0cj4RyMuQ7TSd8hIqXFrHXsvMt10nd-fTg30CQncA/edit?usp=sharing)
- [Ansible Collaborative Delivery 3.0](https://docs.google.com/presentation/d/1r8tgHoTdy0TIgHh44rioWLqRDrETVXdekawsVyjuePc/edit?usp=sharing)
- [Ansible Knowledge Base](https://spaces.redhat.com/spaces/AAP/pages/407320866/Ansible+Knowledge+Base)

