#!/usr/bin/env zsh

# dotfiles
ln -svf $HOME/github/dotfiles/.zshrc $HOME/.zshrc
ln -svf $HOME/github/dotfiles/.zshenv $HOME/.zshenv
ln -svf $HOME/github/dotfiles/.aliases $HOME/.aliases
ln -svf $HOME/github/dotfiles/.p10k.zsh $HOME/.p10k.zsh

# git
ln -svf $HOME/github/dotfiles/.gitconfig $HOME/.gitconfig

# ssh
mkdir -p $HOME/.ssh
ln -svf $HOME/github/dotfiles/.ssh/config $HOME/.ssh/config

# OS specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # linux
    ln -svf $HOME/github/dotfiles/.linux $HOME/.linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macos
    ln -svf $HOME/github/dotfiles/.macos $HOME/.macos
    # gpg
    mkdir -p $HOME/.gnupg
    ln -svf $HOME/github/dotfiles/.gnupg/gpg.conf $HOME/.gnupg/gpg.conf
    # zed
    mkdir -p $HOME/.config/zed
    ln -svf $HOME/github/dotfiles/zed/settings.json $HOME/.config/zed/settings.json
fi

echo "Install complete."
