---
name: research
description: Create a subagent that does research from first-hand sources. Use whenever the user wants a topic researched, docs, or API facts gathered, or reading legwork delegated to a background subagent
---

Spin up a background `researcher` agent to do the research, so you keep working while it reads. Start it with a fresh context window.

Always use first-hand sources. Avoid second-hand sources at all costs

A first-hand source is a direct piece of evidence about a topic

Examples of first-hand sources:
1. Official docs 
2. Official source code (if provided)
3. Research papers / articles
4. Specs
5. First-party APIs

Guidelines:
- Always cite your sources 

    When citing, always include the URL to the source.

- Prefer to use direct quotation of the source material over summarizing.

    Using a direct quotation prevents the user from losing information when summarizing

    You may summarize/paraphrase the original source if the direct quote is 
    - Too long (more than 2 paragraphs long)
    - Uses a lot of domain specific jargon (before summarizing this to the user, ask the user if they are knowledgable about the domain of the topic)

- If the repo has established conventions, always match the findings to those conventions
