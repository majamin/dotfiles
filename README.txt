=== dotfiles ===

Personal dotfiles, managed as a bare git repo plus a `dots` alias.
You are on the master branch (barebones -- the common base every machine shares).

Branches
========

  master ......... common base; everything every machine needs
  KDE ............ master + KDE / Plasma settings
  wayland ........ master + wayland WM settings

Common changes are authored on `master` and flow DOWN into the topic
branches via merge. Topic branches only add their own machine-specific
commits. Never merge a topic branch back into master.

I just want one setup
=====================

  git clone --bare git@github.com:majamin/dotfiles.git ~/.dotfiles
  alias dots='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME git'
  dots checkout KDE          # or: master / wayland-other
  dots submodule update --init --recursive
  dots config status.showUntrackedFiles no

If `checkout` complains about existing files, move them aside first.
The `dots` alias is also defined as a function in ~/.config/zsh/.zshrc.

Maintaining all branches
========================

A linked worktree lets you edit master without touching your live $HOME:

  git --git-dir=$HOME/.dotfiles worktree add ~/dotfiles-master master

  - Common change?  edit it in ~/dotfiles-master, commit there, then on
    each machine:  dots merge master
  - Machine-specific change?  just commit it on the current branch.

Git identity lives in ~/.gitconfig.local (untracked) so it survives branch
switches -- create it on a new machine with your name/email. README.txt is
per-branch and protected by a merge=ours driver, so `dots merge master`
never conflicts on it.

Key files
=========

  ~/.profile ................. Environment variables, $PATH, etc.
  ~/.zshenv .................. Shell environment
  ~/.config/zsh/.zshrc ....... Shell config
  ~/.gitconfig ............... Git aliases (lg1/lg2); identity is in ~/.gitconfig.local
  ~/.local/bin/ .............. Helper scripts
