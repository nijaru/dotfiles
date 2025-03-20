function diff --description 'Improved diff with syntax highlighting'
    if command_exists delta
        command delta $argv
    else
        command diff $argv
    end
end