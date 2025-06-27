function mkcd --description 'Create and enter directory'
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory>" >&2
        return 1
    end
    
    set -l target $argv[-1]
    
    for dir in $argv
        if not mkdir -p "$dir"
            echo "Failed to create directory: $dir" >&2
            return 1
        end
    end
    
    cd "$target"; or return 1
end