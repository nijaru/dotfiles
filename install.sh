#!/usr/bin/env zsh

ln -svf $HOME/github/dotfiles/.aliases $HOME/.aliases
ln -svf $HOME/github/dotfiles/.functions $HOME/.functions
ln -svf $HOME/github/dotfiles/.p10k.zsh $HOME/.p10k.zsh
ln -svf $HOME/github/dotfiles/.zpreztorc $HOME/.zpreztorc
ln -svf $HOME/github/dotfiles/.zprofile $HOME/.zprofile
ln -svf $HOME/github/dotfiles/.zshrc $HOME/.zshrc
ln -svf $HOME/github/dotfiles/.linuxrc $HOME/.linuxrc
ln -svf $HOME/github/dotfiles/.macrc $HOME/.macrc
ln -svf $HOME/github/dotfiles/.gitconfig $HOME/.gitconfig
ln -svf $HOME/github/dotfiles/vimrc $HOME/.vim/vimrc
ln -svf $HOME/github/dotfiles/init.toml $HOME/.Spacevim.d/init.toml

echo "Install complete."