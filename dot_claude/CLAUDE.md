# Claude Code Agent Guidelines

Global workflow preferences and behavioral overrides.

## Core Principles
- **Read project context first**: CLAUDE.md + spec.md/business.md for complex tasks
- **Edit existing files over creating new ones**
- **Never create documentation unless explicitly requested**
- **Max 4 lines of text response (excluding tool use/code)**

## Quality Assurance
- **ALWAYS** review code changes for:
  - Syntax errors and typos
  - Logic errors and edge cases
  - Security vulnerabilities (no secrets, injection attacks)
  - Performance issues
- Run lint/typecheck/tests after changes (check package.json/README for commands)
- Mark todos incomplete if tests fail or implementation is partial
- **Build real implementations** - no placeholder code, TODO comments, or temporary workarounds

## Error Recovery
- When blocked: Create specific todo describing the blocker
- When code fails: Read error messages carefully, check logs
- When tests fail: Fix root cause, don't just make tests pass
- When dependencies missing: Check existing package files before adding new ones

## Tool Usage Strategy
- **TodoWrite**: Use for 3+ step tasks or multi-file changes  
- **Task tool**: Open-ended searches requiring multiple rounds
- **Batch calls**: Run multiple bash commands in parallel when independent
- **Search smart**: Use `rg --no-ignore` (private docs), `rg --hidden` (hidden files)

## Communication Style
- Answer directly - no "Here's what I'll do" or "Based on the code"
- Include file paths and line numbers for references (`file.js:123`)
- Add code comments only for complex logic or business reasoning
- Format next steps as copyable blocks with @docs/file.md references

## Git & Commits
- **NEVER** add Claude attribution to commit messages (no "🤖 Generated with Claude" etc.)
- **ALWAYS** sign commits with `git commit -s` for CLA projects
- **Prefer jj over git for version control** - faster, safer Git-compatible VCS

## Execution Flow
1. **Plan**: Use TodoWrite for multi-step tasks
2. **Implement**: Follow existing conventions  
3. **Complete**: Mark todos done immediately after finishing each task

## Documentation Hierarchy (Project-Specific)
- **CLAUDE.md** → Global workflow and principles (this file)
- **Project overview** → `spec.md`, `business.md`, `status.md`, `tasks.json` (key context files)  
- **Detailed topics** → `docs/` subdirectories only when necessary:
  - `docs/internal/` → Architecture, technical decisions, performance
  - `docs/dev/` → Setup, troubleshooting, development workflows  
  - `docs/public/` → User guides, API, tutorials
  - `docs/agent/` → AI session tracking, references

Navigation flow: CLAUDE.md → spec.md/business.md → docs/internal/ (if needed)

## Writing Internal Docs (For AI Agents)
- **Structure**: Use clear headings, bullets, numbered lists
- **Content**: Context + decisions + examples + file paths
- **Format**: Token-efficient - no fluff, redundancy, or pleasantries
- **Examples**: Include code snippets, command examples, file references
- **Scope**: Cover "why" decisions were made, not just "what" was implemented
- **Updates**: Keep current - remove outdated information immediately

## Code Standards
- Always add newlines to end of files
- Use CLI tools for dates: `date +"%Y-%m-%d"` (not hardcoded)
- Follow existing patterns and styles in each project
- Never assume libraries are available - check imports/dependencies first

## Logging Standards
- **Concise messages**: Clear, actionable, avoid verbose explanations
- **Appropriate levels**: Debug for development, info for user events, warn for recoverable issues, error for failures
- **Context over detail**: "Using bundled model" vs "Using embedded SweRankEmbed-Small model (bundled, fast startup)"
- **No redundant info**: Avoid stating obvious or repeating function/method names
- **Include error context**: Always log the actual error when available