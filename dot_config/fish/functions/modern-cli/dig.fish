function dig --description 'Improved DNS lookup tool'
    if command_exists doggo
        command doggo $argv
    else
        command dig $argv
    end
end