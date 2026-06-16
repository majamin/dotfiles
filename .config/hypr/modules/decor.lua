hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 3,
    col = {
      active_border = "rgba(e07820ff)",
      inactive_border = "rgba(b8b8b288)",
    },
    layout = "dwindle",
  },
  decoration = {
    rounding = 2,
    shadow = {
      enabled = true,
      range = 30,
      render_power = 2,
      color = 0x45000000,
    },

    blur = {
      enabled = true,
      size = 4,
      passes = 2,
      ignore_opacity = true,
    },
  },
  animations = { enabled = true },
  dwindle = { preserve_split = true },
  render = { cm_enabled = false },
  cursor = { enable_hyprcursor = false },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
  },
})

hl.curve("smooth", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "smooth", style = "popin 85%" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
