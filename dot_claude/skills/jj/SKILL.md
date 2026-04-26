---
name: jj
description: Use when a repository contains `.jj/`, when the user asks to use Jujutsu/jj, or when recovering/inspecting jj operation history.
allowed-tools: Bash, Read
---

# jj (Jujutsu)

## Iron Law

If `.jj/` exists, use `jj` for VCS writes. Do not use `git add`, `git commit`, `git checkout`, `git rebase`, `git merge`, `git stash`, or `git reset` in that workspace.

## Operating Model

- The working copy is a commit: `@`. Most `jj` commands snapshot file changes before they run. There is no staging area.
- Revisions are edited directly. Start new work with `jj new`; finish by giving the revision a useful description with `jj describe -m "..."`.
- Bookmarks are Git branch equivalents, but there is no current bookmark. Creating a revision does not move a bookmark.
- Recovery is operation-based. Prefer `jj op log`, `jj undo`, and `jj redo` over manual Git recovery.

## Default Flow

```bash
jj st
jj log -r 'ancestors(@, 8) | @'
jj new
# edit files
jj st
jj diff
jj describe -m "type(scope): message"
```

When using Git remotes:

```bash
jj bookmark set <name> -r @      # create or move the bookmark to the revision to publish
jj git push --bookmark <name> --dry-run
jj git push --bookmark <name>
```

Use `jj git push --change @` only for temporary/generated bookmark names. Use explicit bookmarks for normal branches and PRs.

## Common Commands

| Task | Command |
| :--- | :--- |
| Status | `jj st` |
| Recent graph | `jj log -r 'ancestors(@, 12) | descendants(@, 2)'` |
| New child revision | `jj new` |
| Edit another revision | `jj edit <rev>` |
| Update message | `jj describe -m "msg"` |
| Split current revision | `jj split` |
| Move changes into ancestors | `jj absorb` |
| Squash into parent | `jj squash` |
| Rebase revision | `jj rebase -r <rev> -d <dest>` |
| Restore a file | `jj restore <path>` |
| Operation history | `jj op log` |
| Undo/redo operation | `jj undo` / `jj redo` |

## Conflicts

Conflicts are first-class revision state and may be materialized as file markers when you edit the conflicted revision.

1. Detect with `jj st`, `jj log`, or `jj show <rev>`.
2. Enter/edit the conflicted revision if needed: `jj edit <rev>`.
3. Resolve by editing files directly or running `jj resolve <path>` with the configured merge tool.
4. Run `jj st` and verify no conflicts remain before pushing.

Do not push a stack with conflicted revisions or conflicted bookmarks.

## Anti-Rationalization

| Excuse | Reality |
| :--- | :--- |
| "I'll stage this later" | There is no staging; snapshotting is automatic. Use `jj split`, `jj squash`, or `jj absorb` to shape revisions. |
| "The commit exists, so it will push" | Git remotes see bookmarks. Set/move a bookmark or use `jj git push --change`. |
| "Git is familiar for this one command" | In a jj workspace, Git write commands bypass jj's operation model and can desync the working copy. |
