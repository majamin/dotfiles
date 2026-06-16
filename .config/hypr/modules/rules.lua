-- stylua: ignore start
hl.window_rule({ match = { class = "mpv" }, keep_aspect_ratio = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true ,move = { "monitor_w-window_w-11", "43" } })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, move = { "monitor_w-window_w-11", "43" } })
hl.window_rule({ match = { class = "wlogout" }, float = true })
hl.window_rule({ match = { float = false }, no_shadow = true })
hl.window_rule({ match = { title = ".*bitmap image import$" }, float = true })
hl.window_rule({ match = { title = "^Picture.in.Picture$" }, keep_aspect_ratio = true, float = true })
hl.window_rule({ match = { title = "^mpv-clipyt$" }, float = true })
hl.window_rule({ match = { title = 'Rename ".*"' }, float = true })
-- stylua: ignore end

-- smart gaps
-- stylua: ignore start
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
-- stylua: ignore end

-- Ignore maximize requests from all apps
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})
