#!/usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source $HOME/.p10k.zsh
source $HOME/.zsh-nvm/zsh-nvm.plugin.zsh
- [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.aliases
source $HOME/.functions
source $HOME/.macrc

# eval "$(rbenv init -)"
# eval "$(pyenv init -)"
# eval "$(pipenv --completion)"
