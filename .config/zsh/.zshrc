# -------------------------------------------------------------------
# zsh config
# -------------------------------------------------------------------

# NOTE: Create the file $ZDOTDIR/set-light-theme
#       if you're using a light theme in the terminal.

HISTFILE="${ZDOTDIR}/.history"
IGNOREFILE="${DOTFILES}/.gitignore"
HISTSIZE=1000
SAVEHIST=10000
setopt autocd extendedglob notify
bindkey -v

# -------------------------------------------------------------------
# ZSH options
# To run the new user install script:
#   autoload -Uz zsh-newuser-install
#   zsh-newuser-install -f
# -------------------------------------------------------------------
zstyle :compinstall filename "${ZDOTDIR}/.zshrc"
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' cache-path "${ZDOTDIR}/cache"
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=1
zstyle ':completion:*' prompt '%e'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-cache on
zstyle ':completion:*:cd:*' ignore-parents parent pwd

setopt promptsubst # required for git info to appear in prompt

# export COLORTERM=truecolor
export KEYTIMEOUT=1

autoload edit-command-line; zle -N edit-command-line
autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -Uz vcs_info
compdef '_git' dots

# -------------------------------------------------------------------
# Change cursor shape for different vi modes.
# -------------------------------------------------------------------
# help: vi-mode ............. press <ESC>, etc, to interact in vi-mode
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# -------------------------------------------------------------------
# Tmux things
# -------------------------------------------------------------------
t() { # mini sessionizer
  if [ "$#" -gt 1 ]; then
    echo "t - make and attach to tmux sessions"
    echo "Usage: create a new session in this directory or a new window if in tmux already"
    echo "       t"
    echo "Usage: attach to <session_name> - use TAB to autocomplete."
    echo "       t <session_name>"
    return 1
  elif [ "$#" -eq 1 ]; then
    tmux attach-session -t "$1" || \
      tmux switch-client -t "$1" 2>/dev/null
  else
    if [ -n "$TMUX" ]; then
      # we're inside of tmux:
      tmux new-window
    else
      session_name="$(basename "$(pwd)")"
      tmux new -s "$session_name" || \
        tmux attach-session -t "$session_name" || \
        tmux switch-client -t "$session_name"
    fi
  fi
}

_t_complete() {
    # Get a list of tmux sessions, replacing newlines with spaces for Zsh completion
    local -a _sessions
    IFS=$'\n'
    _sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
    compadd -a _sessions
}
compdef _t_complete t

list_tmux_sessions() {
  if [[ -n $(tmux list-sessions 2>/dev/null) ]]; then
    print -P "| %F{2}%{$reset_color%} $(tmux list-sessions -F \#{session_name} | tr '\n' ' ')"
  fi
}

# -------------------------------------------------------------------
# Colours for ls, fzf, bat, etc.
# -------------------------------------------------------------------
if [[ -f "${ZDOTDIR}/set-light-theme" ]]; then
  export FZF_OPT_THEME="--color=light"
  BAT_THEME="GitHub"
else
  BAT_THEME="OneHalfDark"
fi

# -------------------------------------------------------------------
# Prompt -> timer + version control info
# -------------------------------------------------------------------

# Right prompt empty (we'll fill it later)
RPROMPT=''

function preexec() {
  timer=${timer:-$SECONDS}
}

precmd() {
  vcs_info
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    RPROMPT="%F{cyan}${timer_show}s %{$reset_color%} ${vcs_info_msg_0_}"
    unset timer
  else
    RPROMPT="${vcs_info_msg_0_}"
  fi
}

# Run the script ~/.local/bin/demo-colors
# to customize the colours of the prompt.
# TODO: this is ugly as f*ck - can we simplify this?
if [[ -f "${ZDOTDIR}/set-light-theme" ]]; then
  zstyle ':vcs_info:*' actionformats \
      '%F{8}(%f%s%F{8})%F{6}-%F{0}[%F{1}%b%F{6}|%F{1}%a%F{0}]%f '
  zstyle ':vcs_info:*' formats       \
    '%F{8}(%f%s%F{8})%F{6}-%F{8}[%F{1}%b%F{8}]%f '
  zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{6}%r'
    PS1='%F{8}[ %F{5}%n %F{8}$(list_tmux_sessions)%F{8}] %F{6}%3~
%F{9}%(!.#.$)%f '
else
  zstyle ':vcs_info:*' actionformats \
      '%F{7}(%f%s%F{7})%F{6}-%F{7}[%F{1}%b%F{6}|%F{1}%a%F{7}]%f '
  zstyle ':vcs_info:*' formats       \
      '%F{7}(%f%s%F{7})%F{6}-%F{7}[%F{1}%b%F{7}]%f '
  zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{6}%r'
  PS1='%F{4}[ %F{7}%n %F{4}$(list_tmux_sessions)%F{4}] %F{6}%3~
%F{3}%(!.#.$)%f '
fi

# -------------------------------------------------------------------
# fzf - the selection assistant!
# -------------------------------------------------------------------

# Do we have fd?
if $(command -v fd > /dev/null); then
  export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
else
  export FZF_CTRL_T_COMMAND="find . -type f -not -path '*/\.git/*'"
fi

export FZF_DEFAULT_OPTS="\
  ${FZF_OPT_THEME} \
  --ansi \
  --border \
  --layout=reverse --height 70% \
  --bind '?:toggle-preview' \
  "

if $(command -v bat > /dev/null); then
  export FILE_PREVIEW_COMMAND="\
    bat \
    --theme=${BAT_THEME} \
    --style=numbers \
    --color=always \
    --line-range :500 {} \
    "
else
  export FILE_PREVIEW_COMMAND="cat {}"
fi

export FZF_ALT_C_COMMAND="fd --hidden --follow --type d --ignore-file=${IGNOREFILE}"
export FZF_ALT_C_OPTS="--preview 'tree -L 1 -C {}'"
export FZF_CTRL_T_OPTS="--preview \"$FILE_PREVIEW_COMMAND\""

# Gentoo:
#source "/usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh"

# Arch:
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/usr/share/fzf/key-bindings.zsh"

# bun completions
[ -s "$HOME/.local/share/bun/_bun" ] && \
  source "$HOME/.local/share/bun/_bun"

# -------------------------------------------------------------------
# Aliases, helper functions, and key bindings
# -------------------------------------------------------------------
alias ls="ls -hN --color=auto --group-directories-first"

# Personal
alias tj="cd $ONEDRIVE/Projects/notes && tn 'nvim -S'" # tmux journal
alias ol='grep "^(.)" ~/.local/src/oneliners.txt/oneliners.txt | fzf -e --wrap | sed -E -e "s/:/:\n/"'

mkcd() { mkdir -p $1 && cd $1 }

bindkey '^[[Z' reverse-menu-complete            # help: SHIFT-TAB ..... reverse menu complete
bindkey '^e' edit-command-line                  # help: CTRL-E ....... while in insert mode, edits the command line in vim
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

