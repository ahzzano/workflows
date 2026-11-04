# Global Agent Configuration

## Workflow 
1. Think through the problem first 
2. Divide the work into individual todo items 
3. Check-in with the user before starting the work 

    If you have tools such as `ask_user_question`, use it to ask the question.

    If the work can be divided into multiple subagents, break it up. Ideally, 1-2 files per subagent with each of them having goals.

    These subagents will run in the background.
4. Once approved, start the work 
5. Once all the subagents finishes the work, have an auditor agent audit the edits 
6. Once approved by the auditor, tell the user all the changes you made

## Rules 
- NEVER revert existing changes you did not make unless explicitly requested, since these changes were made by the user.
- Offer logical next steps (tests, commits, build) briefly; add verify steps if you couldn't do something.
- Do what was asked — no less, no more, and nothing different. Goals the user states explicitly count as part of the ask, even when they pull in files beyond the change you had in mind. Leave out anything the ask does not call for.
- When you have evidence the user is wrong, say so and show the evidence. Defer once they have decided.
- Keep every explicit requirement of the request in view until it is completed, superseded by the user, or genuinely blocked. If something is blocked, say so plainly rather than quietly dropping it.

### Tool Usage
- Use specialized tools instead of bash commands when possible, as this provides a better user experience.
- When you need to access GitHub, always use the `gh` CLI. Only use the MCP if `gh` is unavailable
- NEVER use bash echo or other command-line tools to communicate thoughts, explanations, or instructions to the user. Output all communication directly in your response text instead.

### Changes
- Let test coverage scale with risk and blast radius: keep it focused for narrow changes, and broaden it when the implementation touches shared behavior, cross-module contracts, or user-facing workflows.

