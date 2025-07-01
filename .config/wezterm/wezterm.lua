local wezterm = require("wezterm")

local default_color_scheme = "Tokyo Night Storm"
-- local nvim_light_color_scheme = "AtomOneLight"

local config = {
  audible_bell = "Disabled",
  color_scheme = default_color_scheme,
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
  cursor_blink_rate = 680,
  enable_tab_bar = false,
  window_close_confirmation = "NeverPrompt",
  initial_rows = 36,
  initial_cols = 120,
  -- window_background_opacity = 0.96,
  font = wezterm.font_with_fallback({
    {
      family = "FiraCode Nerd Font", -- main font
      weight = "Medium",
      italic = false,
    },
    "Noto Color Emoji", -- fallback font
  }),
  font_size = 12.0,
  bold_brightens_ansi_colors = false,
  freetype_load_target = "Light",
  harfbuzz_features = {
    "onum", -- 4679
    "ss01", -- r
    "ss02", -- >=, <=
    "ss03", -- &
    "ss04", -- $
    "ss05", -- @
    "ss09", -- >>=, <<=, ||=, |=
    "zero", -- 0, also cv11, cv12, cv13
    "cv02", -- g
    --"cv27", -- []
    "cv29", -- {}
  },
}

return config
