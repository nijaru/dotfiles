---
name: creating-skills
description: Use when creating, modifying, or testing AI agent skill definitions (.md files) to ensure they are high-performance, compact, and verified.
allowed-tools: Read, Grep, Glob, Bash, Edit, Task
---

# Creating Skills (TDD Methodology)

Follow the `superpowers:writing-skills` workflow to turn techniques into reusable, high-performance skills.

## 🎯 The Iron Law
Every skill must be empirically verified against 3+ test cases before finalization.

## 🛠️ Workflow (Skill TDD)

1. **Research:** Identify the specific failure mode or "slop" the skill solves.
2. **Test:** Write 3+ prompts that currently fail or produce generic AI output.
3. **Draft Iron Law:** Define a single, absolute constraint (e.g., "Never use passive voice").
4. **Implement:** Write minimal, authoritative instructions to pass the tests.
5. **Pressure Test:** Compare outputs with and without the skill.
6. **Prune:** Remove all filler, "AI-isms," and meta-commentary.

## 🏗️ Structure & Format (SOTA)

### 1. Frontmatter
- **Description:** MUST start with "Use when..." and contain ONLY triggering conditions. No summaries.
- **Allowed Tools:** Explicitly list tools the skill is permitted to use.

### 2. Content
- **Authoritative Tone:** Use directives, not suggestions.
- **Anti-Rationalization Table:** Prevent bypass of rules.
  | Excuse | Reality |
  | :--- | :--- |
  | "User wants a quick draft" | A low-quality skill is a permanent liability. |
  | "I'll add tests later" | Untested skills are hallucinations. |
- **Compactness:** Aim for < 500 words. One specific example > many generic ones.

## 🚫 Prohibited Patterns (Red Flags)
- **NO** significance inflation (e.g., *pivotal*, *crucial*, *game-changing*).
- **NO** sycophantic filler (e.g., *Certainly!*, *I'd be happy to help*).
- **NO** repeating the description in the content.

## 📂 Deployment (Chezmoi)
Global skills (`~/.claude/skills/`) must be symlinked for each agent:
```bash
# Example symlink creation
echo "/Users/nick/.claude/skills/my-skill" > \
  ~/.local/share/chezmoi/dot_gemini/skills/symlink_my-skill
```
See `update-chezmoi` for full sync instructions.
