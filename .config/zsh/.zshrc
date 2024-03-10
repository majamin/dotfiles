# To run the new user install script:
#   autoload -Uz zsh-newuser-install
#   zsh-newuser-install -f

HISTFILE=~/.config/zsh/.history
HISTSIZE=1000
SAVEHIST=10000
setopt autocd extendedglob notify
bindkey -v

# The following lines were added by compinstall
zstyle :compinstall filename '/home/marian/.config/zsh/.zshrc'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' cache-path "$ZDOTDIR/cache"
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=1
zstyle ':completion:*' prompt '%e'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-cache on

setopt promptsubst # required for git info to appear in prompt
export COLORTERM=truecolor
export KEYTIMEOUT=1

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -Uz vcs_info
precmd() vcs_info

source "/usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh"
source "/usr/share/fzf/key-bindings.zsh"
source "$ZDOTDIR/prompt_and_mode.zsh"     # prompt settings
source "$ZDOTDIR/myextensions.zsh"        # fzf, etc.
source "$ZDOTDIR/lscolors.sh"

alias ls="ls -hN --color=auto --group-directories-first"
mkcd() { mkdir -p $1 && cd $1 }
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias ol='grep "^(.)" ~/.local/src/oneliners.txt/oneliners.txt | fzf -e | sed -E -e "s/:/:\n/"'
alias t="tmux-sessionizer"

bindkey '^[[Z' reverse-menu-complete            # help: SHIFT-TAB ..... reverse menu complete
bindkey '^e' edit-command-line                  # help: CTRL-E ....... while in insert mode, edits the command line in vim
bindkey -s '^p' 'tmux-sessionizer^M'

# TODO: review these (they may not be useful, necessary, or functional)
# alias tf='FILE="$(fd . ~/ -H --type=f | fzf)" && if [[ -n $FILE ]]; then tmux-sessionizer "$FILE"; fi'

