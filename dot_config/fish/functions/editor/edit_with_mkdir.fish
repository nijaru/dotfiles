function edit_with_mkdir --description 'Open files in editor, creating parent directories as needed'
    set -l editor $argv[1]
    set -l files $argv[2..-1]

    if test (count $files) -eq 0
        command $editor
        return
    end

    for file in $files
        set -l dir (dirname $file)
        if test "$dir" != "." -a ! -d "$dir"
            mkdir -p $dir
        end
    end

    command $editor $files
end
