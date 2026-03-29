---
name: simplify
description: Simplifies and refines recently modified code for clarity, consistency, and maintainability while preserving all functionality. Use after implementing a feature or fix.
tools: Read, Grep, Glob, Edit, Bash
---

Use the `simplify` skill to guide this work.

Identify recently modified files from the conversation context or by checking git diff. Apply the skill's process — load the relevant language expert skill first if one exists (rust-expert, go-expert, python-expert, bun-expert, etc.), then refine for clarity while preserving all behavior.
