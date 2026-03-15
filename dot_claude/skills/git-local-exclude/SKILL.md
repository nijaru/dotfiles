---
name: git-local-exclude
description: Use when keeping files local but out of git history (e.g., ai/, .tasks/, secrets). Use for removing files from git history while retaining them on disk without leaking patterns to .gitignore.
allowed-tools: Bash, Read, Grep, Glob
---

# Git Local Exclude

## 🎯 Core Mandates

- **Privacy First:** Use `.git/info/exclude` instead of `.gitignore` for personal or sensitive local files to avoid leaking their existence.
- **Verification:** Always verify files exist on disk (`ls`) before and after any destructive git operations (e.g., `filter-repo`).
- **Precedence:** Untrack files (`git rm --cached`) BEFORE applying history-rewriting tools.

## 🛠️ Implementation Standards

### 1. New Local Files (Untracked)
Immediately add patterns to the local exclude file:
```bash
echo "ai/" >> .git/info/exclude
echo ".tasks/" >> .git/info/exclude
```

### 2. Untracking Existing Files
Follow this exact sequence to remove from index without deleting from disk:
1. Add to `.git/info/exclude`.
2. Run `git rm -r --cached <path>`.
3. Verify file existence: `ls <path>`.
4. Commit the untracking: `git commit -m "chore: untrack local context"`.

### 3. History Removal (Sensitive Data)
Use only when data must be purged from all commits:
1. Perform the "Untracking" sequence above.
2. Run `git filter-repo --path <path> --invert-paths`.
3. Re-add remote: `git remote add origin <url>`.
4. Force push: `git push origin main --force`.

## 📋 Pattern Distinction

| File | Committed | Visible | Use Case |
| :--- | :--- | :--- | :--- |
| `.gitignore` | Yes | Yes | Shared: `node_modules/`, `*.pyc`, build artifacts. |
| `.git/info/exclude` | No | No | Private: `ai/`, `.tasks/`, personal notes, secrets. |

## ⚖️ Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll just use .gitignore for now." | This commits the pattern to history, leaking your private directory structure to the public repo. |
| "The files are already in history, so why bother?" | Untracking prevents future accidental leaks and reduces repo bloat for other contributors. |
| "filter-repo is too dangerous." | Manual untracking (`rm --cached`) is safe; history rewriting is only for secrets. |

## 🛠️ Troubleshooting

- **Remote missing:** `filter-repo` removes remotes as a safety measure; re-add with `git remote add`.
- **Files deleted:** If `ls` fails after `filter-repo`, check `.git/filter-repo/commit-map` for recovery.
- **Pattern ignored:** Ensure no leading slashes if matching relative to repo root (e.g., `ai/` not `/ai/`).
