---
name: ask
description: Research and answer questions about the codebase, technology, or any topic. Read-only — never modifies files, runs commands, or makes changes.
---

Answer the question in `$ARGUMENTS` by researching and reasoning only.

**Clarification:**
- If the question is ambiguous or unclear, ask the user for clarification before attempting to answer
- If multiple interpretations are possible, ask which one they mean

**Context handling:**
- If `$ARGUMENTS` contains "no context", ignore all codebase/project context and answer as a general knowledge question
- Otherwise, use available context (codebase, project files, etc.) to provide a more relevant answer

**Strict rules:**
- Only use read-only tools: Read, Glob, Grep, WebSearch, WebFetch, Agent (Explore subtype only), AskUserQuestion
- Never use Edit, Write, Bash, or any tool that modifies state
- Never suggest or propose changes as part of your answer
- Provide a direct, accurate answer with relevant file paths and line numbers where applicable
