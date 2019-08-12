if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source $HOME/.aliases
source $HOME/.linuxrc
source $HOME/.42

source $HOME/.zsh-nvm/zsh-nvm.plugin.zsh
source /usr/share/fzf/shell/key-bindings.zsh

eval "$(rbenv init -)"
eval "$(pyenv init -)" 
eval "$(pipenv --completion)"

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
  if [ ! "$1" ] ; then
    echo "You must supply a branch."
    return 0
  fi

  BRANCHES=$(git branch --list $1)
  if [ ! "$BRANCHES" ] ; then
    echo "Branch $1 does not exist."
    return 0
  fi

  git checkout "$1" && \
  git pull upstream "$1" && \
  git push origin "$1"
}

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
