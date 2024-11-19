[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/xprofile" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/xprofile"
test $(which gpg-agent) && eval $(gpg-agent --daemon)
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
eval $(ssh-agent)
exec dbus-launch --exit-with-session ~/.local/bin/loopwm
