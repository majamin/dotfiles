=== dotfiles ===

This repo holds my dotfiles for a minimal X11 window manager setup.

As it exists, it is setup for DWM. To change that you'll need to edit:
  ~/.local/bin/loopwm

Notes
-----

To deploy this repo as a bare repo (step 2 will overwrite files - BE CAREFUL):

  --------------------------------------------------------------------------------------------
  1. git clone --bare --recurse-submodules https://github.com/majamin/dotfiles $HOME/.dotfiles
  2. cd && git --git-dir=$HOME/.dotfiles --work-tree=$HOME reset --hard HEAD
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
