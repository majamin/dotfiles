local startup_bins = {
  "dbus-update-activation-environment --systemd --all",
  "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DBUS_SESSION_BUS_ADDRESS",
  "/usr/lib/polkit-kde-authentication-agent-1",
  "waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css",
  "awww-daemon",
  "~/.config/hypr/scripts/wallpaper.sh",
  "~/.config/hypr/scripts/brightness.sh",
  "~/.config/hypr/scripts/swayidle-daemon.sh",
  "nm-applet",
  "mako",
  "wl-paste --watch cliphist store",
  "easyeffects --service-mode --hide-window",
}

hl.on("hyprland.start", function()
  for _,val in pairs(startup_bins) do
    hl.exec_cmd(val)
  end
end)
