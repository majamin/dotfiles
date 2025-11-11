# -------------------------------------------------------------------
# zsh config (cleaned)
# -------------------------------------------------------------------

HISTFILE="${ZDOTDIR}/.history"
HISTSIZE=1000
SAVEHIST=10000
setopt autocd extendedglob notify promptsubst
bindkey -v

# -------------------------------------------------------------------
# Completion config
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

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -Uz vcs_info
autoload edit-command-line; zle -N edit-command-line
compdef '_git' dots

# -------------------------------------------------------------------
# FZF config
# -------------------------------------------------------------------
BAT_THEME="OneHalfDark"
FZF_OPT_THEME=""

if command -v fd >/dev/null; then
  export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git --exclude .wine"
  export FZF_ALT_C_COMMAND="fd --hidden --follow --type d --ignore-file=${DOTFILES}/.gitignore --exclude .wine"
else
  export FZF_CTRL_T_COMMAND="find . \( -path '*/.git' -o -path '*/.wine' \) -prune -o -type f -print"
  export FZF_ALT_C_COMMAND="find . \( -path '*/.git' -o -path '*/.wine' \) -prune -o -type d -print"
fi

export FZF_DEFAULT_OPTS="
  ${FZF_OPT_THEME}
  --ansi
  --border
  --layout=reverse
  --height=70%
  --bind '?:toggle-preview'
"

if command -v bat >/dev/null; then
  export FILE_PREVIEW_COMMAND="bat --theme=${BAT_THEME} --style=numbers --color=always --line-range :500 {}"
else
  export FILE_PREVIEW_COMMAND="cat {}"
fi

export FZF_ALT_C_OPTS="--preview 'tree -L 1 -C {}'"
export FZF_CTRL_T_OPTS="--preview \"$FILE_PREVIEW_COMMAND\""

source "/usr/share/fzf/key-bindings.zsh"

# -------------------------------------------------------------------
# Plugins
# -------------------------------------------------------------------
#source "/usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh"
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null || true
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null || true

# -------------------------------------------------------------------
# Key bindings and aliases
# -------------------------------------------------------------------
bindkey '^[[Z' reverse-menu-complete
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
bindkey '^j' autosuggest-accept

alias ls="ls -hN --color=auto --group-directories-first"
alias o="xdg-open"
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
compdef dots=git

alias tj="tmux switch -t journal 2>/dev/null || tmux attach -t journal 2>/dev/null || { cd $ONEDRIVE/Projects/notes && tmux new -d -s journal nvim src/journal.adoc && t journal; }"
alias tt="tmux switch -t todo 2>/dev/null || tmux attach -t todo 2>/dev/null || { cd $ONEDRIVE/Projects/notes && tmux new -d -s todo nvim src/todo.md && t todo; }"
alias tl="tmux ls"
alias ol='grep "^(.)" ~/.local/src/oneliners.txt/oneliners.txt | fzf -e --wrap | sed -E -e "s/:/:
/"'

mkcd() { mkdir -p $1 && cd $1 }
cdf() { cd "$(dirname "$(eval $FZF_CTRL_T_COMMAND | fzf)")"; }
dotvim() {
  export GIT_DIR="$HOME/.dotfiles"
  export GIT_WORK_TREE="$HOME"
  nvim "$@"
  unset GIT_DIR GIT_WORK_TREE
}

# -------------------------------------------------------------------
# Tmux sessionizer
# -------------------------------------------------------------------
source "${ZDOTDIR}/t.zsh"

# -------------------------------------------------------------------
# Cursor shape switching in vi mode
# -------------------------------------------------------------------
function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q';;
    viins|main) echo -ne '\e[5 q';;
  esac
}
zle -N zle-keymap-select

zle-line-init() {
  zle -K viins
  echo -ne '\e[5 q'
}
zle -N zle-line-init

echo -ne '\e[5 q'

PS1='%F{blue}%~ %(?.%F{green}.%F{red})%#%f '

# bun completions
#[ -s "/home/marian/.local/share/bun/_bun" ] && source "/home/marian/.local/share/bun/_bun"
