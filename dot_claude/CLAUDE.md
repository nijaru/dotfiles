# Claude Code Agent Guidelines

Behavioral rules and preferences optimized for AI agent software engineering tasks.

## Core Principles

### File Management
- **Always prefer editing existing files over creating new ones**
- Never create files unless absolutely necessary for the task
- Check existing codebase structure before adding new components
- Follow existing file organization patterns

### Accuracy & Honesty
- Never claim something works without testing or verification
- Acknowledge issues, bugs, or incomplete functionality immediately
- Be transparent about limitations, assumptions, or potential problems
- Mark tasks incomplete if tests fail or implementation is partial

### Communication Efficiency
- Be concise and direct - answer what was asked
- Avoid unnecessary explanations or preambles
- Focus on the specific task, not tangential information

## Task Execution

### Planning & Tracking
- Use TodoWrite/TodoRead for tasks with 3+ steps or multiple components
- Update status immediately: pending → in_progress → completed
- Create specific todos when blocked by errors or missing requirements
- Update relevant documentation after completing tasks

### Code Implementation
- **First**: Understand existing codebase patterns and conventions
- **Always**: Check for existing libraries/dependencies before assuming availability
- **Never**: Add code comments unless they explain complex logic or business reasoning
- Test solutions when possible before marking tasks complete
- Run lint/typecheck commands after changes when available

### Search & Discovery
- Use Task tool for open-ended searches requiring multiple rounds
- Use targeted searches rather than reading entire large files
- Check README or search codebase to determine testing approaches
- Never assume specific frameworks, tools, or scripts exist

## Development Standards

### Git & Security
- **NEVER** add Claude attribution to commit messages
- **ALWAYS** sign commits: `Signed-off-by: Nick Russo <nijaru7@gmail.com>` for CLA projects
- Use `git commit -s` for automatic sign-off
- Commit working changes before cleanup/refactoring
- Never commit secrets, API keys, or sensitive data
- Respect .gitignore but search beyond it when needed

### Code Quality
- Follow existing indentation, naming, and style patterns
- Add newlines to end of files
- Use CLI tools for dates: `date +"%Y-%m-%d"` instead of hardcoding
- Handle errors gracefully and document workarounds clearly

### Tool Usage Optimization
- Batch multiple tool calls in single responses for performance
- When using Bash, prefer these modern tools:
  - `rg --no-ignore` over grep (includes private docs and local references)
  - `rg --hidden` when searching hidden files
  - `delta` for improved git diff readability

### Documentation Strategy
- Create necessary documentation when completing tasks
- Focus on essential information, avoid over-documentation
- **File placement**:
  - User docs → `/docs`
  - GitHub templates → `/.github`
  - Architecture/design → `/docs` or `/design`
  - API docs → `/docs/api`
  - Internal/dev docs → `/docs/internal` or `/docs/dev`

## Error Handling & Edge Cases

### When Blocked
- Create specific todos describing what needs resolution
- Ask for clarification when requirements are ambiguous
- Document incomplete implementations clearly
- Never mark tasks complete with failing tests

### Verification Steps
- Test solutions before marking complete when possible
- Check that code follows project patterns
- Verify dependencies exist before using them
- Run available lint/type checking tools after changes