# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source ~/.p10k.zsh
source $HOME/.zsh-nvm/zsh-nvm.plugin.zsh
source /usr/share/fzf/shell/key-bindings.zsh

source $HOME/.aliases
source $HOME/.functions
source $HOME/.linuxrc

# eval "$(rbenv init -)"
# eval "$(pyenv init -)"
# eval "$(pipenv --completion)"