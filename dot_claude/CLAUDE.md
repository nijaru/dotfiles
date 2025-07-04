# Claude Code Agent Guidelines

Nick's workflow preferences and behavioral overrides.

## Context Management
- **CLAUDE.md**: Essential workflow rules for every conversation
- **`/docs/`**: Detailed guides, examples, reference material (organized in subdirs)
- Reference format: `docs/subdir/filename.md: Brief description`
- Keep CLAUDE.md focused - move lengthy content to `/docs/`

## Core Rules

### Files & Creation
- **Always edit existing files over creating new ones**
- Only create files when explicitly requested or functionally required
- Never proactively create documentation (*.md) or README files

### Communication Style  
- Max 4 lines of text (excluding tool use/code)
- Answer directly - no "Here's what I'll do" or "Based on the code"
- Add code comments only for complex logic or business reasoning
- Include file paths and references when compacting conversations

### Git & Commits
- **NEVER** add Claude attribution to commit messages
- **ALWAYS** sign commits: `Signed-off-by: Nick Russo <nijaru7@gmail.com>` for CLA projects
- Use `git commit -s` for automatic sign-off

## Task Execution Flow

### 1. Planning & Exploration
- Use TodoWrite/TodoRead for 3+ step tasks or multi-file changes
- Search with `rg --no-ignore` (private docs) and `rg --hidden` (hidden files)
- Use Task tool for open-ended searches requiring multiple rounds

### 2. Implementation
- Update todo status immediately after each task (no batching)
- Create specific todos when blocked by errors or missing requirements
- Run lint/typecheck after changes (check package.json/README for commands)
- Mark incomplete if tests fail or implementation is partial

### 3. Completion
- Update relevant docs when changes affect existing documentation
- Clean up temporary files or unused code
- Commit changes after doc updates
- Generate brief summary with key file paths
- Format next steps as copyable block with source paths and @docs/file.md references
- Only @ files needed in next conversation context
- Acknowledge if no tests exist

## Documentation

### When Required
- User explicitly requests it
- API changes breaking existing usage
- New user-facing features needing explanation
- New architecture patterns or design decisions

### File Placement
- User docs → `/docs/`
- GitHub templates → `/.github/`
- Architecture/design → `/docs/architecture/` or `/design/`
- API docs → `/docs/api/`
- Internal/dev docs → `/docs/internal/` or `/docs/dev/`
- Guides/tutorials → `/docs/guides/`
- Examples → `/docs/examples/` or `/examples/`

## Code Standards
- Always add newlines to end of files
- Use CLI tools for dates: `date +"%Y-%m-%d"` (not hardcoded)
- Follow existing patterns and styles in each project