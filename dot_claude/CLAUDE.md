# Claude Code Agent Guidelines

## Universal Rules (All Tasks)

### Core Principles
1. **Edit over create** - Modify existing files instead of creating new
2. **Clean up after** - Delete temp files, test artifacts, debug output
3. **Test claims** - Verify before stating (performance, functionality)
4. **Respect existing** - Don't refactor unless asked
5. **Be precise** - Exact numbers/paths, not approximations

### Version Control (Git)
- **NEVER open PRs** - Without explicit user permission
- **NO AI attribution** - Never add "🤖 Generated with Claude" or similar
- **STRIP attribution** - Remove any AI attribution found in commits/code
- **No auto push** - Always ask before remote operations

**AUTO-COMMIT when logical unit complete:**
- ✅ Function/method implementation complete
- ✅ Bug fix applied
- ✅ Test added or passing
- ✅ Refactor finished
- ✅ Before switching to different file/feature
- ✅ Each logical unit of work complete (atomic commits)
- Format: `type: description` (feat, fix, docs, refactor, test, chore)

**Git workflow:**
- Always check: `git status` and `git diff` before commits
- Let user decide when to push/squash history

## Documentation Best Practices

### For Any Technical Project
1. **Load project context first** - Check README, STATUS, or main docs
2. **Get current state** - Specific metrics/status, not vague descriptions
3. **Check for existing solutions** - Don't reinvent or repeat failed attempts
4. **Be specific in requests** - "Fix login bug" not "make it work"
5. **Validate changes work** - Test functionality after modifications

### Effective vs Ineffective Prompts
```
✅ "Fix the CSS centering issue in login.css line 45"
✅ "Add error handling to the API call in user.py"
✅ "Optimize database query that takes 2 seconds"

❌ "Make it better" (too vague)
❌ "Fix everything" (too broad)
❌ "Optimize" (what specifically?)
```

## AI Context Engineering

### Universal AI Context Files
- **Primary**: AGENTS.md (2025 industry standard)
- **Legacy**: CLAUDE.md (Claude Code compatibility)
- **IDE**: .cursorrules (Cursor), .github/prompts/*.prompt.md (Copilot)

### Context Optimization Patterns
```
IF providing_code_context:
    → Include imports and dependencies
    → Show related functions/classes
    → Include test cases if available
    → Remove verbose comments
    → Focus on patterns over implementation

IF debugging_with_ai:
    → Include full error message
    → Show relevant code snippet
    → Provide stack trace
    → List recent changes
    → Include environment details

IF complex_task:
    → Break into subtasks
    → Define success criteria per task
    → Provide relevant context per subtask
    → Chain tasks with clear dependencies
```

### Examples Directory Pattern
- **Critical**: AI agents perform significantly better with examples
- **Structure**: examples/{feature}/ with input/output samples
- **Include**: Edge cases, error handling, common patterns

## Development Tasks

### Python Environment Management
**Modern workflow with mise + uv:**
```bash
# Install Python runtime
mise install python@latest
mise use python@latest

# Initialize/sync project (uv manages venv automatically)
uv init new-project  # OR uv sync for existing
cd new-project
uv add requests fastapi
uv add --dev pytest ruff

# Run code (uv handles activation)
uv run python main.py
uv run pytest
uv format  # Built-in formatting (calls ruff)
```

**Environment hygiene:**
- **Never** `pip install` outside of uv-managed projects
- **Always** use `uv add` for dependencies
- **If mise Python polluted**: `mise uninstall python@X && mise install python@X`
- **Use** `uv tool install <tool>` for global tools

### File Management
**Clean up patterns:**
- Code: `*_wip.*`, `*_temp.*`, `test_*.py`, `.pyc`, `__pycache__`
- Docs: Outdated drafts, duplicate content
- System: `.DS_Store`, `*.swp`, debug logs

**Version naming:**
- `feature.ext` - Current active
- `feature_old_YYYYMMDD.ext` - Archived with date
- `feature_wip.ext` - Work in progress (delete before finishing)

### Code Quality Decision Trees
```
IF .editorconfig exists:
    → Use those formatting settings
ELIF .clang-format exists:
    → Use clang-format for C/C++
ELIF .prettierrc exists:
    → Use prettier for JS/TS
ELSE:
    → Match surrounding code patterns (rg "function|class" for style)

IF adding_comments:
    IF explaining_what_code_does:
        → Skip comment (code should be self-documenting)
    ELIF explaining_why_business_logic:
        → Add comment explaining reasoning
    ELIF explaining_complex_algorithm:
        → Add comment with approach/complexity
```

### Performance Decision Trees
```
IF performance_testing_needed:
    → Run benchmark 3+ times, report median
    → Include: hardware, data size, version info
    → Use exact numbers: "156,937 req/s" not "~157K"

IF performance_claims_made:
    → ALWAYS verify with actual measurements
    → Include test conditions in report
    → Compare against baseline if available
```

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

### Tool Selection Decision Trees
```
IF searching_text:
    → rg (faster than grep, better defaults)
IF finding_files:
    → fd (faster than find, better syntax)
IF reading_code:
    → bat (syntax highlighting over cat)
IF text_replacement:
    → sd (more intuitive than sed)
IF structural_code_changes:
    → ast-grep (better than regex for refactoring)
IF git_diff_viewing:
    → delta (better formatting)

IF multiple_operations_possible:
    → Batch tool calls in single message for parallel execution
IF tool_availability_uncertain:
    → Check with `which [tool]` before running
```

## ERROR → SOLUTION MAPPINGS

| Common Error | Fix Command | Context |
|-------------|-------------|----------|
| `mise: command not found` | `curl https://mise.jdx.dev/install.sh \| sh` | Python setup |
| `uv: not found` | `mise use python@latest && pip install uv` | Python env |
| `rg: command not found` | `brew install ripgrep` or `cargo install ripgrep` | Text search |
| `fd: command not found` | `brew install fd-find` or `cargo install fd-find` | File finding |
| `bat: command not found` | `brew install bat` or `cargo install bat` | Code viewing |
| `Permission denied` | Check file permissions with `ls -la` | File access |
| `No such file or directory` | Use absolute paths: `/Users/...` not `~/...` | Path resolution |
| Fish syntax error | Wrap in `bash -c "command"` | Cross-shell compat |

## ANTI-PATTERNS → CORRECT PATTERNS

```
❌ WRONG: Using ~/paths
✅ CORRECT: Use full paths /Users/[user]/...

❌ WRONG: Assuming tools installed  
✅ CORRECT: Check with `which [tool]` first

❌ WRONG: Creating abstractions for single use
✅ CORRECT: Keep code simple, add abstraction when needed

❌ WRONG: Long explanations when action suffices
✅ CORRECT: Show, don't tell - run the command
```

## Task-Specific Decision Trees

### Development Project Detection
```
IF AGENTS.md OR CLAUDE.md exists:
    → Load project-specific instructions first
    → @external/agent-contexts/AI_AGENT_INDEX.md for patterns
IF package.json exists:
    → Node.js project → Use npm/yarn commands
IF Cargo.toml exists:
    → Rust project → Use cargo commands  
IF pyproject.toml exists:
    → Python project → Use uv/poetry commands
IF go.mod exists:
    → Go project → Use go commands
IF pixi.toml exists:
    → Mojo/Python project → Use pixi commands
```

### Test Discovery
```
IF package.json exists:
    → Check scripts: npm test, npm run test, jest, vitest
IF pyproject.toml exists:
    → Check: pytest, python -m pytest, uv run pytest
IF Cargo.toml exists:
    → Use: cargo test
IF go.mod exists:
    → Use: go test ./...
IF Makefile exists:
    → Check: make test, make check
ELSE:
    → Search: find . -name "*test*" -type f
```

### System Operation Safety
```
IF destructive_command (rm, dd, truncate):
    → Explain what will be deleted/changed
    → Provide rollback commands
    → Test in safe location first
IF sudo_needed:
    → Explain why elevated permissions required
    → Show exact commands that will run
```

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
# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.

## Documentation Creation Guidelines
- **Create when valuable**: AGENTS.md, permanent reference docs, core project documentation
- **Avoid when temporary**: Task-specific analysis, one-off explanations, throwaway files
- **Decision tree**: Will this doc serve ongoing project needs beyond current task?