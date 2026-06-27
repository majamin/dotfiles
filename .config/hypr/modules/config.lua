local env = {
  ELECTRON_OZONE_PLATFORM_HINT = "wayland",
  GDK_BACKEND = "wayland,x11",
  HYPRCURSOR_SIZE = "24",
  HYPRCURSOR_THEME = "Adwaita",
  MOZ_ENABLE_WAYLAND = "1",
  QT_QPA_PLATFORM = "wayland;xcb",
  QT_QPA_PLATFORMTHEME = "kde",
  XCURSOR_SIZE = "24",
  XCURSOR_THEME = "Adwaita",
  XDG_CURRENT_DESKTOP = "Hyprland",
  XDG_MENU_PREFIX=  "plasma-",
  XDG_SESSION_TYPE = "wayland",
}

for key, val in pairs(env) do
  hl.env(key, val)
end

hl.config({
  input = {
    kb_layout = "us",
    kb_options = "caps:swapescape",
    repeat_delay = 200,
    repeat_rate = 40,
    follow_mouse = true,
    sensitivity = "0",
    touchpad = {
      natural_scroll = false,
      drag_lock = true,
      disable_while_typing = true,
    },
  },
  misc = {
    enable_swallow = true,
    swallow_regex = "^(Ghostty|Alacritty|kitty|footclient)$",
    initial_workspace_tracking = 0,
  },
  gestures = {
    workspace_swipe_touch = true,
    workspace_swipe_distance = 250,
  },
})
