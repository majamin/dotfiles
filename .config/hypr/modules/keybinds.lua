local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "dolphin"
local menu = "bash -c 'exec $(tofi-run)'"
local launcher = "tofi-drun --drun-launch=true"

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))

-- Move and focus windows
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind("ALT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next()) -- Change focus to another window
  hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
end)

-- Use the mouse to move and resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Focus workspaces and move windows to workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- TODO:
-- -- resize windows
-- binde = $mod SHIFT, h, resizeactive, -20  0
-- binde = $mod SHIFT, l, resizeactive, 20  0
-- binde = $mod SHIFT, k, resizeactive, 0 -20
-- binde = $mod SHIFT, j, resizeactive, 0  20

--[[ =========== PROGRAMS AND LAUNCHERS ========== ]]

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload config-only"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/displays.sh"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("rofi-file-picker"))

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("clipyt"))
hl.bind(
  mainMod .. " + N",
  hl.dsp.exec_cmd(terminal .. " -e /usr/bin/zsh -lic 'tmux attach -t notes || t " .. os.getenv("HOME") .. "/Maja/Projects/notes/notes.adoc'")
)

-- Screenshots
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh region"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh full"))
hl.bind(mainMod .. " + CTRL +  S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh window"))

-- Zoom
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("hyprloupe -a -n -d -s 3.2 -u 500 -D 0.5"))
hl.bind(mainMod .. " + mouse:274", hl.dsp.exec_cmd("hyprloupe -a -n -d -s 3.2 -u 500 -D 0.5"))

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })
