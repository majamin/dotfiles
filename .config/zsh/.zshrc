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
compdef _t_complete t

# -------------------------------------------------------------------
# FZF config
# -------------------------------------------------------------------
BAT_THEME="OneHalfDark"
FZF_OPT_THEME=""

if command -v fd >/dev/null; then
  export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git --exclude .wine"
  export FZF_ALT_C_COMMAND="fd --hidden --follow --type d --ignore-file=${DOTFILES}/.gitignore --exclude .wine"
else
  export FZF_CTRL_T_COMMAND="find . -type f -not -path '*/.git/*' -o -not -path '*/.wine/*'"
  export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*' -o -not -path '*/.wine/*'"
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
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

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

alias tj="tmux switch -t notes 2>/dev/null || { cd $ONEDRIVE/Projects/notes && tmux new -d -s notes nvim src/notes.adoc && t notes; }"
alias tl="tmux ls"
alias ol='grep "^(.)" ~/.local/src/oneliners.txt/oneliners.txt | fzf -e --wrap | sed -E -e "s/:/:
/"'

mkcd() { mkdir -p $1 && cd $1 }
cdf() { cd "$(dirname "$(eval $FZF_CTRL_T_COMMAND | fzf)")"; }

# -------------------------------------------------------------------
# Tmux sessionizer
# -------------------------------------------------------------------
t() {
  local s target
  [[ $# -gt 1 ]] && echo "too many args" && return 1
  s="${1:-$(basename "$PWD")}"
  s="${s//[\(\)\.:]/_}"

  if tmux has-session -t "$s" 2>/dev/null; then
    if [[ -n "$TMUX" ]]; then
      target=$(tmux display-message -p '#{client_tty}')
      tmux switch-client -t "$s"
    else
      tmux attach-session -t "$s"
    fi
  else
    tmux new-session -s "$s"
  fi
}

_t_complete() {
  local -a sessions
  sessions=(${(@f)$(tmux list-sessions -F "#{session_name}" 2>/dev/null)})
  compadd -a sessions
}

# list_tmux_sessions() {
#   [[ -n $(tmux list-sessions 2>/dev/null) ]] && print -P "| %F{2}%f $(tmux list-sessions -F '#{session_name}' | tr '\n' ' ')"
# }

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

# -------------------------------------------------------------------
# Prompt
# -------------------------------------------------------------------
# zstyle ':vcs_info:*' actionformats \
#   "%F{7}(%f%s%F{7})%F{6}-%F{7}[%F{1}%b%F{6}|%F{1}%a%F{7}]%f"
# zstyle ':vcs_info:*' formats \
#   "%F{7}(%f%s%F{7})%F{6}-%F{7}[%F{1}%b%F{7}]%f"
# zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b%F{1}:%F{6}%r"
#
# prompt_left() {
#   vcs_info
#   local sessions="" current_session=""
#   if [[ -n "$TMUX" ]]; then
#     current_session="$(tmux display-message -p '#S')"
#   fi
#   if [[ -n $(tmux list-sessions 2>/dev/null) ]]; then
#     for s in $(tmux list-sessions -F '#{session_name}'); do
#       if [[ "$s" == "$current_session" ]]; then
#         sessions+=" %F{3}${s}%f"  # yellow
#       else
#         sessions+=" %F{7}${s}%f"  # dim gray
#       fi
#     done
#     sessions="%F{7}[${sessions} ]%f "
#   fi
#   echo "${sessions}%F{6}%3~%f"
# }
#
# PROMPT='$(prompt_left)
# %F{3}%(!.#.$)%f '
#
# preexec() {
#   echo -ne '\e[5 q'
#   timer=${timer:-$SECONDS}
# }
#
# precmd() {
#   vcs_info
#   local sessions=""
#   if [[ -n $(tmux list-sessions 2>/dev/null) ]]; then
#     sessions="| %F{2}\uEBF8%f $(tmux list-sessions -F '#{session_name}' | tr '\n' ' ')"
#   fi
#   LPROMPT="%F{7}[ %F{6}%n %F{7}${sessions}%F{7}] %F{6}%3~"
#   if [[ -n $timer ]]; then
#     RPROMPT="%F{cyan}$(($SECONDS - $timer))s %{$reset_color%}${vcs_info_msg_0_}"
#     unset timer
#   else
#     RPROMPT="${vcs_info_msg_0_}"
#   fi
# }
#
