=== A bare repo of dotfiles ===

This repo holds my dotfiles files for GNU/Linux systems.

WARNING: The following commands will overwrite any files that match the locations in this repo.

To deploy the files, run:

  1. git clone --bare --recurse-submodules https://github.com/majamin/dotfiles $HOME/.dotfiles
  2. cd && git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout -f

It's helpful to have an alias in your shell's RC file. Example:

  alias dots='git --git-dir=~/.dotfiles --work-tree=$HOME'

Then, you can use `dots` like `git`. The following will also make `dots` quieter:

  dots config --local status.showUntrackedFiles no
