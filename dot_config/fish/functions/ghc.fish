function ghc --description "Clone GitHub repo to ~/github/org/repo structure"
    if test (count $argv) -eq 0
        echo "Usage: ghc <username/repo-name> [gh-options]"
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
    if test (count $parts) -ne 2
        echo "Error: Invalid format. Use 'username/repo' or 'org-name/repo'"
        return 1
    end
    
    set -l org $parts[1]
    set -l repo $parts[2]
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