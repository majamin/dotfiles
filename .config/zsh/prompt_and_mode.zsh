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

#▒▒▒▒▒▒THIS▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
# left='%m | %~'
# PS1='%K{green}$left${(l,COLUMNS-${#${(%)left}},)${${:-$branch | $vimode}//[%]/%%}}%k$ '

#▒▒▒▒▒▒OR THIS▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
(){ # local scope

  local left right invisible leftcontent

  left+='%F{#142852}%K{#7AA2F7}%B %n '
  left+="%F{#DDD}%K{#3363CC} %* "
  left+='%k %~ '

  right+='${vcs_info_msg_0_:+${vcs_info_msg_0_//[%]/%%} }'

  export VIRTUAL_ENV_DISABLE_PROMP=1
  right+='${VIRTUAL_ENV:+venv }'

  # Show error codes
  right+='%(?..%B%F{red}(%?%)%b)'

  # Defaults
  right+=$' %k%f%b'

  # Combine left and right prompt with spacing in between.
  invisible='%([BSUbfksu]|([FBK]|){*})'

  leftcontent=${(S)left//$~invisible}
  rightcontent=${(S)right//$~invisible}

  PS1="$left\${(l,COLUMNS-\${#\${(%):-$leftcontent$rightcontent}},)}$right%{"$'\n%}$ '
}

