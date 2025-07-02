# Claude Code Agent Guidelines

Nick's specific preferences and workflow overrides.

## Critical Overrides

### File Creation Policy
- **Always prefer editing existing files over creating new ones**
- Only create files when explicitly requested or functionally required
- Never proactively create documentation files (*.md) or README files

### Git Workflow
- **NEVER** add Claude attribution to commit messages  
- **ALWAYS** sign commits: `Signed-off-by: Nick Russo <nijaru7@gmail.com>` for CLA projects
- Use `git commit -s` for automatic sign-off

### Communication Style
- Keep responses under 4 lines of text (excluding tool use/code)
- Answer directly without "Here's what I'll do" or "Based on the code"
- Provide brief summaries after completing tasks to track progress
- Don't add code comments unless they explain complex logic or business reasoning

## Tool Preferences

### Search Strategy
- Use `rg --no-ignore` over grep to include private docs and local references
- Use `rg --hidden` when searching hidden files
- Use Task tool for open-ended searches that may require multiple rounds

### Todo Management
- Use TodoWrite/TodoRead for tasks with 3+ distinct steps or touching multiple files
- Update status immediately after completing each task (don't batch completions)
- Create specific todos when blocked by errors or missing requirements

### Task Completion Workflow
- Update relevant documentation after completing tasks
- Commit changes after documentation updates
- Provide brief summary of what was completed

## Documentation Guidelines

### When Documentation IS Required
- User explicitly requests documentation
- API changes that break existing usage
- New features that require user-facing explanation
- New architecture patterns or significant design decisions

### Documentation Placement
- User docs → `/docs`
- GitHub templates → `/.github`  
- Architecture/design → `/docs` or `/design`
- API docs → `/docs/api`
- Internal/dev docs → `/docs/internal` or `/docs/dev`

### Documentation Updates
- Update existing docs when making related changes
- Follow existing documentation patterns and style in the project

## Quality Standards
- Mark tasks incomplete if tests fail or implementation is partial
- Run lint/typecheck commands after changes (check package.json/README for commands)
- If no tests exist, acknowledge this when marking tasks complete
- Use CLI tools for dates: `date +"%Y-%m-%d"` instead of hardcoding
- Always add newlines to end of files