---
name: gitbutler-expert
description: Use when the user asks for GitButler, the `but` CLI, virtual branches, stacked branches, multi-branch workspaces, GitButler PRs, or GitButler history editing.
allowed-tools: Bash, Read
---

# GitButler CLI (`but`)

## Iron Law

In a GitButler-managed repo, use `but` for VCS writes. Do not run `git add`, `git commit`, `git push`, `git checkout`, `git merge`, `git rebase`, `git stash`, `git cherry-pick`, or `git reset`. Read-only Git inspection is fine.

If a repo is not set up for GitButler, do not run `but setup` unless the user asked to adopt GitButler for that repo.

## Operating Model

- Applied branches share one workspace. No checkout is needed.
- Unassigned changes live in `zz`. Assign changes to branches/stacks before committing.
- CLI IDs are session-local. Read them from current `but status -fv`, `but diff`, or `but show`; do not guess or reuse stale IDs.
- Add `--status-after` to mutation commands when the command supports it.
- Use `but oplog` and `but undo` for recovery.

## Default Flow

```bash
but status -fv
but branch new <branch>          # if new work needs a branch
# edit files
but status -fv                   # refresh IDs
but diff <file-or-hunk-id>       # inspect targeted changes
but commit <branch-id-or-name> -m "type(scope): message" --changes <id>,<id> --status-after
```

Use `but commit <branch> --only -m "..." --status-after` only after staging exactly the intended changes to that branch. Without `--only` or `--changes`, `but commit` includes all uncommitted changes eligible for the target branch.

## Command Patterns

| Task | Command |
| :--- | :--- |
| Status with IDs | `but status -fv` |
| Diff target | `but diff <id>` |
| New parallel branch | `but branch new <name>` |
| New stacked branch | `but branch new <name> -a <anchor>` |
| Stack existing branch | `but move <child-branch> <parent-branch> --status-after` |
| Unstack branch | `but move <branch> zz --status-after` |
| Assign file/hunk | `but stage <file-or-hunk-id> <branch> --status-after` |
| Commit selected changes | `but commit <branch> -m "msg" --changes <ids> --status-after` |
| Absorb fixup | `but absorb <file-id> --dry-run`, then `but absorb <file-id> --status-after` |
| Amend into commit | `but amend <file-id> <commit-id> --status-after` |
| Squash/reorder/move | `but squash ... --status-after` / `but move ... --status-after` |
| Pull updates | `but pull --check`, then `but pull --status-after` |
| Push | `but push <branch-id-or-name> --dry-run`, then `but push <branch-id-or-name>` |
| PR | `but pr new <branch-id-or-name> --draft` unless the user asked for ready review |

## Conflicts

GitButler rebases can succeed while leaving conflicts inside commits.

1. Run `but status -fv` and identify conflicted commits.
2. Enter resolution mode: `but resolve <commit-id>`.
3. Read/edit conflicted files; remove all conflict markers.
4. Check progress with `but resolve status`.
5. Finish with `but resolve finish`.

Do not use Git write commands while resolving. Do not run `but resolve finish` before editing and verifying the conflicted files.

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll just use `git rebase -i`" | Use `but move`, `but squash`, `but amend`, `but absorb`, or `but rub`; they understand applied branches. |
| "The ID was `h0` earlier" | IDs are contextual. Refresh with `but status -fv` before mutations. |
| "The commit succeeded, so everything landed" | Check `--status-after`; dependency-locked changes may remain in `zz`. Stack the branch correctly, then commit. |
