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

fpath+=~/.zfunc
autoload -Uz compinit && compinit

source "$HOME/.p10k.zsh"

source "$HOME/.aliases"
source "$HOME/.functions"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source "$HOME/.linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source "$HOME/.macos"
fi

if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi

source "$HOME/.cargo/env"

export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"

eval "$(mise activate zsh)"

autoload -U bashcompinit
bashcompinit

eval "$(register-python-argcomplete pipx)"
