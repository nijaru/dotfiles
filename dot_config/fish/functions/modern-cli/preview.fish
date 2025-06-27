function preview --description 'Preview files with fzf and bat'
    if command_exists fzf; and command_exists bat
        fzf --preview 'bat --color=always {}' $argv
    else
        echo "fzf or bat not found"
        return 1
    end
end