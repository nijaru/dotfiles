---
name: codex
description: Use when needing agentic codebase review or second AI opinion where the agent must walk the repo autonomously without pasting code. Ideal for pre-release review, complex bug analysis, or validating invariants across a codebase.
allowed-tools: Bash, Read, Grep, Glob
---

# Codex (Agentic Review)

## 🎯 Core Mandates

- **Autonomy:** Use Codex to walk the repo instead of pasting files. It excels at finding bugs across multiple files.
- **Precision:** Be specific about invariants (e.g., "RecordStore::set() is NOT idempotent").
- **Persistence:** Always use `-o <file>` to capture the final model response for synthesis.

## 🛠️ Sandbox Standards

| Mode | Flag | Application |
| :--- | :--- | :--- |
| Workspace-write | `--full-auto` | Default; current working directory. |
| Danger Access | `-s danger-full-access` | When system paths must be read. |
| No Sandbox | `--dangerously-bypass-approvals-and-sandbox` | Cross-repo (`../`) or outside workspace. |

**Constraint:** If reviewing code in `../`, you MUST use `--dangerously-bypass-approvals-and-sandbox -C /absolute/path/to/repo`.

## 📋 Execution Patterns

### 1. Code Review
```bash
# Review a specific commit
codex review --commit <sha>

# Review changes against base branch
codex review --base main

# Review with custom instructions
codex review "Focus on persistence correctness and invariant violations" -o /tmp/codex-review.txt
```

### 2. Freeform Analysis
```bash
# Ask about codebase (piped input)
echo "Review src/vector/store/ for recovery path bugs" | codex exec --full-auto -o /tmp/codex-reply.txt
```

## ⚖️ Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll just paste the code into the chat." | Pasting loses deep context and cross-file dependencies that Codex can trace. |
| "It's too slow for a quick check." | Accuracy in complex systems requires thoroughness. Use parallel execution if speed is critical. |
| "I don't need an output file." | Without `-o`, the agent's findings are lost to the ephemeral terminal buffer. |

## 🛠️ Troubleshooting

- **No output:** Ensure `-o` is used; it saves the *last* model message.
- **Permission denied:** Use the bypass flags for files outside the immediate project root.
- **Timeouts:** Break deep analysis into focused sub-questions per directory or module.
