=== dotfiles ===

This repo holds my dotfiles for a minimal X11 window manager setup.

Quickstart
==========

  -------------------------------------------------------------
  git clone --recursive https://github.com/majamin/dotfiles.git
  -------------------------------------------------------------

Submodules
==========

Submodules are provided for:

  * Neovim (https://github.com/majamin/neovim-config.git)
  * DWM (https://github.com/majamin/dwm.git)
  * Dmenu (https://github.com/majamin/dmenu.git)
  * Oneliners (https://github.com/majamin/oneliners.txt.git)

If you cloned this repo without the `--recursive` flag, run

  --------------------------------------------------------
  git submodule update --init --recursive
  --------------------------------------------------------

to fetch the submodules.

Important Files
===============

If you use this entire repo as is, here's the important files:

  ~/.xinitrc                                  (loads ENV, window manager)
  ~/.local/bin/loopwm                         (loops window manager and bar.sh)
  ~/.local/bin/statusbar/bar.sh               (the statusbar script)
  ~/.config/xprofile                          (startup programs)
  ~/.profile -> ~/.config/zsh/.zprofile       (ENV and startx)

Stow
====

You can use GNU Stow to manage the dotfiles in this repo.
For example, to deploy all the dotfiles in this repo
from the home directory, run the following commands:

  --------------------------------------------------------
  cd ~/
  git clone --recursive https://github.com/majamin/dotfiles.git .dotfiles
  cd .dotfiles
  stow -t $HOME -v -R .
  --------------------------------------------------------

It's best for the target directory to be free of any clashing files.
`stow` will fail in those particular scenarios (this is normal).
Please see `stow` documentation for more information. In particular,
the `--adopt` flag may be useful.

To deploy as a bare repo
========================

                                        *****WARNING: DESTRUCTIVE COMMAND!
  ------------------------------------------------------------------------
  git clone --bare https://github.com/majamin/dotfiles $HOME/.dotfiles
  cd && git --git-dir=$HOME/.dotfiles --work-tree=$HOME reset --hard HEAD
  ------------------------------------------------------------------------

To avoid having to type the `--git-dir` and `--work-tree` flags every time,
you can use the following alias `dots` just like you'd use `git`.

  ---------------------------------------------------------------------
  alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
  ---------------------------------------------------------------------

Extra Notes
===========

  * Key repeat rate is set by xset - change it in ~/.config/xprofile
  * GTK styles are located in ~/.config/gtk-*
  * Tmux sessionizer is good to go - learn it! (see ~/.config/tmux/tmux.conf)
  * Use `setbg` on a file to set the background (~/.local/bin/setbg)
  * Use `setbg` on a directory to set a random background
