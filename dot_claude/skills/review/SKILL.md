---
name: review
description: Use when performing deep code analysis for correctness, safety, and quality. Trigger on feature branch completion, unpushed commits, or before merging significant architectural changes.
allowed-tools: Bash, Read, Grep, Glob, Edit, Task
---

# Code Review (Surgical Analysis)

## 🎯 Core Mandates

- **Fresh Eyes:** Use a `reviewer` subagent for unbiased analysis of complex changes.
- **Evidence-First:** Run existing tests BEFORE starting the review to establish a baseline.
- **Precision:** Only flag issues with >80% confidence. Avoid false positives.
- **Actionable:** Every finding must include a clear fix or a before/after refactoring example.

## 🛠️ Review Standards

### 1. Correctness & Safety
- **Logic:** Check for off-by-one errors, boundary conditions, and state consistency.
- **Security:** Identify hardcoded secrets, injection risks (SQL/command/path), and improper input validation.
- **Error Handling:** Flag swallowed errors (empty `catch`), silent failures, and missing resource cleanup.

### 2. Quality & Architecture
- **Idiomatic Code:** Ensure alignment with language-specific patterns (e.g., Rust's `String` vs `&str`).
- **Complexity:** Flag functions >40 lines, nesting >3, or files >400 lines.
- **Smells:** Detect duplication, feature envy, primitive obsession, and dead code.
- **Performance:** Identify O(n^2) logic where O(n) is possible or blocking I/O in async paths.

## 📋 Execution Workflow

1. **Scope Detection:** Prioritize specific user files, then feature branch diffs, then staged changes.
2. **Baseline:** Execute `build` and `test` to verify current state.
3. **Analyze:** Launch a `reviewer` subagent with the full checklist.
4. **Synthesize:** Report findings categorized by `ERROR` (Must fix), `WARN` (Should fix), and `NIT` (Optional).

## ⚖️ Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "It's a minor change; no review needed." | Minor changes often hide subtle regressions and edge-case logic failures. |
| "The tests passed, so it's fine." | Tests only verify known paths; reviews identify architectural flaws and unknown risks. |
| "I'll do a full review after the PR." | Post-merge reviews are rarely prioritized; technical debt starts with "just this once." |

## 🛠️ Output Standards

- **Severity:** `ERROR` (Critical/Security), `WARN` (Important/Smells), `NIT` (Style).
- **Format:** `[SEVERITY] file:line - Issue -> Fix/Before-After`.
- **Verdict:** Must end with `LGTM`, `LGTM with nits`, or `Needs work`.
