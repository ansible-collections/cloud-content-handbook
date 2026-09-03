# Scrumban: How We Will Work

## 1. Why We’re Considering Scrumban

Today, our feature pods and Foundation Pod share one Scrum board and sprint cadence, even though they operate on different rhythms.

This creates a few challenges:

* A single sprint cadence does not fit all types of work equally well.
* Feature work and Foundation work have different levels of predictability and interruption.
* A shared velocity graph can be misleading because we are effectively comparing different types of work.
* Sprint commitments can create unnecessary overhead when priorities change during the sprint.

Scrumban gives us a middle ground between Scrum and Kanban.

The goal is to keep the practices that provide value to us - backlog refinement, estimation, reviews, and retrospectives - while allowing work to flow based on priority and capacity rather than being constrained by a fixed sprint commitment.

**This is a change in how we manage and visualize work. It is not a change to our expectations around ownership, quality, or delivery.**

---

## 2. What We Keep and What Changes

### We Keep

* A groomed and prioritized backlog
* Backlog refinement
* Story point estimation
* Periodic reviews
* Retrospectives
* Visibility into the team's work
* Jira as the source of truth
* Target dates for work where timing is important

### We Change

| Today                                      | Scrumban                                                  |
| ------------------------------------------ | --------------------------------------------------------- |
| Plan a fixed batch of work at sprint start | Pull the next prioritized item when capacity is available |
| Sprint scope is largely fixed              | Backlog can be reprioritized as priorities change         |
| Sprint commitment drives planning          | Flow and WIP limits guide how much work is active         |
| Sprint burndown and velocity               | Throughput and cycle time                                 |
| "Did we finish our sprint items?"          | "What is stuck, and how can we help move it through?"     |

We will **continue to estimate work using story points**.

Story points remain useful for two reasons:

1. The estimation conversation helps surface hidden complexity, dependencies, and differences in understanding.
2. Historical points can still be useful for forecasting.

---

# 3. How Work Will Flow


**New → Backlog (ToDo) → In Progress → Review → Done**

Scrumban changes how we manage work through this workflow; it does not require us to change the existing Jira statuses.

### New

New work enters the board here.

New items should be triaged and prioritized before moving into **Backlog (ToDo)**.

### Backlog (ToDo)

The backlog remains prioritized.

Refinement will continue to ensure that upcoming work:

* Has clear requirements
* Has known dependencies identified
* Has been estimated where appropriate
* Has a clear priority
* Wherever applicable target due date is set
* Is ready to be pulled when capacity becomes available

We do not need to pre-commit the contents of Backlog (ToDo) to a specific sprint.

### Pulling Work

When an engineer has capacity, they pull the highest-priority Ready item from **Backlog (ToDo)** into **In Progress**.

Instead of receiving a fixed batch of sprint work, work is pulled continuously based on priority and available capacity.

The goal is to **finish work before starting more work**.

### In Progress

Once work is pulled into In Progress, the focus is on moving it toward Done.

If work becomes blocked, the blocker should be made visible and the team should look for ways to help move the item forward.

### Review

Review becomes an important part of managing flow.

If work is accumulating in Review, the team should treat that as a flow problem and help move those items through rather than continuing to start additional work.

### Done

Completed work contributes to our throughput metrics.

Over time, this gives us a more realistic picture of how much work is actually flowing through the system.

---

# 4. WIP Limits

A core part of Scrumban is limiting Work in Progress (WIP).

The purpose of WIP limits is not to restrict productivity. It is to prevent the team from starting more work than it can reasonably finish.

## Team WIP Threshold

We will start with an overall **WIP threshold of 10 tickets**.

For this threshold, WIP means tickets currently in:

**10 in In Progress and 10 in Review**

The 10-ticket threshold is a **signal to inspect the flow**, not a hard productivity target.

If WIP crosses 10, we will pause and analyze what is contributing to the increase.

In particular, we will look at:

* How many of the active tickets are from the Foundation Pod
* Whether work is accumulating in In Progress or Review
* Whether there are blockers or dependencies preventing work from moving
* Whether we are starting more work than we are finishing
* Whether Review is becoming a bottleneck

### Foundation Pod Guardrails

Because Foundation Pod work has a different flow from feature work, we will also use specific guardrails for the Foundation Pod:

* **Maximum 10 Foundation Pod tickets in Backlog (ToDo)**
* **Maximum 3 tickets per person across Backlog (ToDo) + Review**

These are guardrails intended to prevent the Foundation Pod from building up an unnecessarily large queue of work while also ensuring that individual engineers do not have excessive work waiting in their queue or awaiting review.

They are **not individual performance targets**.

If a threshold is exceeded, the first step is to understand why.

For example:

* Is work blocked?
* Are too many items waiting for review?
* Is there a release or maintenance spike?
* Are priorities unclear?
* Are we pulling work faster than we can finish it?
* Is there a dependency outside the team's control?

We should address the underlying flow problem rather than treating the number itself as the problem.

### What We Do When WIP Is High

When the team-level WIP threshold is crossed, the default response is **not to start more work**.

Instead, we should focus on moving existing work through the workflow:

1. Review blocked or aging items.
2. Prioritize getting existing work to Done.
3. Help with items sitting in Review.
4. Identify dependencies or bottlenecks.
5. Reassess whether the current WIP limits are appropriate.

The question becomes:

> **"What is preventing us from finishing the work we already have?"**

rather than:

> **"What else can we start?"**

---

# 5. How We Will Handle Priorities

With Scrumban, priorities can change without requiring us to formally modify sprint scope.

The backlog should always reflect the current priorities.

When someone finishes an item and has capacity, they pull the next highest-priority Ready item.

This gives us flexibility to respond to:

* Urgent issues
* Changing organizational priorities
* Dependencies
* Release work
* Maintenance work
* New information discovered during implementation

The goal is not to constantly reshuffle work. The goal is to avoid being locked into a sprint plan when priorities genuinely change.

---

# 6. Due Dates and Time Expectations

Removing fixed sprint commitments does **not** mean that we stop setting expectations around timing.

Some work has known or expected timelines.

For example:

* Collection releases
* Maintenance activities
* Work tied to external events
* Work with known dependencies
* Other tasks where we have enough information to establish a reasonable completion timeframe

For those items, we can use Jira's **Target Due Date** field.

## How We Will Use Due Dates

A target date can be established:

* During backlog refinement, when we have enough information to estimate timing; or
* When an item is ready to be pulled into In Progress and the timing becomes clearer.

For example, collection release tickets are relatively well-understood work. We may reasonably expect a release, including associated backport cleanup, to be completed within a couple of weeks.

In those cases, having a target date provides useful visibility.

### Due Dates Are Targets, Not Sprint Commitments

The important distinction is that a Due Date is a **guardrail**, not an inflexible commitment.

If priorities change, a dependency appears, or the work turns out to be more complex than expected, we can adjust the target date and make the reason visible.

We should not add dates to every ticket simply for the sake of having a date. Dates should be used where they provide meaningful planning or coordination value.

---

# 7. Measuring Flow

Without sprint commitments, our primary metrics shift from sprint velocity and burndown toward flow-based metrics.

## Throughput

**Throughput = the number of items completed during a period of time.**

We can track:

* Number of items completed per week
* Story points completed per week

We will use a **rolling 4–6 week average** rather than reacting to a single week's number.

A single week can vary significantly due to:

* PTO
* Reviews
* Incidents
* Large or complex work
* Dependencies
* Release timing

The rolling average gives us a more useful picture of the team's actual delivery capability.

## Cycle Time

**Cycle time = the number of days an item takes to move from In Progress to Done.**

This helps us understand how long work is actually taking once it has started.

Jira's **Control Chart** can be used to monitor cycle-time trends.

We should pay particular attention to:

* Items with unusually long cycle times
* Increasing cycle times
* Patterns based on work type
* Work consistently getting stuck in a particular stage

## Cumulative Flow Diagram

We will use the **Cumulative Flow Diagram (CFD)** to understand where work is accumulating.

For example:

* Increasing In Progress may indicate that we are starting too much work.
* Increasing Review may indicate a review bottleneck.
* Increasing blocked work may indicate dependency or coordination problems.

The CFD helps us identify system bottlenecks rather than focusing only on individual tickets.

---

# 8. Review Cadence

We do not want metrics to create another reporting burden.

Instead, we will use a lightweight review cadence.

## Weekly

A quick check of:

* Throughput
* WIP
* Blocked work
* Items that appear stuck
* Upcoming Due Dates

The focus should be on identifying anything that needs attention.

## Every Two Weeks

We will look at:

* Cycle-time trends
* Cumulative Flow Diagram
* Throughput trends
* Recurring bottlenecks
* Whether WIP limits are working

This can happen alongside our existing review and retrospective cadence.

---

# 9. Forecasting

We can continue to use story points for forecasting.

A simple approach is:

**Remaining points ÷ rolling 4–6 week average throughput = rough completion estimate**

This will never be a precise delivery date.

It is a forecasting tool that becomes more useful as we collect more historical data.

The goal is to make better planning decisions based on actual delivery history rather than treating a sprint commitment as a prediction guarantee.

---

# 10. What Happens to Scrum Ceremonies?

Moving to Scrumban does not mean removing every Scrum ceremony.

We still need regular opportunities for:

* Standup updates
* Refinement
* Estimation
* Review
* Retrospective
* Prioritization

However, we should revisit whether all current meetings need to remain exactly as they are today.

One possible approach is:

## Backlog Refinement and Planning

Potentially combine sprint planning and backlog refinement into a single session.

The focus would be on:

* Reviewing priorities
* Ensuring sufficient Ready work
* Refining upcoming items
* Estimating work
* Identifying dependencies
* Setting target dates where appropriate

The goal is not to plan a fixed batch of work. The goal is to keep the system ready for continuous flow.

## Review

Continue periodic reviews of completed work and outcomes.

## Retrospective

The retrospective could potentially move into the regular team meeting rather than requiring a separate ceremony.

The exact structure should depend on whether combining meetings reduces overhead without reducing the value of the discussion.

---

# 11. Facilitation and the Scrum Lead Role

We do not necessarily lose the value that rotating Scrum Lead responsibilities provide today.

One of the benefits of serving as Scrum Lead is having an opportunity to:

* Stay connected to what the team is working on
* Maintain awareness across different areas
* Help facilitate team discussions
* Develop a sense of ownership and belonging beyond individual tickets

Those opportunities can continue in a Scrumban model.

We will still need someone to facilitate activities such as:

* Refinement
* Estimation
* Reviews
* Retrospectives
* Flow discussions

The role may evolve from a traditional Scrum Lead into more of a **flow/process facilitator**.

The facilitator can help:

* Maintain visibility into the board
* Surface blocked work
* Watch for WIP issues
* Ensure upcoming work is sufficiently refined
* Facilitate reviews and retrospectives
* Help the team identify process bottlenecks

We can continue rotating this responsibility if the team finds that it provides value.

The experiment will help us determine which parts of the current Scrum Lead role we want to retain.

---

# What We Will Watch During the Experiment

We will evaluate the experiment using both metrics and team feedback.

## Flow

* Is work moving through the board consistently?
* Are items getting stuck?
* Are bottlenecks easier to identify?

## WIP

* Are we starting too much work?
* Is work accumulating in In Progress or Review?
* Are WIP limits helping us finish work?
* How much of the team's WIP is Foundation Pod work?

## Predictability

* Are Due Dates useful where timing matters?
* Are we improving our ability to forecast?
* Are known types of work completing within expected ranges?

## Team Experience

* Does the team feel more flexible?
* Does the model create unwanted pressure?
* Do people still feel connected to the broader team's work?
* Are we preserving useful collaboration opportunities?

## Process Overhead

* Are our meetings still useful?
* Can we simplify ceremonies?
* Have we retained the useful parts of Scrum without keeping process for its own sake?

---

**The process should serve the team. The team should not serve the process.**

Async feedback is welcome throughout the experiment.

The goal is not to design the perfect process before we start.

The goal is to try a model, measure what happens, listen to the team, and adjust based on what we learn.

