function ghs-all --description "Update all repos in ~/github or from a list"
    set -l update_count 0
    set -l error_count 0
    set -l repos_file ""
    set -l force_update false
    
    # Parse arguments
    for arg in $argv
        switch $arg
            case --force
                set force_update true
            case --file
                # Next argument should be the file path
                set repos_file $argv[(math (contains -i -- $arg $argv) + 1)]
            case '*'
                if test -z "$repos_file" -a (string match -- "--file" $argv[(math (contains -i -- $arg $argv) - 1)])
                    # This is the file path argument after --file
                    continue
                else
                    echo "Unknown option: $arg"
                    echo ""
                    echo "Usage: ghs-all [options]"
                    echo "Options:"
                    echo "  --force           Force update all repos (discard local changes)"
                    echo "  --file <path>     Update repos listed in file (one per line)"
                    echo ""
                    echo "Examples:"
                    echo "  ghs-all                    # Update all repos in ~/github"
                    echo "  ghs-all --force           # Force update all repos"
                    echo "  ghs-all --file repos.txt  # Update repos listed in file"
                    return 1
                end
        end
    end
    
    echo "🔄 GitHub Repository Sync"
    echo "========================="
    echo ""
    
    set -l repos_to_update
    
    if test -n "$repos_file"
        # Read repos from file
        if not test -f "$repos_file"
            echo "❌ Error: File not found: $repos_file"
            return 1
        end
        
        echo "📄 Reading repositories from $repos_file"
        set repos_to_update (cat $repos_file | grep -v '^#' | grep -v '^$')
        echo "📊 Found "(count $repos_to_update)" repositories in file"
        
    else
        # Find all repos in ~/github
        echo "🔍 Scanning ~/github for repositories..."
        
        # Find all git repositories under ~/github
        set -l git_dirs (find ~/github -type d -name .git 2>/dev/null | sed 's/\/.git$//')
        
        if test (count $git_dirs) -eq 0
            echo "❌ No repositories found in ~/github"
            return 1
        end
        
        echo "📊 Found "(count $git_dirs)" repositories"
        
        # Convert paths to org/repo format
        for dir in $git_dirs
            set -l repo_path (string replace "$HOME/github/" "" $dir)
            set repos_to_update $repos_to_update $repo_path
        end
    end
    
    echo ""
    
    # Update each repository
    for repo in $repos_to_update
        echo "──────────────────────────────────────"
        echo "📦 Repository: $repo"
        
        if test $force_update = true
            ghs $repo --force
        else
            ghs $repo
        end
        
        if test $status -eq 0
            set update_count (math $update_count + 1)
        else
            set error_count (math $error_count + 1)
            echo "❌ Failed to update $repo"
        end
        
        echo ""
    end
    
    echo "──────────────────────────────────────"
    echo "📊 Summary:"
    echo "   ✅ Successfully updated: $update_count"
    if test $error_count -gt 0
        echo "   ❌ Failed: $error_count"
    end
    echo "──────────────────────────────────────"
end