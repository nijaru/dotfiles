# Global Claude Code Rules

Universal preferences for all Claude Code projects.

## Git & Security
- NEVER add Claude attribution lines, signatures, or any "Generated with Claude" text to git commit messages
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

## Documentation
- Create necessary documentation when completing tasks
- Avoid excessive documentation - focus on essential information

## Code Formatting
- Always add newlines to the end of files
