=== dotfiles ===

This repo holds my dotfiles for a minimal X11 window manager setup.
As it exists, it is setup for DWM.
To change that you'll need to edit:

  ~/.local/bin/loopwm

Notes
=====

To deploy this repo as a bare repo (second step WILL overwrite files - BE CAREFUL!):

  --------------------------------------------------------------------------------------------
  git clone --bare --recurse-submodules https://github.com/majamin/dotfiles $HOME/.dotfiles
  cd && git --git-dir=$HOME/.dotfiles --work-tree=$HOME reset --hard HEAD
  --------------------------------------------------------------------------------------------

Then, you can manage the dotfile repo with `dots` (use it just like `git`).
`dots` is aliased in this way (in `~/.config/.zshrc`):

  --------------------------------------------------------
  alias dots='git --git-dir=~/.dotfiles --work-tree=$HOME'
  --------------------------------------------------------

The following will also make `dots` quieter:

  --------------------------------------------------------
  dots config --local status.showUntrackedFiles no
  --------------------------------------------------------

Tips
====

Get my dmenu, dwm, and neovim configs for a comfy experience!
Key repeat rate is set by xset - change it in ~/.config/xprofile
Key remaps are located in ~/.local/bin/remaps
GTK styles are located in ~/.config/gtk-*
Tmux sessionizer is good to go - learn it! (see ~/.config/tmux/tmux.conf)
Use `setbg` on a file to set the background (~/.local/bin/setbg)
Use `setbg` on a directory to set a random background
