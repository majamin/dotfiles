# --- History ---
HISTFILE="${ZDOTDIR:-$HOME}/.history"
HISTSIZE=100000
SAVEHIST=100000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks
setopt extended_history

# --- Behavior ---
setopt autocd extendedglob globdots interactive_comments nomatch notify prompt_subst
unsetopt beep

# --- Helpers ---
soifex() {
  local f
  for f in "$@"; do
    [[ -r $f ]] && { source "$f"; return 0 }
  done
  return 1
}

dots() {
    GIT_DIR="$HOME/.dotfiles" GIT_WORK_TREE="$HOME" git "$@"
}
_dots() {
    local -x GIT_DIR="$HOME/.dotfiles"
    local -x GIT_WORK_TREE="$HOME"

    # If completing file arguments for path-heavy commands, use simple _files
    if (( CURRENT > 2 )) && [[ ${words[2]} == (add|checkout|diff|restore|rm|mv|reset) ]]; then
        _files
        return
    fi

    words[1]=git
    service=git
    _git
}

mkcd() {
  mkdir -p $1 && cd $1
}

# --- Completion ---
source "${ZDOTDIR}/LS_COLORS"
zmodload zsh/complist
setopt auto_menu
autoload -Uz compinit && compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*' menu select
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' select-prompt '%S%p%s'
zstyle ':completion:*' completer _complete _approximate
compdef _dots dots
compdef cdr

# --- Vi mode + cursor shape ---
bindkey -v
export KEYTIMEOUT=1
zle-keymap-select() { case $KEYMAP in vicmd) printf '\e[2 q';; *) printf '\e[6 q';; esac }
zle-line-init()     { printf '\e[6 q' }
zle -N zle-keymap-select
zle -N zle-line-init

# --- History search ---
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

# --- Insert-mode keys ---
autoload -Uz edit-command-line && zle -N edit-command-line
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
# bindkey -M viins '^I' complete-word
bindkey -M viins '^E' edit-command-line
bindkey -M viins '^N'   menu-complete
bindkey -M viins '^Y'   accept-and-infer-next-history

# --- Menu selection ---
bindkey -M menuselect '^N'   menu-complete
bindkey -M menuselect '^P'   reverse-menu-complete
bindkey -M menuselect '^['   undo
bindkey -M menuselect '^I'   accept-and-infer-next-history
bindkey -M menuselect '^Y'   accept-and-infer-next-history

# --- Git, prompt and colors ---
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' (%F{magenta}%b%f)'
precmd() { vcs_info }
PS1='%F{blue}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})%#%f '

# --- Aliases ---
alias ls="ls -hN --color=auto --group-directories-first"
alias o="xdg-open"
alias tj="tmux switch -t journal 2>/dev/null || tmux attach -t journal 2>/dev/null || { cd $ONEDRIVE/Projects/notes && tmux new -d -s journal nvim journal.md && t journal; }"
alias tl="tmux ls"

# --- Plugins ---
soifex "${ZDOTDIR}/t.zsh"
soifex /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh \
       /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
       /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
       /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

