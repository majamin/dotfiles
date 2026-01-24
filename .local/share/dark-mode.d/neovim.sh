#!/bin/bash
for sock in /run/user/$UID/nvim.*.0; do
  nvim --server "$sock" --remote-send '<Cmd>colorscheme github_dark<CR>' 2>/dev/null
done
