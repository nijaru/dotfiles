function tmpd --description 'Create and enter a temporary directory'
    set -l prefix $argv[1]
    test -z "$prefix"; and set prefix "tmp"
    
    set -l dir (mktemp -d 2>/dev/null; or mktemp -d -t "$prefix")
    
    if test ! -d "$dir"
        echo "Failed to create temporary directory" >&2
        return 1
    end
    
    echo "Created temporary directory: $dir"
    cd "$dir"; or return 1
end