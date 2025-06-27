function ls --description 'Improved directory listing'
    if command_exists eza
        command eza --icons --git $argv
    else
        command ls $argv
    end
end