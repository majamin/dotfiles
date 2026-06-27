=== dotfiles ===

Personal dotfiles, managed as a bare git repo plus a `dots` alias.
Everything lives on one branch (master); each machine just uses the
files relevant to it (KDE configs on a KDE box, hypr/waybar on a
wayland box, the rest everywhere). Unused configs sit harmlessly.

Setup on a new machine
======================

  git clone --bare git@github.com:majamin/dotfiles.git ~/.dotfiles
  alias dots='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME git'
  dots checkout
  dots submodule update --init --recursive
  dots config status.showUntrackedFiles no

If `checkout` complains about existing files, move them aside first.
The `dots` alias is also defined as a function in ~/.config/zsh/.zshrc.

Then create ~/.gitconfig.local (untracked) with your git identity:

  [user]
      name = Your Name
      email = you@example.com

And, if you use pass, create the store dir with the right perms:

  mkdir -p ~/.local/share/PasswordStore && chmod 700 ~/.local/share/PasswordStore

Day to day
==========

  Edit any file live in $HOME, then:
      dots add <file>
      dots commit -m "..."
      dots push

  dots status   # quiet -- untracked files are hidden
  dots lg1      # graph log

Key files
=========

  ~/.profile ................. Environment variables, $PATH, etc.
  ~/.zshenv .................. Shell environment
  ~/.config/zsh/.zshrc ....... Shell config
  ~/.gitconfig ............... Git aliases (lg1/lg2); identity is in ~/.gitconfig.local
  ~/.local/bin/ .............. Helper scripts
  ~/.config/hypr/ ............ Hyprland (wayland machines)
  ~/.config/kwinrc, kde* ..... KDE / Plasma (KDE machines)
