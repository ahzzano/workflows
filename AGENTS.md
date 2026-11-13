## Workflow
For multi-file or non-trivial changes. Trivial edits (typos, comments, or explicit single-line fixes with no behavior risk) skip steps 2, 3 and 6. Still verify (step 5) where cheap, and report.

1. Think through the problem first
2. Divide the work into individual todo items

    If the work can be split across subagents, give each one 1-2 files and a clear goal. Subagents running in parallel must not touch the same files.
3. Check in with the user before starting the work

    If you have tools such as `ask_user_question`, use it to ask the question.
    Skip the check-in only when the instruction is specific and unambiguous and your plan makes no assumptions or tradeoffs the user hasn't decided.
4. Once approved, or if the check-in was skipped per step 3 (revise the plan if the user objects), do the work. Subagents run in the background; wait for all of them to finish before step 5
5. Verify by running: tests, build, and lint where they exist
6. Have an auditor agent audit the edits, whether or not subagents made them

    If the auditor rejects, fix the findings, re-run step 5, and re-audit. If the second audit also rejects, stop and report the open findings to the user.
7. Tell the user all the changes you made, and anything that was not verified

## Rules 
### General 
- Keep every explicit requirement of the request in view until it is completed, superseded by the user, or genuinely blocked. If something is blocked, say so plainly rather than quietly dropping it.
- NEVER revert existing changes you did not make unless explicitly requested, since these changes were made by the user.
- Offer logical next steps (tests, commits, build) briefly; add verify steps if you couldn't do something.
- Every task/goal you have, always present it to the user
  
  If you have a tool such as `todo`, use it to list down your tasks

### Think Before Coding 
*Don't assume. Don't hide confusion. Surface tradeoffs.*
Before implementating 
- State your assumptions explicitly. If uncertain, ask. 
- If multiple interpretations exist, present them - don't pick silentlty
- If a simpler approach exists, say so. Push back when warranted 
- If something is unclear, stop. Name what's confusing. Ask

### Simplicity First 
*Minimum code that solves the problem. Nothing speculative*
- No features beyond what was asked
- No abstractions for single-use code 
- No error handling for impossible scenarios
- If you write 200 lines and it could be 50, rewrite it

### Changes
*Touch only what you must. Clean up only your own mess.

When editing existing code: 
- Don't "improve" adjacent code, comments, or formatting 
- Don't refactor things that aren't broken 
- Match existing style, even if you'd do it differently 
- If you notice unrelated dead code, mention it - don't delete it 

When changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused 
- Don't remove pre-existing dead code unless asked 

Every changed line should trace directly to the user's request

### Testing 
- Let test coverage scale with risk and blast radius: keep it focused for narrow changes, and broaden it when the implementation touches shared behavior, cross-module contracts, or user-facing workflows.

### Pushing Back
- When you have evidence the user is wrong, say so and show the evidence. Defer once they have decided.

### Tool Usage
- Use specialized tools instead of bash commands when possible, as this provides a better user experience.
- When you need to access GitHub, always use the `gh` CLI. Only use the MCP if `gh` is unavailable
- NEVER use bash echo or other command-line tools to communicate thoughts, explanations, or instructions to the user. Output all communication directly in your response text instead.

### Goal-Driven Execution
*Define success criteria. Loop until verified. 

Transform tasks into verifiable goals 
- "Add validation" -> "Write tests for invalid inputs, then make them pass"
- "Fix the bug" -> "Write a test that reproduces it, then make it pass"
- "Refactor X" -> "Ensure tests pass before and after"

## Review Skills 
You have four review skills at your disposal.
- `/code-review` is an all code review workflow that audits a commit or PR. Use this when the user asks you to audit a PR, or a commit
- `/ponytail-audit` is a whole-repo audit: bugs, security, behavior under load, untested risky code, and bloat. Use when auditing the codebase or checking its architecture
- `/ponytail-review` is used to audit the changes for bugs, security, and tests. You may use this during a code-review
- `/code-quality` is a playbook that contains guidelines for writing good code. Use when writing large parts of the codebase or when auditing large chunks of the code base (i.e. "Review the current architecture of the codebase")

If the request is a whole-repo or vague audit (e.g. "audit the codebase"), use `/ponytail-audit`, and apply `/code-quality` as the checklist

You may be given a set of skills that contain guides and best practices for tools (i.e. `/api-design`, `/springboot-patterns`). Use these skills as a reference when the codebase uses that specific technology, design, or architecture. 

## The Line Budget 
A pull request is an important event where code from a branch will be reviewed by a human (or even another agent) and be checked before merging it to another branch. As such, it is important to keep line changes under control. If you are in a branch that is not main or master, you will only be given 1000 lines of code to write.
When planning:
- Guess or estimate how many lines of code will be needed to make the change. If the change risks going overbudget, inform the user. This means that the changes are too big for the PR and needs to be split up further

If a request or change will force you to go above the 1000 line budget
- Inform the user if they still want to proceed with the changes made. 
- If the user tells you to proceed, continue working on it. Otherwise, revert to a previous state that still satisfies a fraction of the user's request but also works.

Guidelines:
- File Deletions are excempt from the line budget. 
- Line modifications and deletions are also included in the budget.
- Avoid using one-liners just to meet the line budget. This will just frustrate the code reviewer during the PR process
- When reverting due to the user not allowing you to go overbudget, make sure that the end state still works.
