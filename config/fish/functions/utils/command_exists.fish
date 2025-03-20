function command_exists --description 'Check if a command exists in PATH'
    type -q $argv[1]
end