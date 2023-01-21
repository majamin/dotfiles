#!/usr/bin/env bash
read -p "Enter Query: " query
tmux neww -n "cht-sh-${query%% *}" bash -c "cht.sh $query | less"
