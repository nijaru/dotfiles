# Claude Code Agent Guidelines

## Universal Rules (All Tasks)

### Core Principles
1. **Edit over create** - Modify existing files instead of creating new
2. **Clean up after** - Delete temp files, test artifacts, debug output
3. **Test claims** - Verify before stating (performance, functionality)
4. **Respect existing** - Don't refactor unless asked
5. **Be precise** - Exact numbers/paths, not approximations

### Git Safety
- **NEVER open PRs** - Without explicit user permission
- **No Claude attribution** - Never add "🤖 Generated with Claude"
- **No auto push** - Always ask before remote operations
- **Check first** - `git status` and `git diff` before commits

## Development Tasks

### File Management
**Clean up patterns:**
- Code: `*_wip.*`, `*_temp.*`, `test_*.py`, `.pyc`, `__pycache__`
- Docs: Outdated drafts, duplicate content
- System: `.DS_Store`, `*.swp`, debug logs

**Version naming:**
- `feature.ext` - Current active
- `feature_old_YYYYMMDD.ext` - Archived with date
- `feature_wip.ext` - Work in progress (delete before finishing)

### Code Quality
- **Follow patterns** - Check existing with `rg` first
- **Working code only** - No stubs or "TODO: implement"
- **Comments explain WHY** - Code shows what, comments explain why
- **Remove debug artifacts** - Print statements, verbose logging

### Performance
- **Test 3x minimum** - Report median
- **Include conditions** - Hardware, data size, version
- **Exact numbers** - "156,937 req/s" not "~157K"

## System & Dotfiles Tasks

### File Safety
- **Backup critical files** - Before major changes
- **Test in safe location** - Try dotfile changes in test dir first
- **Preserve permissions** - Note file modes before editing
- **Check symlinks** - Don't break linked configs

### System Commands
- **Explain destructive ops** - What `rm -rf`, `dd`, etc. will do
- **Use safe flags** - `cp -i`, `mv -i` for interactive
- **Check before sudo** - Explain why elevated permissions needed

## Blog & Documentation

### Content Creation
- **Preserve voice** - Match existing tone/style
- **Check frontmatter** - Don't break Jekyll/Hugo metadata
- **Test locally** - Verify markdown renders correctly
- **Keep drafts separate** - Use `_drafts/` or similar

## Response Style

### Be Concise
- **Max 4 lines** (excluding code/tools)
- **Direct answers** - No preamble
- **One-word when possible** - "Yes", "4", "Fixed"

### Be Precise
- **Exact paths** - `/Users/nick/file` not `~/file`
- **Line references** - `config.py:45`
- **Actual errors** - Quote exact error messages

### Tool Usage
- **Batch when possible** - Multiple ops in parallel
- **Right tool for job** - `rg` for search, `sed` for replace
- **Check first** - `ls` before `cd`, `which` before running

## Common Mistakes to Avoid

### Over-Engineering
- Creating abstractions for single use
- Adding features not requested
- Reorganizing working code

### Assuming Context  
- Using `~/` instead of full paths
- Assuming tools are installed
- Not checking current directory

### Being Verbose
- Long explanations when action suffices
- Repeating what code does
- Unnecessary status updates

## Task-Specific Patterns

### Development Projects
- Check `CLAUDE.md` if exists
- Look for `package.json`, `Cargo.toml`, `pyproject.toml`
- Use project's test/lint commands
- Follow existing code style

### System Management
- Explain before `sudo`
- Show what will change
- Provide rollback commands
- Test in safe location first

### Documentation/Blog
- Preserve formatting style
- Check build/preview commands
- Don't break frontmatter
- Match existing voice

## Quick Checklist

**Before starting:**
- [ ] Understand exact request
- [ ] Check existing patterns
- [ ] Note current state

**Before finishing:**
- [ ] Task completed as requested
- [ ] No temp files remain
- [ ] No debug output left
- [ ] Changes are minimal
- [ ] Functionality preserved

---
*Optimized for all Claude Code use cases*