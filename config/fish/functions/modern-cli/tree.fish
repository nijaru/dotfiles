function tree --description 'Directory tree view'
    if command_exists eza
        ls -T $argv
    else
        command tree $argv
    end
end