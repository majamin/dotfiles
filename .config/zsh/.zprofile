#!/bin/sh

# Put .local/bin and all subdirectories in $PATH
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

# Default binaries
export TERMINAL="st"
export EDITOR="nvim"
export READER="zathura"
export BROWSER="firefox"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Personal Folders
export ONEDRIVE="$HOME/Maja"
export MYDATA="$ONEDRIVE/_data"
export VIDEOS="$HOME/Videos"
export MUSIC="$HOME/Music"
export SCREENSHOT_DIR="${ONEDRIVE:-$HOME}/Images/Screenshots"

# Security and secrets
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$ONEDRIVE/password-store"
export SUDO_ASKPASS="$HOME/.local/bin/sudopass"

# Go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# R
export R_ENVIRON_USER="${XDG_CONFIG_HOME:-$HOME/.config}/R/Renviron"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# LaTeX
export TEXMFHOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ruby
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# Node (NVM || NPM)
if [[ ! -f "/usr/share/nvm/init-nvm.sh" ]]; then
  export NPM_PACKAGES="${XDG_DATA_HOME:-$HOME/.local/share}/npm_packages"
  export PATH="$PATH:$NPM_PACKAGES/bin" # local package binaries
else
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
  export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
fi

export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm

# Start sway
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  while true; do wayfire 2>~/wayfire.log; done
fi
