---
name: gitbutler-expert
description: Use when managing virtual branches, stacking, or performing git operations with the GitButler CLI (`but` command). Covers parallel branch workflows, commit editing, operations log, and forge interactions.
allowed-tools: Bash, Read
---

# GitButler Expert

## Core Concepts

**Virtual branches** — multiple branches active simultaneously in your working tree. No checkout required. Changes are assigned to branches; unassigned changes live in `zz` (the scratch area).

**Stacking** — dependent branches anchored to each other: `but branch new -a <anchor> <name>`. Creates a chain for sequential review.

**File IDs** — short codes (`h0`, `l0`, `zz`) shown by `but status --files`. Use these instead of full paths for most operations.

**Operations log** — every action is snapshottable and undoable, beyond git reflog.

**Rebases always succeed** — conflicts are recorded inside commits, not blocking. Resolve at your own pace.

## Command Reference

### Status & Inspection

| Command                                     | Purpose                                                      |
| :------------------------------------------ | :----------------------------------------------------------- |
| `but status` / `but st`                     | Workspace overview: branches, assignments, upstream          |
| `but status --files` / `but stf`            | Files with short IDs for use in other commands               |
| `but status -u`                             | Show detailed upstream changes                               |
| `but diff [id]`                             | Human-readable diff; scope to file/hunk by ID                |
| `but branch`                                | List applied branches with commit count and mergeability     |
| `but branch list [filter]`                  | Filter branches (local/remote, partial name)                 |
| `but branch show <branch> [-r] [-f] [--ai]` | Show commits ahead; `-r` PR info, `-f` files, `--ai` summary |
| `but show <sha>`                            | Commit detail                                                |

### Branching & Committing

| Command                                 | Purpose                                 |
| :-------------------------------------- | :-------------------------------------- |
| `but branch new <name>`                 | Create new virtual branch               |
| `but branch new -a <anchor> <name>`     | Create stacked branch on top of anchor  |
| `but branch delete <name>`              | Delete branch (even with unmerged work) |
| `but stage <file-id> <branch>`          | Assign file to a branch                 |
| `but commit -m 'msg'`                   | Commit all changes                      |
| `but commit -o -m 'msg' <branch>`       | Commit only assigned changes            |
| `but commit -p <ids> -m 'msg' <branch>` | Commit specific files/hunks             |
| `but commit empty --after <sha>`        | Insert empty commit (for splitting)     |

File IDs: short code (`h0`), full path, or comma/space-separated list. Hunk ranges: `h0-j0`.

### Rub — The Swiss Army Knife

`but rub <source> <destination>` moves anything to anywhere. Replaces `git rebase -i`, `--fixup`, and `cherry-pick`.

| Operation                        | Command                         |
| :------------------------------- | :------------------------------ |
| Unassign file to scratch         | `but rub h0 zz`                 |
| Reassign file to branch          | `but rub h0 <branch>`           |
| Amend file into commit           | `but rub h0 <sha>`              |
| Squash two commits               | `but rub <sha1> <sha2>`         |
| Uncommit (back to scratch)       | `but rub <sha> zz`              |
| Move commit to branch            | `but rub <sha> <branch>`        |
| Move file change between commits | `but rub <sha>:<file-id> <sha>` |

Split a commit: `but commit empty --after <sha>`, then `but rub <sha>:<file-id> <new-sha>`.

### Commit Editing

| Command                         | Purpose                                              |
| :------------------------------ | :--------------------------------------------------- |
| `but reword <sha>`              | Edit commit message (opens `$EDITOR`, rebases above) |
| `but reword -m <name> <branch>` | Rename branch                                        |

### Operations Log

| Command                   | Purpose                                |
| :------------------------ | :------------------------------------- |
| `but oplog`               | Full operation history with timestamps |
| `but undo`                | Undo last operation                    |
| `but oplog restore [sha]` | Restore workspace to snapshot          |
| `but oplog snapshot`      | Create manual checkpoint               |

Restoring creates a new oplog entry — the restore itself is undoable.

### Upstream / Base

| Command                      | Purpose                                             |
| :--------------------------- | :-------------------------------------------------- |
| `but pull --check`           | Preview rebase (shows clean/conflict/merged status) |
| `but pull`                   | Fetch + rebase active branches on new base          |
| `but config target [branch]` | View or change target branch                        |

Always run `--check` first.

### Conflict Resolution

| Command              | Purpose                                       |
| :------------------- | :-------------------------------------------- |
| `but resolve`        | Enter resolution mode; pick conflicted commit |
| `but resolve finish` | Finalize after fixing all conflict markers    |

Conflicts use zdiff3 markers (ours / ancestor / theirs). Resolve in any order.

### Forges (GitHub)

| Command                 | Purpose                                                     |
| :---------------------- | :---------------------------------------------------------- |
| `but push [branch]`     | Push to remote; `-d` for dry-run                            |
| `but pr [branch]`       | Create/update PR (auto-pushes first)                        |
| `but config forge auth` | Authenticate (OAuth device flow, PAT, or GitHub Enterprise) |

GitLab MR support is planned but not yet available.

### Configuration & Aliases

```bash
but config user                        # view name/email/editor
but config user set name "Nick"
but config user set editor nvim
but alias add stfu 'status -f -u'      # local alias
but alias add stfu 'status -f -u' -g   # global alias
```

Default aliases: `st` → `status`, `stf` → `status --files`. Running `but` with no args executes the `default` alias (default: `status`).

## Key Differences from Plain Git

| Git                                   | GitButler                                     |
| :------------------------------------ | :-------------------------------------------- |
| One active branch (checkout)          | Multiple branches active simultaneously       |
| `git rebase -i` for history editing   | `but rub` for all commit manipulation         |
| Rebase fails on conflict              | Rebase succeeds; conflict lives inside commit |
| `git reflog` for recovery             | `but oplog` + `but undo` with full restore    |
| `git commit --fixup` + `--autosquash` | `but rub <file> <sha>` directly               |
| Full paths for file targeting         | Short IDs from `but status --files`           |

## Anti-Rationalization

| Excuse                                 | Reality                                                        |
| :------------------------------------- | :------------------------------------------------------------- |
| "I'll just use `git rebase -i`"        | `but rub` is faster and aware of virtual branches.             |
| "Conflicts mean the pull failed"       | Rebases always succeed in GitButler. Check `but status`.       |
| "I need to checkout before committing" | Virtual branches are always applied — commit by branch name.   |
| "I'll skip `--check`"                  | `but pull --check` prevents surprises on multi-branch rebases. |
