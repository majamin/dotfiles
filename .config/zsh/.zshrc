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
# Colours for ls, fzf, bat, etc.
# -------------------------------------------------------------------
if [[ -f "${ZDOTDIR}/set-light-theme" ]]; then
#   source "${ZDOTDIR}/LS_COLORS_LIGHT"
  export FZF_OPT_THEME="--color=light"
  BAT_THEME="GitHub"
else
#   source "${ZDOTDIR}/LS_COLORS_DARK"
  BAT_THEME="OneHalfDark"
fi

# -------------------------------------------------------------------
# Prompt -> timer + version control info
# -------------------------------------------------------------------

# Right prompt
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
# TODO: simplify this by predefining the colours
if [[ -f "${ZDOTDIR}/set-light-theme" ]]; then
  zstyle ':vcs_info:*' actionformats \
      '%F{8}(%f%s%F{8})%F{6}-%F{0}[%F{1}%b%F{6}|%F{1}%a%F{0}]%f '
  zstyle ':vcs_info:*' formats       \
      '%F{8}(%f%s%F{8})%F{6}-%F{8}[%F{1}%b%F{8}]%f '
  zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{6}%r'
    PS1='%F{8}[%F{5}%n%F{8}] %F{6}%3~
%F{9}%(!.#.$)%f '
else
  zstyle ':vcs_info:*' actionformats \
      '%F{7}(%f%s%F{7})%F{6}-%F{7}[%F{1}%b%F{6}|%F{1}%a%F{7}]%f '
  zstyle ':vcs_info:*' formats       \
      '%F{7}(%f%s%F{7})%F{6}-%F{7}[%F{1}%b%F{7}]%f '
  zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{6}%r'
  PS1='%F{4}[%F{7}%n%F{4}] %F{6}%3~
%F{3}%(!.#.$)%f '
fi

# -------------------------------------------------------------------
# fzf
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

#source "/usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "/usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh" # Gentoo
source "/usr/share/fzf/key-bindings.zsh"

# -------------------------------------------------------------------
# Aliases, helper functions, and key bindings
# -------------------------------------------------------------------
alias t="tmux-sessionizer"
alias tl="tmux list-sessions && tmux attach-session"
alias ls="ls -hN --color=auto --group-directories-first"
# alias dots='/usr/bin/git --git-dir=$HOME/.local/src/dotfiles/.git --work-tree=$HOME'

# Personal
alias tj="tmux-sessionizer -w $ONEDRIVE/Projects/notes -c 'cd $ONEDRIVE/Projects/notes && nvim ./src/notes.adoc'"
alias ol='grep "^(.)" ~/.local/src/oneliners.txt/oneliners.txt | fzf -e --wrap | sed -E -e "s/:/:\n/"'

mkcd() { mkdir -p $1 && cd $1 }

bindkey '^[[Z' reverse-menu-complete            # help: SHIFT-TAB ..... reverse menu complete
bindkey '^e' edit-command-line                  # help: CTRL-E ....... while in insert mode, edits the command line in vim
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

bindkey -s '^p' 'tmux-sessionizer^M'

# bun completions
[ -s "$HOME/.local/src/dotfiles/.local/share/bun/_bun" ] && source "$HOME/.local/src/dotfiles/.local/share/bun/_bun"
