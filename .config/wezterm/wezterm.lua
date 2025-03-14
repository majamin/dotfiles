local wezterm = require("wezterm")

-- check for set-light-theme in zsh directory
local light = false
local f = io.open(os.getenv("HOME") .. "/.config/zsh/set-light-theme", "r")
if f ~= nil then
  io.close(f)
  light = true
end

local config = {
  audible_bell = "Disabled",
  color_scheme = (light and "AtomOneLight") or "Tokyo Night Storm",
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
