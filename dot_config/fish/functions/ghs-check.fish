function ghs-check --description "Check status of repos without updating"
    set -l clean_count 0
    set -l dirty_count 0
    set -l diverged_count 0
    set -l behind_count 0
    
    echo "🔍 Repository Status Check"
    echo "=========================="
    echo ""
    
    # Find all git repositories under ~/github
    set -l git_dirs (find ~/github -type d -name .git 2>/dev/null | sed 's/\/.git$//')
    
    if test (count $git_dirs) -eq 0
        echo "❌ No repositories found in ~/github"
        return 1
    end
    
    echo "📊 Checking "(count $git_dirs)" repositories..."
    echo ""
    
    for dir in $git_dirs
        set -l repo_path (string replace "$HOME/github/" "" $dir)
        cd $dir
        
        # Fetch latest info without changing anything
        git fetch --quiet 2>/dev/null
        
        # Check for uncommitted changes
        set -l has_changes (git status --porcelain)
        
        # Check if behind remote
        set -l branch (git branch --show-current 2>/dev/null)
        if test -z "$branch"
            set branch (git rev-parse --abbrev-ref HEAD)
        end
        
        set -l behind (git rev-list --count HEAD..origin/$branch 2>/dev/null)
        set -l ahead (git rev-list --count origin/$branch..HEAD 2>/dev/null)
        
        # Determine status
        set -l status_icon "✅"
        set -l status_text "Clean"
        
        if test -n "$has_changes"
            set status_icon "⚠️"
            set status_text "Uncommitted changes"
            set dirty_count (math $dirty_count + 1)
        else if test "$behind" -gt 0 -a "$ahead" -gt 0
            set status_icon "🔀"
            set status_text "Diverged (↑$ahead ↓$behind)"
            set diverged_count (math $diverged_count + 1)
        else if test "$behind" -gt 0
            set status_icon "⬇️"
            set status_text "Behind by $behind commits"
            set behind_count (math $behind_count + 1)
        else if test "$ahead" -gt 0
            set status_icon "⬆️"
            set status_text "Ahead by $ahead commits"
        else
            set clean_count (math $clean_count + 1)
        end
        
        # Only show repos that need attention
        if test "$status_icon" != "✅"
            echo "$status_icon $repo_path: $status_text"
        end
        
        cd - > /dev/null
    end
    
    echo ""
    echo "──────────────────────────────────────"
    echo "📊 Summary:"
    echo "   ✅ Up to date: $clean_count"
    if test $behind_count -gt 0
        echo "   ⬇️  Behind remote: $behind_count"
    end
    if test $dirty_count -gt 0
        echo "   ⚠️  Uncommitted changes: $dirty_count"
    end
    if test $diverged_count -gt 0
        echo "   🔀 Diverged: $diverged_count"
    end
    echo "──────────────────────────────────────"
    
    if test (math $behind_count + $dirty_count + $diverged_count) -gt 0
        echo ""
        echo "💡 Tips:"
        if test $behind_count -gt 0
            echo "   • Run 'ghs-all' to update repositories"
        end
        if test $dirty_count -gt 0
            echo "   • Commit or stash uncommitted changes"
        end
        if test $diverged_count -gt 0
            echo "   • Use 'ghs <repo> --force' to reset diverged repos"
        end
    end
end