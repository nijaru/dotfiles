function cat --description 'Improved cat with syntax highlighting'
    if command_exists bat
        command bat --plain --paging=never $argv
    else
        command cat $argv
    end
end