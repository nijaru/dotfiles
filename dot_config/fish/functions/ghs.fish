function ghs --description "Sync GitHub repo to ~/github/org/repo structure (clone or pull)"
    if test (count $argv) -eq 0
        echo "Usage: ghs <username/repo-name> [--force]"
        echo "       ghs <https://github.com/username/repo> [--force]"
        echo ""
        echo "Options:"
        echo "  --force    Reset to origin/HEAD, discarding local changes"
        echo ""
        echo "Examples:"
        echo "  ghs nijaru/agent-contexts        # Clone or update repo"
        echo "  ghs zed-industries/zed --force   # Force update, discard changes"
        return 1
    end

    set -l repo_path $argv[1]
    set -l force_update false
    
    # Check for --force flag
    if contains -- --force $argv
        set force_update true
    end
    
    # Strip GitHub URL prefix if present
    set repo_path (string replace "https://github.com/" "" $repo_path)
    set repo_path (string replace "git@github.com:" "" $repo_path)
    set repo_path (string replace ".git" "" $repo_path)
    
    # Extract org/user and repo name
    set -l parts (string split "/" $repo_path)
    if test (count $parts) -ne 2
        echo "Error: Invalid format. Use 'username/repo' or 'org-name/repo'"
        return 1
    end
    
    set -l org $parts[1]
    set -l repo $parts[2]
    set -l target_dir ~/github/$org/$repo
    
    # Check if gh is available
    if not command -q gh
        echo "Error: gh CLI not found. Install with: brew install gh"
        return 1
    end
    
    # If directory exists, update it
    if test -d $target_dir
        echo "📂 Repository exists at $target_dir"
        cd $target_dir
        
        # Check if it's a git repository
        if not test -d .git
            echo "❌ Error: $target_dir is not a git repository"
            return 1
        end
        
        # Save current branch
        set -l current_branch (git branch --show-current 2>/dev/null)
        if test -z "$current_branch"
            set current_branch (git rev-parse --abbrev-ref HEAD)
        end
        
        # Check for uncommitted changes
        set -l has_changes (git status --porcelain)
        
        if test -n "$has_changes"
            if test $force_update = true
                echo "⚠️  Discarding local changes (--force mode)"
                git reset --hard HEAD
                git clean -fd
            else
                echo "⚠️  Warning: Uncommitted changes detected"
                echo "   Use 'ghs $repo_path --force' to discard changes"
                echo "   Or commit/stash changes first"
                git status --short
                return 1
            end
        end
        
        echo "🔄 Updating repository..."
        
        # Fetch all branches and tags
        git fetch --all --tags --prune
        
        # Get default branch
        set -l default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
        if test -z "$default_branch"
            # Try to determine from common branch names
            for branch in main master
                if git show-ref --verify --quiet refs/remotes/origin/$branch
                    set default_branch $branch
                    break
                end
            end
        end
        
        # Update to latest
        if test -n "$default_branch"
            if test "$current_branch" != "$default_branch"
                echo "🔀 Switching to $default_branch branch"
                git checkout $default_branch
            end
            
            # Try fast-forward merge first
            if not git merge --ff-only origin/$default_branch 2>/dev/null
                if test $force_update = true
                    echo "⚠️  Fast-forward not possible, forcing reset"
                    git reset --hard origin/$default_branch
                else
                    echo "⚠️  Cannot fast-forward merge. Local branch has diverged."
                    echo "   Use 'ghs $repo_path --force' to overwrite local changes"
                    return 1
                end
            end
        else
            echo "📥 Pulling latest changes"
            git pull --ff-only || begin
                if test $force_update = true
                    git pull --rebase
                else
                    echo "⚠️  Pull would not be fast-forward"
                    echo "   Use 'ghs $repo_path --force' to force update"
                    return 1
                end
            end
        end
        
        # Show update summary
        echo "✅ Updated to:"
        git log --oneline -1
        
        # Update submodules if they exist
        if test -f .gitmodules
            echo "📦 Updating submodules..."
            git submodule update --init --recursive
        end
        
        cd - > /dev/null
        
    else
        # Directory doesn't exist, clone it
        echo "📥 Cloning $repo_path to $target_dir..."
        
        # Create parent directory if needed
        mkdir -p ~/github/$org
        
        # Clone the repository
        gh repo clone $repo_path $target_dir -- --recurse-submodules
        
        if test $status -eq 0
            echo "✅ Successfully cloned to $target_dir"
            
            # Show repo info
            cd $target_dir
            echo "📊 Repository info:"
            git log --oneline -1
            cd - > /dev/null
        else
            echo "❌ Failed to clone repository"
            return 1
        end
    end
    
    # Create/update symlink in external/ if we're in a project with external/ dir
    if test -d external
        set -l symlink_path external/$repo
        if test -L $symlink_path
            echo "🔗 Symlink already exists: $symlink_path"
        else if test -e $symlink_path
            echo "⚠️  File exists at $symlink_path (not a symlink)"
        else
            echo "🔗 Creating symlink: $symlink_path -> $target_dir"
            ln -s $target_dir $symlink_path
        end
    end
    
    echo ""
    echo "📍 Repository location: $target_dir"
end