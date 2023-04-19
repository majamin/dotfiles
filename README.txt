=== dotfiles ===

This repo holds my dotfiles for a minimal X11 window manager setup.

Submodules
==========

* Neovim config
* Oneliners for handy references
* My DWM build
* My dmenu build

  --------------------------------------------------------
  git submodule update --init --recursive
  --------------------------------------------------------

Notes
=====

If you use this entire repo as is, here's the important files:

  ~/.xinitrc                                  (loads ENV, window manager)
  ~/.local/bin/loopwm                         (loops window manager and bar.sh)
  ~/.local/bin/statusbar/bar.sh               (the statusbar script)
  ~/.config/xprofile                          (startup programs)
  ~/.profile -> ~/.config/zsh/.zprofile       (ENV and startx)

To deploy as a bare repo
========================

                                             WARNING: DESTRUCTIVE COMMAND!
  ------------------------------------------------------------------------
  git clone --bare https://github.com/majamin/dotfiles $HOME/.dotfiles
  cd && git --git-dir=$HOME/.dotfiles --work-tree=$HOME reset --hard HEAD
  ------------------------------------------------------------------------

You can manage the dotfile repo with the command `dots`.
You can use `dots` just like you'd use `git`.

  ---------------------------------------------------------------------
  alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
  ---------------------------------------------------------------------

Tips
====

Key repeat rate is set by xset - change it in ~/.config/xprofile
GTK styles are located in ~/.config/gtk-*
Tmux sessionizer is good to go - learn it! (see ~/.config/tmux/tmux.conf)
Use `setbg` on a file to set the background (~/.local/bin/setbg)
Use `setbg` on a directory to set a random background
