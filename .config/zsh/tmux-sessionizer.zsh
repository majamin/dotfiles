alias th='tmux-sessionizer "$(pwd)"'               # help: th ........... create a new tmux session in current directory
alias ta='tmux attach -t "$(tmux ls -F #S | fzf)"' # help: ta ........... attach an existing tmux session
alias tl='tmux list-sessions'                      # help: tl ........... list tmux sessions

function tns {
  # if no arguments provided,
  # create a tmux session with the name of the
  # current directory, detached
  # switch to the session and return

  # are we in a tmux session?
  local were_in_tmux=0
  if [ -n "$TMUX" ]; then
    were_in_tmux=1
  fi

  # handle no arguments
  if [ $# -eq 0 ]; then
    local session_name="$(basename "$PWD")-session"
    printf "No session name provided, creating new session with name: %s\n" "$session_name"
    tmux new-session -d -s "$session_name" && \
      if [ $were_in_tmux -eq 1 ]; then
        tmux switch-client -t "$session_name"
      else
        tmux attach-session -t "$session_name"
      fi
    return
  fi

  # handle arguments
  # Get the session name
  local session_name="$1"
  shift 2>/dev/null

  # Get the command to run
  local command_to_run="$*"

  # Shorten the command for the window name (adjust as needed)
  local window_name="${command_to_run:0:20}"
  window_name="${window_name// /}"  # Remove spaces

  # Check if the session already exists
  tmux has-session -t "$session_name" 2>/dev/null

  if [ $? != 0 ]; then
    # If the session doesn't exist, create it
    printf "Creating new session: %s\n" "$session_name"
    tmux new-session -d -s "$session_name" -n "$window_name"
    tmux send-keys -t "$session_name" "$command_to_run" C-m
  else
    # Create a new window and run the command
    local new_window_index=$(tmux new-window -t "$session_name" -n "$window_name" -P -F "#{window_index}")
    tmux send-keys -t "$session_name:$new_window_index" "$command_to_run" C-m
  fi

  # If we weren't in a tmux session to begin with, attach to the new session
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

