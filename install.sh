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
# config
ln -svf $HOME/github/dotfiles/htoprc $HOME/.config/htop/htoprc
# vim
# ln -svf $HOME/github/dotfiles/vimrc $HOME/.vim/vimrc
# ln -svf $HOME/github/dotfiles/init.toml $HOME/.Spacevim.d/init.toml
# emacs
ln -svf $HOME/github/dotfiles/.doom.d/config.el $HOME/.doom.d/config.el
ln -svf $HOME/github/dotfiles/.doom.d/init.el $HOME/.doom.d/init.el
ln -svf $HOME/github/dotfiles/.doom.d/packages.el $HOME/.doom.d/packages.el

echo "Install complete."