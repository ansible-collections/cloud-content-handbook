# Foundation Pod Operating Guide

## Purpose

The Foundation Pod is a rotating, six-week pod responsible for maintaining the health, stability, and release readiness of the team's supported content, while feature pods advance the product roadmap. Both are essential to delivering value customers can depend on.

The Foundation Pod is accountable for operational excellence, the maintenance and release processes, and ensuring the team can continue delivering high-quality software.

## Objectives

- Resolve customer-reported defects.
- Address security and blocker issues.
- Deliver planned patch and collection releases.
- Reduce technical debt as capacity allows, once higher-priority objectives in this list are covered (see [Roles](#roles) for how this is decided).
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

### Foundation Pod Lead

The Foundation Pod Lead is responsible for delivery coordination within the pod.

Responsibilities include:

- Lead planning and prioritization.
- Coordinate daily execution.
- Drive blocker resolution.
- Coordinate releases.
- Represent the pod during cross-pod discussions.
- Provide status updates to stakeholders.
- Partner closely with the Team Lead/Engineering Manager.

The Team Lead collaborates with the Foundation Pod Lead to:

- Balance workload.
- Resolve priority conflicts.
- Escalate organizational risks.
- Ensure sustainable delivery.
- Decide which technical debt items are in scope for the rotation. Technical debt work is taken on only after customer-reported defects, security/blocker issues, and planned releases are on track, and only if it can be completed within the six-week rotation without putting those higher-priority objectives at risk.

## ScrumBan

### Refinement, Prioritization & Planning

Review:

- Newly reported defects
- Customer escalations
- Upcoming releases
- Technical debt
- Security work

Attendees:

- Foundation Pod
- Team Lead
- Manager

Outputs:

- Prioritized backlog
- ToDo items
- Risks and dependencies

### Daily Standup (async via Slack)

Attendees:

- Foundation Pod

Focus:

- Progress on active work
- Blockers
- New urgent requests
- Release readiness
- Cross-pod dependencies

### Review

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
| Daily Standup | Daily | Foundation Pod |
| Backlog Refinement | Every 2 weeks | Foundation Pod |
| Release Readiness | as needed | Pod Lead |
| Review | Weekly | Team |
| Retrospective | Every 2 weeks | Team |
| Foundation Pod Handoff | End of rotation | Outgoing & Incoming Pod Leads |


## End-of-Rotation Handoff

The outgoing Foundation Pod should provide:

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

- Absorb incoming interrupts so both pods can stay focused on their committed work.
- Prioritize customer impact and system stability.
- Maintain transparency through regular communication.
- Keep operational knowledge documented.
