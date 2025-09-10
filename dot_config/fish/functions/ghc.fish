function ghc --description "Clone GitHub repo to ~/github/org/repo structure"
    if test (count $argv) -eq 0
        echo "Usage: ghc <username/repo-name> or ghc <org-name/repo-name>"
        return 1
    end

    set -l repo_path $argv[1]
    
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
    
    # Create parent directory if needed
    mkdir -p ~/github/$org
    
    # Clone the repository
    echo "Cloning $repo_path to $target_dir..."
    gh repo clone $repo_path $target_dir
end