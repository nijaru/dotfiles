function edit_with_mkdir --description 'Open editor with automatic directory creation'
    set -l editor_name $argv[1]
    set -e argv[1]
    
    # Check if editor exists
    if not type -q $editor_name
        echo "Error: Editor '$editor_name' not found in PATH." >&2
        return 1
    end
    
    # If no arguments, launch the editor without opening any files
    if test (count $argv) -eq 0
        command $editor_name
        return
    end
    
    # Iterate through each argument to handle files or directories
    for arg in $argv
        if test -d "$arg"
            command $editor_name "$arg"
        else
            set -l dir (dirname "$arg")
            if test ! -d "$dir"
                mkdir -p "$dir"; and echo "Created directory: $dir"
            end
            command $editor_name "$arg"
        end
    end
end