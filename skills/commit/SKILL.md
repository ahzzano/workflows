---
name: commit
description: Commit all items step-by-step
compatibility: Requires Git `git`
allowed-tools: Bash(git:*) Read
---

# Better Commit 
Use only Git commands and file-reading tools for this workflow; do not edit files.
Stage all changes in a git repository as a series of different bite-sized checkpoints. 
Each checkpoint must correspond to a small meaningful change that can be reviewed by the user.

# Process

1. Break the changes down into small bite-sized checkpoints
    - Each checkpoint must be one meaningful change
    - Keep the repository in a consistent state
    - Do not split changes into granular checkpoints because they can be separated. Each chunk must be coherent 
    - The sequence of checkpoints should tell the story of the work
    - Also include hunks as well
2. Move the checkpoint to the staging area
3. Present a summary of changes for the user 
    - Include a conventional commit title
    - Include a summary of changes 
4. Wait for the user to commit the files in the staging area
    - Do not run `git commit` directly unless specified. The user will have to commit the changes
5. After the user commits, inspect the remaining changes and move to Step 2. Continue until no pending changes remain

# Guidelines
- Do NOT stage every change as one commit. Always break down the change meaninfully
- Do not create commits on the user's behalf unless specified
- Do not go a directory above the current directory
- Avoid excessive details in the summary
- Do not stage any file containing an API key. Inform the user if you found one

# Conventional Commit Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- Description: Max 50 characters. No period
- Scope: affected feature 
- Body: must explain why (not just what), can be in prose or bullet points (concise and high-level)

## Allowed Types

| type | description|
| --- | --- | 
| feat | new feature |
| fix | bug fixes |
| chore | tooling and deps | 
| docs | documentation changes | 
| refactor | code restructure | 
| perf | performance improvements | 
| test | adding or refactoring tests | 

