#!/bin/sh

# Put .local/bin and all subdirectories in $PATH
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

# WSL Windows paths if in WSL
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
  export PATH="$PATH:/mnt/c/Windows:/mnt/c/Windows/System32"
  export PATH="$PATH:$(find /mnt/c/Users/*/AppData/Local/Microsoft/WindowsApps -maxdepth 1 -type d | tr '\n' ':' | sed 's/:*$//')"
  export PATH="$PATH:$(find /mnt/c/Users/*/scoop/apps -maxdepth 3 -mindepth 2 -type d -regex '.*/[0-9]+\.[0-9]+\.[0-9]+$' | tr '\n' ':' | sed 's/:*$//')"
fi

# Default binaries
export TERMINAL="st"
export EDITOR="nvim"
export READER="zathura"
export BROWSER="firefox"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Personal Folders
export DOTFILES="$HOME/.local/src/dotfiles"
export ONEDRIVE="$HOME/Maja"
export MYDATA="$ONEDRIVE/_data"
export VIDEOS="$HOME/Videos"
export MUSIC="$HOME/Music"
export SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Security and secrets
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$ONEDRIVE/Private/PasswordStore"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR="$PASSWORD_STORE_DIR/.extensions"
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"

# Go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# R
export R_ENVIRON_USER="${XDG_CONFIG_HOME:-$HOME/.config}/R/Renviron"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# LaTeX
export TEXMFHOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ruby
[[ -x $(which ruby) ]] && \
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')" && \
  mkdir -p "$GEM_HOME" 2>/dev/null && \
  export PATH="$PATH:$(find "$GEM_HOME" -type d -name "bin" | tr '\n' ':' | sed 's/:*$//')"


export npm_config_prefix="${XDG_DATA_HOME:-$HOME/.local/share}/npm"
export PATH="$PATH:$npm_config_prefix/bin" # local package binaries

export BUN_INSTALL="$HOME/.local/share/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm

# Start X if not already running
[[ -z $(echo "${SSH_CLIENT}") && "$(tty)" = "/dev/tty1" && -z "$(pgrep -u "$USER" '\bXorg$')" ]] && exec startx
