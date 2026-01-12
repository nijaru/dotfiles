---
description: Initialize AI agent context management for project.
---

# AI Context Setup

Initialize AI agent context management for project.

**Philosophy:** Session files (<500 lines, current only) + Reference subdirs (on-demand) = token efficiency

## 1. Detect Project Info

| Item        | Detection Sources                                            |
| ----------- | ------------------------------------------------------------ |
| Name        | git remote, package.json, Cargo.toml, pyproject.toml, go.mod |
| Language    | File extensions (.rs/.py/.ts), package managers              |
| Framework   | package.json deps, Cargo.toml deps, imports                  |
| Commands    | package.json scripts, Makefile, Cargo.toml, justfile         |
| Description | README first paragraph                                       |

## 2. Handle Existing Config

| Scenario               | Action                                                   |
| ---------------------- | -------------------------------------------------------- |
| Neither exists         | Create AGENTS.md + symlink CLAUDE.md -> AGENTS.md        |
| Only AGENTS.md         | Add symlink CLAUDE.md -> AGENTS.md                       |
| Only CLAUDE.md         | Rename -> AGENTS.md + create symlink                     |
| CLAUDE.md -> AGENTS.md | Update content if needed                                 |
| Both files             | Merge -> AGENTS.md, remove old CLAUDE.md, create symlink |

## 3. Create Structure

```bash
mkdir -p ai/research ai/design ai/tmp
echo '*' > ai/tmp/.gitignore
tk init  # Initialize task tracking
```

## 4. ai/ Structure

| Project Size | Files                     | Subdirs                  |
| ------------ | ------------------------- | ------------------------ |
| Minimal      | STATUS.md                 | tmp/                     |
| Standard     | +DESIGN.md, +DECISIONS.md | research/, design/, tmp/ |
| Complex      | +ROADMAP.md               | research/, design/, tmp/ |

## 5. Create AGENTS.md

Include:

- Project overview (detected description)
- Structure table
- AI context organization
- Tech stack table
- Commands (build/test/run)
- Verification steps
- Code standards
- Current focus pointers

Create symlink: `ln -s AGENTS.md CLAUDE.md`

## 6. Verify & Report

```
## AI Context Setup Complete

**Project detected:**
- Name: [detected]
- Language: [detected]
- Framework: [detected]
- Size: [minimal/standard/complex]

**AGENTS.md:** [X] lines
- Symlink: CLAUDE.md -> AGENTS.md

**ai/ structure:**
- STATUS.md
- DESIGN.md: [created / skipped]
- DECISIONS.md: [created / skipped]
- Subdirs: research/, design/, tmp/
- Task tracking: .tasks/ (tk init)

**Next:**
1. Update ai/STATUS.md with current state
2. Add tasks: `tk add "task title"`
3. Commit: `git add . && git commit -m "Initialize AI context"`
```
