---
name: creating-skills
description: Use when wanting to turn a technique into a reusable skill, create a new skill, or make current work available for future sessions
---

# Creating Skills

Turn techniques into reusable skills for future sessions.

**Full methodology:** superpowers:writing-skills (TDD approach with testing)

## Decide: Project vs Global

| Scope   | Location                             | When                                           |
| ------- | ------------------------------------ | ---------------------------------------------- |
| Project | `.claude/skills/my-skill/SKILL.md`   | Project-specific patterns, commands, workflows |
| Global  | `~/.claude/skills/my-skill/SKILL.md` | Cross-project techniques (sync via chezmoi)    |

## SKILL.md Format

```markdown
---
name: my-skill
description: Use when [specific triggering conditions]
---

# My Skill

Brief overview - what this does.

## When to Use

- Specific symptoms or situations
- NOT: what the skill does (that goes in content)

## The Pattern / Steps

[Main content - technique, steps, reference]

## Common Mistakes

[What goes wrong + fixes]
```

## When to Use

- User says "make this a skill", "save this for later", "I want to reuse this"
- Technique worked well and applies beyond current project
- NOT: one-off solutions, project-specific conventions (use CLAUDE.md instead)

## Quick Create

```bash
# Project-local skill
mkdir -p .claude/skills/my-skill
$EDITOR .claude/skills/my-skill/SKILL.md

# Global skill
mkdir -p ~/.claude/skills/my-skill
$EDITOR ~/.claude/skills/my-skill/SKILL.md
```

## Sharing Global Skills with Other Agents

After creating a global skill, share via chezmoi symlinks. See update-chezmoi skill for full details.

```bash
# Add symlink for each agent that should have the skill
echo "/Users/nick/.claude/skills/my-skill" > \
  ~/.local/share/chezmoi/private_dot_codex/skills/symlink_my-skill
chezmoi apply
```

## Key Rules

1. **Description = when to use, never what it does** (Claude may skip reading if description summarizes workflow)
2. **Start description with "Use when..."**
3. **Name uses only letters, numbers, hyphens**
4. **One excellent example beats many mediocre ones**
5. **Test the skill** (see superpowers:writing-skills for full TDD methodology)

## After Creating

```bash
# Commit
git add .claude/skills/ && git commit -m "Add my-skill"

# For global skills, push dotfiles
cd ~/.local/share/chezmoi && git add -A && git commit -m "Add my-skill" && git push
```
