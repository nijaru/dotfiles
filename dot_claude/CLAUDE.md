# Claude Code Guidelines

Core principles and preferences for all Claude Code sessions.

## Work Standards

### Quality & Assessment
- Always be accurate and honest when assessing work completion
- Test solutions when possible before marking tasks complete
- Acknowledge issues, bugs, or incomplete functionality clearly
- Never claim something works without testing or verification
- Be transparent about limitations, assumptions, or potential problems

### Task Management
- Use TodoWrite/TodoRead tools for tasks with 3+ steps or multiple components
- Update task status: pending → in_progress → completed
- Mark tasks complete immediately after finishing them
- Update relevant documentation after tasks are complete
- Clean up temporary/experimental files after committing working changes

### Communication
- Be concise and direct - minimize unnecessary explanations
- Focus on what was asked, avoid tangential information
- Add code comments only when they provide value (explain why, not what)
  - Comment complex logic, algorithms, or non-obvious solutions
  - Comment business logic reasoning or important trade-offs
  - Avoid comments that simply restate what the code does

## Development Practices

### Git & Security
- **NEVER** add Claude attribution lines, signatures, or any "Generated with Claude" text to git commit messages
- **ALWAYS** sign commits with `Signed-off-by: Nick Russo <nijaru7@gmail.com>` when contributing to projects with CLAs
- Use `git commit -s` for automatic sign-off or manually add to commit messages
- Commit working changes before cleanup/refactoring
- Never commit secrets, API keys, or sensitive data
- Respect .gitignore and don't force-add ignored files

### Code Standards
- **Always prefer editing existing files over creating new ones**
- Follow existing codebase patterns and conventions first
- Check for existing libraries/dependencies before assuming availability
- Always add newlines to the end of files
- Use CLI tools like `date` to get current date/time instead of hardcoding
  - `date +"%Y-%m-%d"` for ISO format
  - `date +"%Y-%m-%d %H:%M:%S"` for timestamp

### Error Handling
- When blocked by errors, create specific todos describing what needs resolution
- Never mark tasks complete if tests fail or implementation is partial
- Ask for clarification when requirements are ambiguous
- Document workarounds and limitations clearly

### Documentation
- Create necessary documentation when completing tasks
- Avoid excessive documentation - focus on essential information
- **Extensive user documentation** → `/docs` folder
- **GitHub-specific templates** → `/.github` folder
- **Architecture/design docs** → `/docs` or `/design`
- **API documentation** → `/docs/api`
- **Internal/developer docs** → `/docs/internal` or `/docs/dev`

## Tool Preferences

### Performance & Efficiency
- Batch multiple tool calls in single responses for performance
- Use search tools (Task, Grep, Glob) efficiently for code exploration
- For large codebases, use targeted searches rather than reading entire files
- Use Task tool for open-ended searches that may require multiple rounds

### Testing & Verification
- Run lint/typecheck commands after code changes when available
- Test solutions when possible before marking complete
- Check README or search codebase to determine testing approach
- Never assume specific test frameworks or scripts exist

### CLI Tools for Bash
When using Bash tool, prefer modern alternatives:
- **rg** over grep (faster search, better regex)
  - Use `rg --no-ignore` to include gitignored files (private docs, local references)
  - Use `rg --hidden` to search hidden files when needed
- **delta** for git diffs (improved readability for code review)