# t -- tmux sessionizer -- quickly create and switch to tmux sessions
# Usage:
#   t [file|dir|session]
#   t <TAB>             # TAB complete on session names, files, and dirs
#
# EXAMPLES:
#   t                   # create/switch to session in current dir
#   t .                 # same as no argument
#   t /path/to/dir      # create/switch to session for that directory
#   t /path/to/file     # open editor on file in a session rooted at file's dir
#   t sessionname       # attach/create a session with that name

t() {
  emulate -L zsh
  setopt pipefail

  # --- helpers -------------------------------------------------------------
  _abs() { ( cd -- "${1:-.}" >/dev/null 2>&1 && pwd -P ) }   # portable path resolution
  _makename() {
    local abs base
    abs="$(_abs "$1")" || return 1
    base="${abs:t}"
    print -r -- "${base//[^A-Za-z0-9._-]/-}"
  }
  _has() { tmux has-session -t "=${1}" 2>/dev/null; }
  _editor() { print -r -- "${VISUAL:-${EDITOR:-nano}}"; }

  _go() {  # attach/switch + return to last window
    if [[ -n ${TMUX-} ]]; then
      tmux switch-client -t "$1" \; last-window
    else
      tmux attach -t "$1" \; last-window
    fi
  }

  # --- parse ----------------------------------------------------------------
  local arg="${1:-}"
  [[ -z "$arg" ]] && arg="$PWD"

  # Treat a spacey non-path argument list as a command
  local -a cmd=()
  if [[ ! -f "$*" && ! -d "$*" && "$*" == *" "* ]]; then
    cmd=("$@")
  fi

  local work_dir file_abs target window
  if [[ -d "$arg" ]]; then
    work_dir="$(_abs "$arg")" || return 1
    target="$(_makename "$work_dir")" || return 1
  elif [[ -f "$arg" ]]; then
    local file_abs
    file_abs="$( (cd -- "${arg:h}" && printf '%s\n' "$(pwd -P)/${arg:t}") )" || return 1
    work_dir="${file_abs:h}"
    target="$(_makename "$work_dir")" || return 1
    if (( ${#cmd} == 0 )); then
      cmd=("$(_editor)" -- "$file_abs")
    fi
  else
    work_dir="$PWD"
    target="${arg//[^A-Za-z0-9._-]/-}"
    [[ -z "$target" ]] && target="session"
  fi

  # --- act ------------------------------------------------------------------
  local existed=0
  _has "$target" && existed=1

  if (( ! existed )); then
    if [[ -n ${TMUX-} ]]; then
      # inside tmux: create detached; if we have a cmd, run it as the session's first command
      if (( ${#cmd} )); then
        tmux new-session -d -s "$target" -c "$work_dir" -- "${cmd[@]}" || return 1
      else
        tmux new-session -d -s "$target" -c "$work_dir" || return 1
      fi
    else
      # outside tmux: one-shot create-or-attach (prevents attach race)
      if (( ${#cmd} )); then
        tmux new-session -A -s "$target" -c "$work_dir" -- "${cmd[@]}" || return 1
      else
        tmux new-session -A -s "$target" -c "$work_dir" || return 1
      fi
      # If -A attached us already, we’re done
      # (When it attaches, the shell is replaced; control returns only inside tmux.)
      [[ -z ${TMUX-} ]] && return 0
    fi
    _go "$target"
    return 0
  fi

  # session exists
  if (( ${#cmd} )); then
    # open a new window in the existing session and run the command
    tmux new-window -t "$target" -c "$work_dir" -- "${cmd[@]}" >/dev/null || return 1
  fi
  _go "$target"
}

# Shell helpers

_t_list_tmux_sessions() {
  local -a s
  s=("${(@f)$(tmux list-sessions -F '#{session_name}' 2>/dev/null)}")
  (( ${#s} )) && compadd -Q -a s
}

_t_completion() {
  local token="${words[-1]}"

  # If the user is typing a path-like token, delegate to path completion only
  if [[ "$token" == (/*|~*|.*|../*) ]]; then
    _files            # includes files AND directories
    return
  fi

  # Offer sessions and paths as alternatives
  _alternative \
    'sessions:tmux sessions:_t_list_tmux_sessions' \
    'paths:files and directories:_files'
}

compdef _t_completion t
