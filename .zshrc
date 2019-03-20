if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# [ -f .aliases ] && source .aliases
# [ -f .exports ] && source .exports
# [ -f .evals ] && source .evals
# [ -f .funcs ] && source .funcs

for file in ${HOME}/.{aliases,exports,evals,funcs}; do
    [ -f "$file" ] && source "$file"
done

source ${HOME}/.linuxrc
