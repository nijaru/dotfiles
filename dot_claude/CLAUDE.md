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

## Project Context Loading

```
IF starting_task:
    → Check README/AGENTS.md/CLAUDE.md for context
    → Get specific current state (metrics, versions)
    → Check for previous attempts/solutions
    → Understand success criteria
```

### Effective Task Requests
```
✅ Specific: "Fix CSS centering in login.css:45"
✅ Measurable: "Optimize query taking 2+ seconds"
✅ Actionable: "Add error handling to user.py API call"

❌ Vague: "Make it better"
❌ Broad: "Fix everything"
❌ Unclear: "Optimize" (what/how/why?)
```

## AI Context Engineering

### Universal AI Context Files
- **Primary**: AGENTS.md (2025 industry standard, create as main file)
- **Compatibility**: CLAUDE.md (symlink to AGENTS.md for Claude Code)
- **IDE**: .cursorrules (Cursor), .github/prompts/*.prompt.md (Copilot)
- **Pattern**: Always create AGENTS.md, then `ln -s AGENTS.md CLAUDE.md`

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

### Python Environment Patterns
```
IF new_python_project:
    → mise install python@latest && mise use python@latest
    → uv init && uv sync
IF adding_dependencies:
    → uv add [packages]  # Never pip install
    → uv add --dev [dev-packages]
IF running_code:
    → uv run python script.py  # Handles venv automatically
IF global_tool_needed:
    → uv tool install [tool]
IF environment_broken:
    → mise uninstall python@X && mise install python@X
```

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


## Code Style Rules

### Comments - Best Practices
**Default**: Most code needs NO comments. Well-structured code is self-documenting.

#### ✅ GOOD Comments (Rare but Valuable)
- **WHY decisions**: `# Use 1000 threshold - benchmarks show 3x speedup`
- **Non-obvious requirements**: `# EU GDPR requires 7-year retention`
- **Complexity notes**: `# O(n log n) despite linear scan - sorting dominates`
- **External workarounds**: `# Workaround: Mojo lacks thread-safe bulk insert`
- **Algorithm rationale**: `# Quickselect over sort - only need top K`

#### ❌ BAD Comments (Never Add These)
- **WHAT code does**: `# Increment counter` (obvious from code)
- **Narrative/emotional**: `# CRITICAL FIX!` `# This works perfectly!`
- **Debugging breadcrumbs**: `# TODO: Fix this` (remove before commit)
- **Syntax explanation**: `# Convert to global ID` (use better variable names)
- **Stating the obvious**: `# Update size` for `size += count`

#### 📏 Comment Litmus Test
Before adding ANY comment, ask:
1. Does this explain WHY, not WHAT?
2. Will this be valuable in 6 months?
3. Can better naming eliminate this comment?

**Example**: Instead of commenting, use clear names:
```python
# Bad: Comment needed
id = s * c + l  # Calculate global ID

# Good: Self-documenting
global_id = segment_id * segment_capacity + local_node_id
```

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

## Task Completion Checklist

```
BEFORE_STARTING:
    → Load AGENTS.md/CLAUDE.md if exists
    → Understand exact success criteria
    → Check for previous attempts

BEFORE_FINISHING:
    → Delete temp files (*_wip.*, *.tmp, analysis.md)
    → Remove debug output (console.log, print statements)
    → Commit logical units (no AI attribution)
    → Verify functionality still works
```

---
*Optimized for all Claude Code use cases*
# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.

## Documentation Creation Guidelines
```
IF permanent_reference_needed:
    → Create: AGENTS.md, API docs, architecture docs
IF temporary_but_useful:
    → Create during task, DELETE after completion
    → Examples: analysis.md, investigation.md, notes.md
IF redundant_or_unnecessary:
    → Don't create, add to existing docs instead
```
**Cleanup rule**: Delete all task-specific docs when task completes