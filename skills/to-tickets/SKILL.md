---
name: to-tickets
description: Break a plan, spec, design, or current conversation into a set of tracer-bullet tickets. 
disable-model-invocation: true
---

# To Tickets
Break a plan, spec, or conversation into a set of tickets: tracer-bullet vertical slices, each declaring the tickets that block it.

# Process 
1. Gather Context 

  Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

2. Explore the Codebase 

3. Draft Vertical Slices 

  Break the work into bullet points that cut through every layer
  - All layers (i.e. APIs, UI, tests, etc.). AVOID horizontal slices (i.e. only the UI for this PR)
  - A complete slice must be presentable as a demo on it's own
  - Each slice must fit into one context window
  - Any pre-factoring should be done first

  Give each ticket it's dependency ticket. A dependency is a ticket that is blocking the current ticket
  
  Exceptions:
  1. Wide Refactoring - refactors that affect the entire codebase. 

4. Quiz the User

  Present the proposed breakdown as a list. For each ticket, show 

  - Title: Short title 
  - Blocked by: which other tickets (any) needs to be completed first
  - What it delivers: the end-to-end behavior this ticket expects to work
  - Affected: the layers that are expected to be affected by the ticket

  Ask the user
  1. Are the dependencies correct? 
  2. Should any ticket be merged/split further?

5. Publish the tickets

  If the user has not yet configured the tracker, ask them first. If they don't, default to writing the ticket in `docs/tickets/tn_ticket_name.md`

  If there is a tracker, publish it there instead. 

  See [template.md](template.md) for a sample ticket