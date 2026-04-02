---
name: git-history-purge
description: Use when purging sensitive data, large files, or private content from the full git history.
allowed-tools: Bash, Read
---

# Git History Purge (Gold Standard)

## Core Mandates

- **No Half-Measures:** Simply deleting a file in a new commit is not a purge. You must wipe the history.
- **Sign & Align (Mandatory):** Rewriting history destroys signatures and "Committer" dates. You MUST re-sign and align dates to maintain project integrity and "Verified" status.
- **Verify Before Push:** Always check signatures and dates (git log -n 5 --format=fuller --show-signature) before force-pushing.

## Implementation Standards

### 1. The Purge Sequence

1. **Backup:** Ensure the file/folder you want to keep is backed up or untracked (git rm --cached).
2. **Scrub:** Run git filter-repo --path <path> --invert-paths --force.
3. **Restore Remote:** git remote add origin <url>.

### 2. The Gold Standard (Re-sign & Fix Dates)

Rewriting history creates a brand-new commit tree. Use this command to re-apply cryptographic signatures while force-syncing committer dates to original author dates. This is CRUCIAL for maintaining "Verified" status and correct GitHub activity history:
\`\`\`bash
git rebase --root --rebase-merges --exec 'GIT_COMMITTER_DATE="\$(git log -1 --format=%aI)" git commit --amend --no-edit -n -S'
\`\`\`

## Verification Checklist

| Check             | Command                       | Expected                  |
| :---------------- | :---------------------------- | :------------------------ |
| **Path Purged**   | git log --all -- <path>       | (Empty)                   |
| **Dates Aligned** | git log -n 5 --format=fuller  | AuthorDate == CommitDate  |
| **Signed**        | git log -n 5 --show-signature | Valid signature (GPG/SSH) |

## Anti-Rationalization

| Excuse                     | Reality                                                                                       |
| :------------------------- | :-------------------------------------------------------------------------------------------- |
| "The date doesn't matter." | Seeing 100 commits from "2 minutes ago" on GitHub activity graphs looks suspicious or broken. |
| "I don't need to sign."    | Losing "Verified" status on the entire project history removes a key layer of trust.          |
| "Force push is scary."     | It is necessary for historical purges. Just verify your work locally before pushing.          |
