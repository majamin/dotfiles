FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-messages --smart-case --glob '!{.git,node_modules,build,.idea}'"
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_ALT_C_COMMAND="fd -H -td -d4"

FZF_DEFAULT_OPTS='
--ansi
--border
--layout=reverse
--height 50%
--color fg:15,fg+:15,bg+:239,hl+:108
--color info:2,prompt:109,spinner:2,pointer:168,marker:168
'

_fzf_compgen_path() {
	rg -j0 --files --hidden --glob '!{.git,node_modules,build,.idea}' --column --line-number --no-heading --smart-case
	}

_fzf_compgen_dir() {
	rg -j0 --sort accessed --files --hidden --glob '!{.git,node_modules,build,.idea}' --column --line-number --no-heading --smart-case --null | xargs -0 dirname
	}

# pass arguments on to command line
# help: f() .......... fzf pass selected files as arguments to command (e.g. f mv)
f() {
    sels=( "${(@f)$(fd -H -d1 "${@:2}"| fzf -m)}" )
    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

# help: fgr() ........ fzf select local and remote git branches
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# help: fcd() ........ change directory to file, run fzf if no file argument provided
cdf () {
	if [[ -e "$1" ]]
	then
		cd $(dirname "$1")
	else
		thefile=$(rg -j0 --hidden --no-messages --smart-case --files -g '!{.git,node_modules,build,.idea,.npm,.cache,.bundle,cache}' . | fzf)
		[[ -z $thefile ]] && return 1
		printf '%s\n\e[1;34m%-6s\e[m\n' "You are now in the same directory as" "$thefile"
		cd $(dirname $thefile)
	fi
}

# help: lfcd() ....... open lf, but also cd to the directory that was open when lf closes
lfcd () {
	tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		if [ -d "$dir" ]; then
			if [ "$dir" != "$(pwd)" ]; then
				cd "$dir"
			fi
		fi
	fi
}
