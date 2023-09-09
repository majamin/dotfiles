HISTFILE="$ZDOTDIR/.history"
HISTSIZE=20000
SAVEHIST=20000

# User can issue help to filter "help" comments in all ZDOTDIR files
alias help='find $ZDOTDIR -maxdepth 1 -type f -not -name "*hist*" | xargs grep -Porh "(?<=# help: ).+ | tail -n +2"'

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
zstyle ':completion:*:*:git:*' script ~/.config/zsh/git-completion.bash
zstyle :compinstall filename '~/.config/zsh/.zshrc'
fpath=(~/.config/zsh $fpath)

setopt promptsubst
setopt globdots
unsetopt BEEP
export COLORTERM=truecolor
export KEYTIMEOUT=1

autoload -Uz compinit && compinit
autoload edit-command-line; zle -N edit-command-line
autoload -U colors && colors
autoload -Uz vcs_info
precmd() vcs_info

# ------------ PROMPT --------------------------------------------------------
source "$ZDOTDIR/prompt_and_mode.zsh"

# ------------ KEYBINDINGS AND MODES -----------------------------------------
bindkey '^[[Z' reverse-menu-complete            # help: SHIFT-TAB ..... reverse menu complete
bindkey '^e' edit-command-line                  # help: CTRL-E ....... while in insert mode, edits the command line in vim
bindkey '^j' forward-char                       # help: CTRL-J ....... accept autosuggestion
bindkey -s '^o' 'oneliner\n'                    # help: CTRL-O ....... opens oneliners
bindkey -s '^a' 'tmux attach-session || tmux\n' # help: CTRL-A ....... attaches to any available open tmux session
bindkey -s '^f' 'tmux-sessionizer\n'            # help: CTRL-P ....... opens a project in tmux-sessionizer

# ------------ ALIASES -------------------------------------------------------

# WARNING: Elevate privileges with?
# elevate="sudo"
elevate="doas"

# alias emerge="$elevate emerge"
alias sdn="$elevate shutdown -h now"                # help: sdn .......... shutdown now
alias reboot="$elevate reboot"                      # help: reboot ....... reboots machine

# help: yt ........... downloads videos using yt-dlp using config found in ~/.config/youtube-dl
alias yt="yt-dlp --config-location \"${XDG_CONFIG_HOME:-$HOME/.config}/youtube-dl/video.config\""

# help: yta .......... downloads audio only of videos using yt-dlp using config found in ~/.config/youtube-dl
alias yta="yt-dlp --config-location \"${XDG_CONFIG_HOME:-$HOME/.config}/youtube-dl/audio.config\""

# oneliner (alias) - greps oneliners.txt and selects a command
alias oneliner='grep "^(.)" ~/.local/src/oneliners.txt/oneliners.txt | fzf -e | sed -E -e "s/:/:\n/"'

alias ls="ls -hN --color=always --group-directories-first" # help: ls ........... ls has color and groups directories first
alias l="ls"                                       # help: l ............ alias for `ls`
alias ll="ls -SlA1"                                # help: ll ........... is an alias for `ls -SlA1`
alias la="ls -SlaA1"                               # help: l ............ is an alias for `ls -SlaA1`
alias gsu="git status -uno"                        # help: gsu .......... is an alias for `git status -uno`
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME' # help: dots ......... is an alias to handle dotfiles in a bare git repo
mkcd() { mkdir -p $1 && cd $1 }                    # help: mkcd ......... make a directory and cd into it

# ------------ BEHAVIOUR -----------------------------------------------------
#source "/usr/share/fzf/completion.zsh"
source "/usr/share/zsh/site-functions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/tmux-sessionizer.zsh"
source "$ZDOTDIR/myextensions.zsh" # fzf and more ~/.config/zsh/myextensions.zsh
source "/usr/share/fzf/key-bindings.zsh"
# help: CTRL-T ....... Select one or more files and insert them at cursor
# help: CTRL-R ....... Search command history and insert command
# help: ALT-C ........ Change to the selected directory, default command is `fd`

# ------------ COLORS --------------------------------------------------------
source "$ZDOTDIR/lscolors.sh"
zstyle ':completion:*' list-colors "${LS_COLORS}"
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
# ZSH_HIGHLIGHT_STYLES[unknown-token]=fg={#E64109} # remove that nasty red
