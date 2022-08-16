#!/usr/bin/env zsh

# dotfiles
ln -svf $HOME/github/dotfiles/.aliases $HOME/.aliases
ln -svf $HOME/github/dotfiles/.functions $HOME/.functions
ln -svf $HOME/github/dotfiles/.p10k.zsh $HOME/.p10k.zsh
ln -svf $HOME/github/dotfiles/.zpreztorc $HOME/.zpreztorc
ln -svf $HOME/github/dotfiles/.zprofile $HOME/.zprofile
ln -svf $HOME/github/dotfiles/.zshrc $HOME/.zshrc
ln -svf $HOME/github/dotfiles/.linux $HOME/.linux
ln -svf $HOME/github/dotfiles/.macos $HOME/.macos
ln -svf $HOME/github/dotfiles/.gitconfig $HOME/.gitconfig
ln -svf $HOME/github/dotfiles/htoprc $HOME/.config/htop/htoprc

echo "Install complete."
