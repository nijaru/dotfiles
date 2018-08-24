#!/usr/bin/env zsh

[[ `id -u` == 0 ]] || (echo "Must be root to run script"; exit)

# install zsh
# [[ != ]] || (echo "Must be run in zsh"; exit)

# set dns on mac
unamestr=`uname`
if [[ unamestr == 'Darwin' ]]; then
  sudo networksetup -setdnsservers "Wi-Fi" 1.1.1.1 1.0.0.1 2001:2001:: 2001:2001:2001::
fi

# mkdirs
mkdir ~/github
mkdir ~/go

# install prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
# install vimrc
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
# install prelude
curl -L https://git.io/epre | sh
# sethosts
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee -a /etc/hosts
