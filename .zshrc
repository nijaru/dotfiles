if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

for file in ~/.{aliases, exports, functions}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done

unamestr=`uname`
if [[ unamestr == 'Darwin' ]]; then
	source .macrc
fi

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# eval "$(pipenv --completion)"
