# Global Claude Code Rules

Universal preferences for all Claude Code projects.

## Git & Security
- **NEVER** add Claude attribution lines, signatures, or any "Generated with Claude" text to git commit messages
- **ALWAYS** sign commits with `Signed-off-by: User Name <user.email@example.com>` when contributing to projects with CLAs
- Use `git commit -s` for automatic sign-off or manually add to commit messages
- Commit working changes before cleanup/refactoring
- Never commit secrets, API keys, or sensitive data
- Respect .gitignore and don't force-add ignored files

## Task Management
- Use TodoWrite/TodoRead tools proactively for multi-step tasks
- Update task status: pending → in_progress → completed
- Clean up temporary/experimental files after committing working changes

## Tool Efficiency
- Batch multiple tool calls in single responses for performance
- Use search tools (Task, Grep, Glob) efficiently for code exploration

## Modern CLI Tools
Prefer faster, modern alternatives when available:
- **rg** over grep (faster search, respects .gitignore, better regex)
- **fd** over find (simpler syntax, faster, respects .gitignore)
- **bat** over cat (syntax highlighting aids code analysis)
- **eza** over ls (better formatting, git status integration)
- **delta** for git diffs (improved readability for code review)

## Documentation
- Create necessary documentation when completing tasks
- Avoid excessive documentation - focus on essential information

## Date and Time
- Use CLI tools like `date` to get current date/time when writing dates instead of hardcoding
- Examples: `date +"%Y-%m-%d"` for ISO format, `date +"%Y-%m-%d %H:%M:%S"` for timestamp

## Code Formatting
- Always add newlines to the end of files
