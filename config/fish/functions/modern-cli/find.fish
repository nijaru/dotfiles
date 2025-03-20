function find --description 'Improved file search'
    if command_exists fd
        command fd $argv
    else
        command find $argv
    end
end