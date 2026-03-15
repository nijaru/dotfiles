---
name: git-local-exclude
description: Use when keeping files local but out of git history — ai/, .tasks/, notes/, secrets, or any personal context files that should never appear in commits or on GitHub. Also use when asked to remove files from git history while keeping them on disk.
---

# Git Local Exclude

Keep files on disk without ever committing them. Uses `.git/info/exclude` (never `.gitignore`).

## When to Use

- User wants `ai/`, `.tasks/`, notes, or personal context excluded from a public repo
- User says "keep local but not in git", "don't commit this", "remove from history"
- You are about to add local-only patterns to `.gitignore` — stop, use exclude instead

## The Key Distinction

| File                | Committed | Shared with team | Use for                                                  |
| ------------------- | --------- | ---------------- | -------------------------------------------------------- |
| `.gitignore`        | Yes       | Yes              | Project-wide ignores (build artifacts, secrets patterns) |
| `.git/info/exclude` | **No**    | **No**           | Personal local files (ai/, .tasks/, notes/)              |

**Never put personal local patterns in `.gitignore`.** That commits them to history and shares them.

## Pattern A: New files (never tracked)

Just add to `.git/info/exclude`:

```bash
echo "ai/" >> .git/info/exclude
echo ".tasks/" >> .git/info/exclude
```

Files are immediately ignored locally. Done.

## Pattern B: Already-tracked files — untrack without deleting

```bash
# 1. Add to local exclude FIRST
echo "ai/" >> .git/info/exclude
echo ".tasks/" >> .git/info/exclude

# 2. Untrack (remove from git index, keep files on disk)
git rm -r --cached ai/ .tasks/

# 3. Verify files still exist on disk before committing
ls ai/ && ls .tasks/

# 4. Commit the untrack
git commit -m "chore: untrack local context directories"
git push
```

Files remain on disk. Future commits ignore them. History still contains old commits with the files — acceptable for most cases.

## Pattern C: Remove from history entirely (nuclear)

Only do this if the files contain sensitive data that must not appear in any commit.

**CRITICAL: Verify files exist locally BEFORE running filter-repo. It will delete tracked files from disk.**

```bash
# 1. Untrack and commit first (Pattern B above) — this is your safety net
git rm -r --cached ai/ .tasks/
git commit -m "chore: untrack local context directories"

# 2. Verify files still on disk
ls ai/ && ls .tasks/   # Must succeed before continuing

# 3. Add to exclude
echo "ai/" >> .git/info/exclude
echo ".tasks/" >> .git/info/exclude

# 4. Rewrite history (removes the remote — expected behavior)
git filter-repo --path ai/ --path .tasks/ --invert-paths

# 5. Re-add remote and force push
git remote add origin <url>
git push origin main --force

# 6. Verify files still on disk (again)
ls ai/ && ls .tasks/
```

## Common Mistakes

| Mistake                                             | Consequence                                                          | Fix                                             |
| --------------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------------------- |
| Adding to `.gitignore` instead of exclude           | Pattern committed, shared with team                                  | Revert that commit, use exclude                 |
| Running `filter-repo` before untracking             | filter-repo checks out new HEAD, **deletes tracked files from disk** | Always untrack + commit first                   |
| Running `filter-repo` without verifying local files | Data loss if objects are GC'd                                        | Check `ls` before every destructive step        |
| Force pushing without re-adding remote              | filter-repo removes remote as safety measure                         | `git remote add origin <url>` after filter-repo |

## Check Current Exclude

```bash
cat .git/info/exclude
```

## Recovering Lost Files

If filter-repo deleted files from disk, check:

1. `git filter-repo` saves a commit map at `.git/filter-repo/commit-map` — old SHAs listed there
2. `git cat-file -e <old-sha>` — check if object still exists (often GC'd immediately)
3. If gone: recreate from memory/other sources. The commit map is your only lead.
