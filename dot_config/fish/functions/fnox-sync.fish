function fnox-sync --description 'Sync fnox secrets to chezmoi and push'
    cp ~/.config/fnox/config.toml ~/.local/share/chezmoi/dot_config/fnox/
    cd ~/.local/share/chezmoi && git add dot_config/fnox/config.toml && git commit -m "Sync fnox secrets" && git push
    cd -
end
