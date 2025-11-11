# t -- tmux sessionizer
# Usage:
#   t [dir|file|session|cmd...]

t() {
  command -v tmux >/dev/null || { echo "tmux not found"; return 1; }

  local target_dir target_session open_file
  local -a run_cmd final_cmd

  if [[ $# -eq 0 ]]; then
    target_dir="$PWD"
  elif [[ $# -eq 1 ]]; then
    if [[ -d "$1" ]]; then
      target_dir="$(cd "$1" && pwd -P)"
    elif [[ -f "$1" ]]; then
      target_dir="$(cd "$(dirname "$1")" && pwd -P)"
      open_file="$target_dir/$(basename "$1")"
    else
      target_session="$1"
      target_dir="$PWD"
    fi
  else
    run_cmd=("$@")
    target_dir="$PWD"
  fi

  if [[ -z "$target_session" ]]; then
    target_session="$(basename "$target_dir" | tr -cd 'A-Za-z0-9._-')"
    [[ -z "$target_session" ]] && target_session="root"
  fi

  local session_exists=false
  tmux has-session -t "=$target_session" 2>/dev/null && session_exists=true

  [[ -n "$open_file" ]] && final_cmd=("${VISUAL:-${EDITOR:-nvim}}" "$open_file")
  [[ ${#run_cmd[@]} -gt 0 ]] && final_cmd=("${run_cmd[@]}")

  if [[ "$session_exists" == "false" ]]; then
    if [[ -n "$TMUX" ]]; then
      tmux new-session -d -s "$target_session" -c "$target_dir"
      if [[ ${#final_cmd[@]} -gt 0 ]]; then
        for arg in "${final_cmd[@]}"; do
          tmux send-keys -t "$target_session:" -l "$arg"
          tmux send-keys -t "$target_session:" Space
        done
        tmux send-keys -t "$target_session:" Enter
      fi
      tmux switch-client -t "$target_session"
    else
      if [[ ${#final_cmd[@]} -gt 0 ]]; then
        local cmd_str=""
        for arg in "${final_cmd[@]}"; do
          cmd_str+="'${arg//\'/\'\\\'\'}' "
        done
        tmux new-session -d -s "$target_session" -c "$target_dir" \; \
             send-keys -t "$target_session:" "$cmd_str" Enter \; \
             attach-session -t "$target_session"
      else
        tmux new-session -s "$target_session" -c "$target_dir"
      fi
    fi
  else
    if [[ ${#final_cmd[@]} -gt 0 ]]; then
      tmux new-window -t "$target_session:" -c "$target_dir"
      for arg in "${final_cmd[@]}"; do
        tmux send-keys -t "$target_session:" -l "$arg"
        tmux send-keys -t "$target_session:" Space
      done
      tmux send-keys -t "$target_session:" Enter
    fi
    [[ -n "$TMUX" ]] && tmux switch-client -t "$target_session" || tmux attach-session -t "$target_session"
  fi
}

_t_completion() {
  local -a sessions
  command -v tmux >/dev/null 2>&1 && sessions=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"})
  _alternative 'sessions:tmux sessions:compadd -a sessions' 'files:files and directories:_files'
}

compdef _t_completion t
