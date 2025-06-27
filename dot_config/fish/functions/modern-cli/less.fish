function less --description 'Improved pager with syntax highlighting'
    if command_exists moar
        command moar $argv
    else
        command less $argv
    end
end