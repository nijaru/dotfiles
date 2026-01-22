function ghc --description "Clone GitHub repo to ~/github/org/repo structure"
    # 1. Faster defaults: no network request for your own username
    set -l default_org "nijaru"
    
    if test (count $argv) -eq 0
        echo "Usage: ghc <repo> [gh-options]"
        return 1
    end

    # 2. Extract the repo target (handle options vs positional)
    set -l repo_target ""
    set -l extra_args
    for arg in $argv
        if string match -q -- "-*" $arg
            set -a extra_args $arg
        else if test -z "$repo_target"
            set repo_target $arg
        else
            set -a extra_args $arg
        end
    end

    # 3. Clean the path using regex (handles https, ssh, and trailing .git)
    # This turns 'https://github.com/org/repo.git' -> 'org/repo'
    # Or just 'repo' -> 'repo'
    set -l cleaned (string replace -r '^.*github\.com[:/]([^/]+/[^/]+?)(\.git)?$' '$1' $repo_target)
    
    # 4. Split and logic
    set -l parts (string split "/" $cleaned)
    set -l org
    set -l repo

    if test (count $parts) -eq 1
        set org $default_org
        set repo $parts[1]
    else if test (count $parts) -eq 2
        set org $parts[1]
        set repo $parts[2]
    else
        echo "Error: Invalid format. Use 'repo', 'org/repo' or a GitHub URL."
        return 1
    end

    set -l target_dir ~/github/$org/$repo
    
    # Check if directory already exists
    if test -d $target_dir
        echo "Directory $target_dir already exists"
        cd $target_dir
        return 0
    end

    # Create parent directory if needed
    mkdir -p ~/github/$org

    # Clone the repository
    echo "Cloning $org/$repo to $target_dir..."
    command gh repo clone "$org/$repo" "$target_dir" $extra_args

    # cd into the directory if clone succeeded
    and cd $target_dir
end