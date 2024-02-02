#!/usr/bin/env zsh

# dotfiles
ln -svf $HOME/github/dotfiles/home/.zshrc $HOME/.zshrc
ln -svf $HOME/github/dotfiles/home/.zshenv $HOME/.zshenv
ln -svf $HOME/github/dotfiles/home/.aliases $HOME/.aliases
ln -svf $HOME/github/dotfiles/home/.p10k.zsh $HOME/.p10k.zsh

# git
ln -svf $HOME/github/dotfiles/home/.gitconfig $HOME/.gitconfig

# ssh
mkdir -p $HOME/.ssh
ln -svf $HOME/github/dotfiles/home/.ssh/config $HOME/.ssh/config

# OS specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ln -svf $HOME/github/dotfiles/home/.linux $HOME/.linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ln -svf $HOME/github/dotfiles/home/.macos $HOME/.macos
    mkdir -p $HOME/.gnupg
    ln -svf $HOME/github/dotfiles/home/.gnupg/gpg.conf $HOME/.gnupg/gpg.conf
fi

echo "Install complete."
