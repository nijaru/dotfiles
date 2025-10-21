#!/usr/bin/env fish
function agents-sync --description "Sync relevant global CLAUDE.md preferences to project AGENTS.md"
    # Check if we're in a git repository
    if not test -d .git
        echo "Error: Not in a git repository. Run this from a project root."
        return 1
    end

    # Check if claude CLI is available
    if not command -q claude
        echo "Error: claude CLI not found"
        return 1
    end

    # Check if global CLAUDE.md exists
    if not test -f ~/.claude/CLAUDE.md
        echo "Error: Global CLAUDE.md not found at ~/.claude/CLAUDE.md"
        return 1
    end

    set -l project_root (pwd)
    set -l agents_file "$project_root/AGENTS.md"

    echo "Analyzing project and syncing preferences from global CLAUDE.md..."
    echo ""

    # Use Claude to intelligently extract and adapt global preferences
    claude << 'EOF'
Analyze this project and create/update AGENTS.md with relevant preferences from my global ~/.claude/CLAUDE.md file.

Task:
1. Examine the project structure, languages, frameworks, and tools used
2. Read ~/.claude/CLAUDE.md
3. Extract ONLY the sections relevant to this specific project:
   - Code Comment Philosophy (always include)
   - Code Quality Standards (always include)
   - Git Preferences (always include)
   - Development Workflow (always include)
   - Language-specific sections (only if that language is used in this project)
   - Tool-specific sections (only if those tools are used)
4. Adapt the instructions to be project-specific where appropriate
5. If ./AGENTS.md exists, preserve any existing project-specific instructions and merge intelligently
6. If ./AGENTS.md doesn't exist, create it with the adapted content
7. Add a header noting these are synced from global preferences with date

Requirements:
- Keep instructions concise and actionable
- Remove sections that aren't relevant to this project
- Preserve any existing project-specific content in AGENTS.md
- Add a comment at the top: "# AI Agent Instructions - Synced from global preferences on [date]"
- Include a note about using @external/agent-contexts/ patterns if the repo uses the agent-contexts submodule

Write the updated AGENTS.md file.
EOF

    if test -f $agents_file
        echo ""
        echo "✓ AGENTS.md updated successfully"
        echo ""
        echo "Preview:"
        head -30 $agents_file
    else
        echo ""
        echo "✗ Failed to create/update AGENTS.md"
        return 1
    end
end
