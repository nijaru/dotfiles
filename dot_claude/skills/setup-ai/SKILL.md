---
name: setup-ai
description: Use when initializing or migrating AI agent context management (AGENTS.md, ai/ structure) for a project.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

# Setup AI Context

Initialize or migrate project-specific AI context management. Prioritize token efficiency and machine-readability.

## 🎯 Mandates

- **Efficiency:** Session files must stay < 500 lines. Move details to reference subdirs.
- **Tracking:** Initialize `tk` CLI for all project tasks.
- **Consistency:** `CLAUDE.md` MUST be a symlink to `AGENTS.md`.

## 🛠️ Execution Standards

### 1. Detection Phase
Read these in parallel to gather project intelligence:
- **Identity:** `git remote`, `README.md` (first paragraph).
- **Stack:** `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`.
- **Infrastructure:** `Makefile`, `justfile`, `.claude/settings.json`.

### 2. Configuration Handling
| Scenario | Action |
| :--- | :--- |
| Neither file exists | Create `AGENTS.md`, symlink `CLAUDE.md` -> `AGENTS.md`. |
| Only `CLAUDE.md` | Rename to `AGENTS.md`, create symlink. |
| Both exist | Merge to `AGENTS.md`, remove old `CLAUDE.md`, create symlink. |

### 3. Structure Initialization
```bash
mkdir -p ai/research ai/design ai/tmp
echo '*' > ai/tmp/.gitignore
tk init  # Initialize task tracking
```

### 4. File Standards
- **ai/STATUS.md:** Current state, metrics, active work. Update EVERY session.
- **ai/DESIGN.md:** High-level architecture and component mapping.
- **ai/DECISIONS.md:** Append-only log of architectural choices and rationales.
- **AGENTS.md:** The "Source of Truth." Use tables for stack, commands, and verification steps.

## 🚫 Anti-Rationalization
| Excuse | Reality |
| :--- | :--- |
| "It's a small project" | Inconsistent structure leads to context drift in 3 sessions. |
| "I'll update STATUS.md later" | Stale context is the primary cause of agent hallucinations. |

## 📦 Verification
1. `ls -la AGENTS.md CLAUDE.md` (Verify symlink).
2. `tk ready` (Verify task tracking).
3. `ls -R ai/` (Verify directory structure).
