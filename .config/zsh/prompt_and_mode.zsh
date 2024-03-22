vimode=insert

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    oldmode=vimode
    case $KEYMAP in
      (vicmd)
          vimode=normal
          echo -ne '\e[1 q'
          ;;
      (viins|main)
          vimode=insert
          echo -ne '\e[5 q'
          ;;
      (*)
          vimode=overwrite
          echo -ne '\e[4 q'
          ;;
    esac
    [[ $mode = $oldmode ]] || zle reset-prompt
}

function zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}

function beam_cursor() { echo -ne '\e[5 q' ;}
zle -N zle-keymap-select
zle -N zle-line-init
beam_cursor

(){
# Define a function that retrieves the current git branch and latest commit hash
function git_info {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        local hash
        hash=$(git rev-parse --short HEAD)
        echo "$branch@$hash"
    fi
}

# Set the PROMPT variable to the desired format
PROMPT='%F{#29A4BD}%n%f %~
%(?..%B(%?%)%b )%F{#FF9E64}%(!.#.$)%f '

# Set the RPROMPT variable to an empty string (we'll use it for the git info)
RPROMPT=''

# Define a preexec hook that sets the start time of the command
function preexec {
    CMD_START_TIME=$(date +%s)
}

# Define a precmd hook that updates the RPROMPT variable with git info
# before each command, and sets the CMD_DURATION variable with the
# duration of the previous command
function precmd {
    RPROMPT='$CMD_DURATION %F{#A9B1D6}$(git_info)%f'
    if [ -n "$CMD_START_TIME" ]; then
        CMD_END_TIME=$(date +%s)
        CMD_DURATION=$((CMD_END_TIME - CMD_START_TIME))
        unset CMD_START_TIME
        if [ "$CMD_DURATION" -gt 0 ]; then
            local hours=$((CMD_DURATION / 3600))
            local minutes=$((CMD_DURATION % 3600 / 60))
            local seconds=$((CMD_DURATION % 60))
            if [ "$hours" -gt 0 ]; then
                CMD_DURATION=$(printf "%dh%dm%ds" $hours $minutes $seconds)
            elif [ "$minutes" -gt 0 ]; then
                CMD_DURATION=$(printf "%dm%ds" $minutes $seconds)
            else
                CMD_DURATION=$(printf "%ds" $seconds)
            fi
        else
            CMD_DURATION=''
        fi
    else
        CMD_DURATION=''
    fi
}

}
