---
name: review
description: Use when performing deep code analysis for correctness, safety, quality, or to simplify recently modified code. Trigger on feature completion, unpushed commits, or before merging significant changes.
allowed-tools: Bash, Read, Grep, Glob, Edit, Task
---

# Review (Audit & Refine)

Analyze code for correctness, safety, and efficiency. This skill supports two modes: **Report** (analysis only) and **Refine** (apply improvements).

## 🎯 Core Mandates

- **Evidence-First:** Establish a baseline by running tests BEFORE the review.
- **Single-Pass:** Evaluate all categories (Correctness, Complexity, Quality, Efficiency, Cleanliness) in one pass.
- **Standards:** Strictly follow the `Code Standards` table in `CLAUDE.md`.
- **Mode Selection:**
    - **Report:** Output a categorized report (`ERROR`, `WARN`, `NIT`). End with `Verdict: LGTM`, `LGTM with nits`, or `Needs work`.
    - **Refine:** Apply targeted, behavior-preserving changes to improve clarity and reduce technical debt.

## 🛠️ Execution Workflow

1. **Scope:** Detect modified files, feature branch diffs, or staged changes.
2. **Baseline:** Run `build` and `test` to establish a "Green" starting state.
3. **Analyze:** Apply the `Code Standards` (referencing `CLAUDE.md`).
4. **Action:**
    - **Report Mode:** Generate findings formatted as `[SEVERITY] file:line - Issue -> Fix`.
    - **Refine Mode:** Edit files surgically. Use language-expert skills (`rust-expert`, etc.) for idiomatic patterns.
5. **Verify:** Run tests/linter after refinement to ensure behavior is unchanged.

## ⚖️ Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "Tests passed, so it's fine." | Reviews catch architectural flaws and security risks that tests miss. |
| "Refining might break it." | Small, behavior-preserving edits with Red-Green verification are safe and essential. |
| "Subagents are always better." | For small or local changes, the main agent is more efficient. Use subagents for context isolation. |
