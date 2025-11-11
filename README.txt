=== dotfiles ===

This repo holds my dotfiles for a minimal X11 window manager setup.

Installation
============

This repo uses a bare git repository for dotfiles management.

  **WARNING: This will overwrite existing dotfiles!**

  1. Clone the bare repository:

     git clone --bare https://github.com/majamin/dotfiles $HOME/.dotfiles

  2. Create a symlink for Fugitive/git integration:

     ln -s .dotfiles $HOME/.git

  3. Checkout the files (this will overwrite existing configs):

     git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

  4. Initialize submodules:

     git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --init --recursive

Usage
=====

The `dots` alias works like git but for your dotfiles (from any directory):

  dots status              # See what's changed
  dots add .zshrc          # Stage a file
  dots commit -m "update"  # Commit changes
  dots push                # Push to remote

The alias is defined in ~/.config/zsh/.zshrc:

  alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

Since ~/.git is symlinked to .dotfiles, you can also use regular git commands
from your home directory, and vim-fugitive will work in Neovim.

Submodules
==========

This repo includes submodules for:

  * Neovim config (https://github.com/majamin/neovim-config.git)
  * dwm (https://github.com/majamin/dwm.git)
  * dmenu (https://github.com/majamin/dmenu.git)
  * st (https://github.com/majamin/st.git)
  * oneliners (https://github.com/majamin/oneliners.txt.git)

Important Files
===============

  ~/.xinitrc                           (loads ENV, window manager)
  ~/.config/zsh/.zshrc                 (zsh configuration)
  ~/.config/zsh/.zprofile              (environment variables, PATH)
  ~/.config/zsh/t.zsh                  (tmux sessionizer)
  ~/.local/bin/loopwm                  (window manager loop)
  ~/.local/bin/statusbar/bar.sh        (statusbar script)
  ~/.config/xprofile                   (startup programs)

Extra Notes
===========

  * Key repeat rate is set by xset - change it in ~/.config/xprofile
  * GTK styles are located in ~/.config/gtk-*
  * Tmux sessionizer is a handy tool, see ~/.config/zsh/t.zsh
  * Use `setbg` on a file to set the background (~/.local/bin/setbg)
  * Use `setbg` on a directory to set a random background
