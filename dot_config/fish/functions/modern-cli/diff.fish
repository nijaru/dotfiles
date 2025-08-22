function diff --description 'Improved diff display'
    if command_exists delta
        command delta $argv
    else
        command diff $argv
    end
end