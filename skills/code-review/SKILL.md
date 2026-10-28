---
name: code-review 
description: Conduct a code review for a pull request or commit
allowed-tools: Bash(gh issue view:*) Bash(gh search:*) Bash(gh issue list:*) Bash(gh pr comment:*) Bash(gh pr diff:*) Bash(gh pr list:*) Read
---

Provide a code review for a given pull request or commit

# Assumptions 
- All tools are functional and will work without error, don't test any tools 
- Every tool call must have a clear purpose. Only call when it is required to complete the task
- The code was ran through a linter or LSP

# Guidelines
- Prefer to use the github cli (`gh *`) over the GitHub MCP
- Create a todo list before starting 
- Always cite and link each issue in the comments 

# Steps 
1. Launch `scout` agents to check if any of the following is true 
    - The PR is closed 
    - The PR is a draft 
    - The PR does not need a code review (trivial change that is obviously correct)

    If any of the above is true, stop and do not procede

2. Launch haiku scout agents to return a list of file paths for all `AGENTS.md` files including:
    - The root `AGENTS.md` file 
    - Any nested `AGENTS.md` files

3. Launch a `scout` agent to view the pull request and return a summary of changes 

4. Launch auditor agents to independently review the changes. 
    
    Agent 1: Opus Auditor for obvious code bugs 
    Scan for obvious bugs. Focus only on the diff itself without reading extra content. Flag only significant bugs; ignore nitpicks and likely false positives. Do not flag issues that you cannot validate without looking at context outside the git diff

    Agent 2: Opus Auditor for the introduced code
    Look for problems that exist in the introduced code such as security issues, incorrect logic, etc. Only look for issues that fall within the changed code

    Agent 3: Sonnet Auditor for requirement compliance 
    If the requirements for a PR are given (i.e. a DOD), check if the implemented code accomplishes the DOD.

    DO NOT FLAG:
    - Code style / quality concerns 
    - Potential issues that depend on specific inputs / state
    - Subjective suggestions or improvements 

    If you are not certain an issue is real, do not flag it

    Each subagent should be told the PR title and description

5. For each issue found in step 4. launch parallel subagents to validate the issue. These subagents should get the PR title and description of the issue

6. Remove issues that were not validated in step 5. The remaining issues are high signal issues for our review

7. Output a summary of the review findings 
    - State if the PR is approved for merging or not
    - If issues were found, list each issue with a brief description and relevant files 
    - If no issues were found, state: "No issues found. Checked for bugs"

# False Positives
Consider the list when evaluating for false positives in steps 4 and 5
- Pre-existing issues 
- Something that appears to be a bug but is actually correct 
- Something a linter should catch 
