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
    
    set -l files_to_edit

    # Process arguments and create directories as needed
    for arg in $argv
        if test -d "$arg"
            set -a files_to_edit "$arg"
        else
            set -l dir (dirname "$arg")
            if test ! -d "$dir"
                mkdir -p "$dir"; and echo "Created directory: $dir"
            end
            set -a files_to_edit "$arg"
        end
    end
    
    # Open all files in a single editor instance
    command $editor_name $files_to_edit
end