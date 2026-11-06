---
name: to-spec
description: Turn the current conversation into a spec and publish it to the project issue tracker.
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec. Do NOT interview the user; just synthesize what you already know.

# Process 

1. Explore the repo to understand the current state of the codebase. 
2. Sketch out the seams you will be using to test out a feature. Prefer to use existing seams over new ones

  If you need new seams, propose them at the highest point you can
3. Check with the user that these seams match their expectations.
4. Write the spec using the template provided, then publish it to the project issue tracker. If no tracker is setup, write it to `SPEC.md` instead

# Output Format 

```md
# Problem Statement 
The problem that the user is facing, from their perspective 

# Solutions
The solution to the user's problems

# User Stories 
A LONG list of user stories. Each story must be in the format of 
1. As a ..., I want to ..., so that ...

Ex. "As a bank customer, I want to withdraw cash, so that I can pay for food"

# Implementation Details
A list of implementation decisions that were made. This can include:
- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

# Testing 
A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

# Out of Scope 
A description of the things that are out of scope for this spec.

# Further Notes
Any further notes about the feature.
```
