local wezterm = require("wezterm")
local config = {
  -- color_scheme = "PencilLight",
  color_scheme = "Tokyo Night Storm",
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
  cursor_blink_rate = 680,
  enable_tab_bar = false,
  -- window_background_opacity = 0.91,
  window_close_confirmation = "NeverPrompt",
  font = wezterm.font(
    "FiraCode Nerd Font",
    { weight = "Medium", italic = false }
  ),
  font_size = 14.0,
  bold_brightens_ansi_colors = false,
  freetype_load_target = "Light",
  harfbuzz_features = {
    "onum",
    "ss01",
    "ss02",
    "ss03",
    "ss04",
    "ss05",
    "ss09",
    "zero",
    "cv02",
    "cv27",
    "cv29",
  },
}

return config
