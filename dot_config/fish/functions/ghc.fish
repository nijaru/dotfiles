function ghc --description "Clone GitHub repo to ~/github/org/repo structure"
    if test (count $argv) -eq 0
        echo "Usage: ghc <repo-name> [gh-options]"
        echo "       ghc <username/repo-name> [gh-options]"
        echo "       ghc <https://github.com/username/repo> [gh-options]"
        return 1
    end

    set -l repo_path $argv[1]
    set -l extra_args $argv[2..-1]
    
    # Strip GitHub URL prefix if present
    set repo_path (string replace "https://github.com/" "" $repo_path)
    set repo_path (string replace "git@github.com:" "" $repo_path)
    set repo_path (string replace --regex '\.git$' "" $repo_path)
    
    # Extract org/user and repo name
    set -l parts (string split "/" $repo_path)
    set -l org
    set -l repo

    # Default to user's GitHub username if no username provided
    if test (count $parts) -eq 1
        set org (gh api user --jq .login 2>/dev/null || echo "nijaru")
        set repo $parts[1]
    else if test (count $parts) -eq 2
        set org $parts[1]
        set repo $parts[2]
    else
        echo "Error: Invalid format. Use 'repo-name' or 'username/repo'"
        return 1
    end

    set -l target_dir ~/github/$org/$repo
    
    # Check if directory already exists
    if test -d $target_dir
        echo "Directory $target_dir already exists"
        return 1
    end
    
    # Check if gh is available
    if not command -q gh
        echo "Error: gh CLI not found. Install with: brew install gh"
        return 1
    end
    
    # Create parent directory if needed
    mkdir -p ~/github/$org
    
    # Clone the repository
    echo "Cloning $org/$repo to $target_dir..."
    gh repo clone "$org/$repo" "$target_dir" $extra_args

    # cd into the directory if clone succeeded
    and cd $target_dir
end