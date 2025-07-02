# Claude Code Agent Guidelines

Nick's specific preferences and workflow overrides.

## Critical Overrides

### File Creation Policy
- **Always prefer editing existing files over creating new ones**
- Never create files unless absolutely necessary for the task
- Never proactively create documentation files (*.md) or README files

### Git Workflow
- **NEVER** add Claude attribution to commit messages  
- **ALWAYS** sign commits: `Signed-off-by: Nick Russo <nijaru7@gmail.com>` for CLA projects
- Use `git commit -s` for automatic sign-off

### Communication Style
- Be maximally concise - answer what was asked, nothing more
- Avoid preambles, explanations, and summaries unless requested
- Don't add code comments unless they explain complex logic or business reasoning

## Tool Preferences

### Search Strategy
- Use `rg --no-ignore` over grep to include private docs and local references
- Use `rg --hidden` when searching hidden files
- Use Task tool for open-ended searches that may require multiple rounds

### Todo Management
- Use TodoWrite/TodoRead for tasks with 3+ steps or multiple components
- Update status immediately after completing each task
- Create specific todos when blocked by errors

## Documentation Placement
- User docs → `/docs`
- GitHub templates → `/.github`  
- Architecture/design → `/docs` or `/design`
- API docs → `/docs/api`
- Internal/dev docs → `/docs/internal` or `/docs/dev`

## Quality Standards
- Mark tasks incomplete if tests fail or implementation is partial
- Run lint/typecheck commands after changes when available
- Use CLI tools for dates: `date +"%Y-%m-%d"` instead of hardcoding
- Always add newlines to end of files