local wezterm = require("wezterm")

local light = false
local f = io.open("$HOME/.config/zsh/set-light-theme", "r")
if f ~= nil then
  io.close(f)
  light = true
end

local config = {
  audible_bell = "Disabled",
  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
  },
  colors = {
    visual_bell = "#202020",
  },
  color_scheme = light and "PencilLight" or "Tokyo Night Storm",
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
