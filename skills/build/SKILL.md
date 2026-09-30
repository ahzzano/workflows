---
name: build 
description: multi-agent planning and building process
allowed-tools: read, write, edit, ls, bash
--- 

Skill used for planning, building, and implementing code or task

# Process 
1. Have scout agents read relevant parts of the codebase
2. Have a planner agent construct a plan then send it to the user 
3. Once the user approves the plan, have worker agents implement them 
4. Have an auditor agent audit the recent changes
5. Summarize the changes

# Guidelines 
1. If documentation/specs are available, always refer to them for correctness of implemention 

Output Format:

# Summary 
Summary of what you've done

# Changes 
1. 'path/to/file.rs' (Lines 67-69) - description of changes

