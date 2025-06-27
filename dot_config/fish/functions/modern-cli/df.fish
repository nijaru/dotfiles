function df --description 'Improved disk usage display'
    if command_exists duf
        command duf $argv
    else
        command df $argv
    end
end