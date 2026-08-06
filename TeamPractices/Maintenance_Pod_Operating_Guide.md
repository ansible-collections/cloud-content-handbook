# Maintenance Pod Operating Guide

## Purpose

The Maintenance Pod is a rotating, six-week pod responsible for maintaining the health, stability, and release readiness of the team's supported content while feature pods focus on strategic initiatives.

The Maintenance Pod is accountable for operational excellence, timely customer support, and ensuring the team can continue delivering high-quality software.

## Objectives

- Resolve customer-reported defects.
- Address security and blocker issues.
- Deliver planned patch and collection releases.
- Reduce technical debt where appropriate.
- Triage and prioritize incoming maintenance work.

## Scope of Work

### Owns

- Bug fixes
- Security fixes
- Customer escalations
- Release activities
- Dependency upgrades
- CI/CD failures
- Test infrastructure issues
- Documentation fixes
- Backports
- Critical maintenance requests

### Does Not Own

- New feature development
- Large architectural changes
- Long-running RFEs (unless specifically reassigned)
- Product roadmap prioritization

## Roles

### Maintenance Pod Lead

The Maintenance Pod Lead is responsible for delivery coordination within the pod.

Responsibilities include:

- Lead planning and prioritization.
- Coordinate daily execution.
- Drive blocker resolution.
- Coordinate releases.
- Represent the pod during cross-pod discussions.
- Provide status updates to stakeholders.
- Partner closely with the Team Lead/Engineering Manager.

The Team Lead collaborates with the Maintenance Pod Lead to:

- Balance workload.
- Resolve priority conflicts.
- Escalate organizational risks.
- Ensure sustainable delivery.

## Scrum Ceremonies

### Sprint Planning

Attendees

- Maintenance Pod
- Scrum Master
- Product Owner (or backlog owner)
- Maintenance Pod Lead

Outputs

- Sprint goal
- Prioritized maintenance backlog
- Capacity allocation
- Risks and dependencies

### Daily Standup

Attendees

- Maintenance Pod

Focus

- Progress on active work
- Blockers
- New urgent requests
- Release readiness
- Cross-pod dependencies

### Weekly Backlog Refinement

Review:

- Newly reported defects
- Customer escalations
- Upcoming releases
- Technical debt
- Security work

### Sprint Review

Demonstrate:

- Bugs resolved
- Releases completed
- Reliability improvements

### Retrospective

Discuss:

- What worked well
- What caused interruptions
- Process improvements
- Handoff recommendations

## Recommended Recurring Meetings

| Meeting | Frequency | Owner |
|---|---|---|
| Daily Standup | Daily | Maintenance Pod |
| Backlog Refinement | Every 2 weeks | Maintenance Pod |
| Release Readiness | as needed | Pod Lead |
| Sprint Review | Weekly | Team |
| Retrospective | Every 2 weeks | Team |
| Maintenance Handoff | End of rotation | Outgoing & Incoming Pod Leads |

## Intake Process

1. New work is triaged.
2. Critical work is prioritized.
3. Product Owner confirms priority when needed.
4. Pod Lead assigns ownership.
5. Progress is tracked during standups.
6. Completed work is reviewed and released.

## End-of-Rotation Handoff

The outgoing Maintenance Pod should provide:

- Open work
- Outstanding blockers
- Release status
- Known risks
- Pending customer issues
- CI/CD concerns
- Operational notes

A short handoff meeting between outgoing and incoming pod members is recommended.

## Success Metrics

- Mean time to resolve defects
- Release predictability
- Customer escalation turnaround
- Backlog aging
- CI stability
- Security issue closure
- Percentage of planned maintenance completed

## Guiding Principles

- Protect feature pod focus whenever possible.
- Prioritize customer impact and system stability.
- Maintain transparency through regular communication.
- Keep operational knowledge documented.
- Leave the platform healthier at the end of every rotation.
