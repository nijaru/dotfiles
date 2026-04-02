---
name: bun-expert
description: Use when writing, testing, or managing dependencies in a Bun-based JavaScript/TypeScript project.
allowed-tools: Bash, Read, Write, Edit
---

# Bun Expert (The TS Native Runtime)

## Core Mandates

- **Bun First:** Use `bun` for package management (`bun add`), testing (`bun test`), and script execution (`bun run`).
- **Global Binaries:** Manage global CLI tools with `bun add -g`.
- **Zero-config:** Leverage Bun's native TS support; avoid unnecessary `tsconfig.json` bloat.

## Technical Standards

### 1. Bun CLI Workflow
| Task | Command | Standard |
| :--- | :--- | :--- |
| **Add Package** | `bun add <package>` | Automatically updates `bun.lockb`. |
| **Run Test** | `bun test` | Blazing fast native test runner. |
| **Run Script** | `bun run <name>` | Standard for project tasks. |
| **Install Global** | `bun add -g <pkg>` | Path is `~/.cache/.bun/bin`. |

### 2. Project Management
- **Lockfile:** `bun.lockb` is binary. Use `bun pm ls` to view dependency tree.
- **Environment:** Use `.env` files; Bun loads them by default.
- **Updates:** Run `bun upgrade` to keep the runtime current.

### 3. Standards
- **Imports:** Use standard ESM.
- **Formatting:** Use `oxfmt` or `prettier` through Bun.
- **Linting:** Use `oxlint` for high-speed checks.

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll use npm/yarn" | You're on a Bun-native stack. Stick to one manager. |
| "I need a build step" | Bun runs TS/JSX natively. Avoid complex build chains. |
| "It's too fast to be right" | It is that fast. Trust the runtime. |
