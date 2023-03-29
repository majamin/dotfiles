HISTFILE="$ZDOTDIR/.history"
HISTSIZE=20000
SAVEHIST=20000

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

unsetopt BEEP
setopt globdots
export COLORTERM=truecolor

autoload -Uz compinit && compinit
autoload edit-command-line; zle -N edit-command-line
autoload -U colors && colors

DATE=$(date +"%b %d, %Y - %H:%M:%S")
TMUX_SESSION_NAME=$(for s in $(tmux list-sessions -F '#{session_name}' 2>/dev/null); do
    tmux list-panes -F '#{pane_tty} #{session_name}' -t "$s"
done | grep "$(tty)" | awk '{print $2}')
[[ -n "$TMUX_SESSION_NAME" ]] && \
    TMUX_SESSION_NAME="(${TMUX_SESSION_NAME}) "

print -P "Hi \e[0;33m%n\e[0m. $DATE"
print -P "This is the \e[0;33mzsh\e[0m shell on \e[0;33m%m\e[0m."
print -P "Type \"help\" for some useful commands."
NEWL=$'\n'
PROMPT="%B%F{#666666}%~%b${NEWL}%F{#8BE9FD}${TMUX_SESSION_NAME}%F{#FFE531}$%f "

# ------------ KEYBINDINGS AND MODES -----------------------------------------
bindkey '^e' edit-command-line                  # help: CTRL-E ....... while in insert mode, edits the command line in vim
bindkey '^l' forward-char                       # help
bindkey -s '^o' 'oneliner\n'                    # help: CTRL-O ....... opens oneliners
bindkey -s '^a' 'tmux attach-session || tmux\n' # help: CTRL-A ....... attaches to any available open tmux session
bindkey -s '^f' 'tmux-sessionizer\n'            # help: CTRL-P ....... opens a project in tmux-sessionizer
source "$ZDOTDIR/vimin.zsh"                     # vim keybindings for vim

# ------------ ALIASES -------------------------------------------------------
alias help='find $ZDOTDIR -maxdepth 1 -type f -not -name "*hist*" | xargs grep -Porh "(?<=# help: ).+"'
alias pacman="sudo pacman"
alias sdn='sudo shutdown -h now'                # help: sdn .......... shutdown now
alias reboot='sudo reboot'                      # help: reboot ....... reboots machine

# help: yt ........... downloads videos using yt-dlp using config found in ~/.config/youtube-dl
alias yt="yt-dlp --config-location \"${XDG_CONFIG_HOME:-$HOME/.config}/youtube-dl/video.config\""

# help: yta .......... downloads audio only of videos using yt-dlp using config found in ~/.config/youtube-dl
alias yta="yt-dlp --config-location \"${XDG_CONFIG_HOME:-$HOME/.config}/youtube-dl/audio.config\""

# oneliner (alias) - greps oneliners.txt and selects a command
alias oneliner='grep "^(.)" ~/Maja/Projects/oneliners.txt/oneliners.txt | fzf -e | sed -E -e "s/:/:\n/"'

alias ls="ls -hN --color=always --group-directories-first" # help: ls ........... ls has color and groups directories first
alias l="ls"                                    # help: l ............ alias for `ls`
alias ll="ls -SlA1"                             # help: ll ........... is an alias for `ls -SlA1`
alias la="ls -SlaA1"                            # help: l ............ is an alias for `ls -SlaA1`
alias gsu="git status -uno"                     # help: gsu .......... is an alias for `git status -uno`
alias th='tmux new -s $(basename $(pwd))'       # help: th ........... create a new tmux session in current directory
alias ta='tmux attach -t "$(tmux ls -F #S | fzf)"' # help: ta ........... attach an existing tmux session
alias tl='tmux list-sessions'                   # help: tl ........... list tmux sessions
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME' # help: dots ......... is an alias to handle dotfiles in a bare git repo
mkcd() { mkdir -p $1 && cd $1 }                 # help: mkcd ......... make a directory and cd into it

# ------------ BEHAVIOUR -----------------------------------------------------
#source "/usr/share/fzf/completion.zsh"
#source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/myextensions.zsh" # fzf and more ~/.config/zsh/myextensions.zsh
source "/usr/share/fzf/key-bindings.zsh"
# help: CTRL-T ....... Select one or more files and insert them at cursor
# help: CTRL-R ....... Search command history and insert command
# help: ALT-C ________ Change to the selected directory, default command is `fd`

# ------------ COLORS --------------------------------------------------------
# source "$ZDOTDIR/COLORS" # generated by vivid
zstyle ':completion:*' list-colors "${LS_COLORS}"
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=none # remove that nasty red
