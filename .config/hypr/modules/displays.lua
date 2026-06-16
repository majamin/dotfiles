-------------------------------------------------- DISPLAYS --------
local main_display_desc = "AU Optronics 0x9EA9"
local main_display_output = "desc:" .. main_display_desc

local function main_screen_defaults()
  hl.monitor({
    output = main_display_output,
    mode = "1920x1200@60.03",
    position = "0x0",
    scale = 1.0,
    disabled = false,
  })
end

-- safe fallback
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- set first
main_screen_defaults()

-- Lenovo monitor above main screen
hl.monitor({
  output = "desc:Lenovo Group Limited LEN C32qc-20 0x33524146",
  mode = "2560x1440@59.951Hz",
  position = "auto-up",
  scale = 1.0,
})

-- TODO: main screen does not turn back on when unlpugging HDMI in clamshell mode
hl.on("monitor.removed", function()
  main_screen_defaults()
end)

-------------------------------------------------- WORKSPACES --------

hl.workspace_rule({ workspace = "1", monitor = main_display_desc, default = true })

-------------------------------------------------- HOOKS

local lid_closed = require("modules.helpers").lid_closed
if lid_closed() then
  hl.monitor({ output = "eDP-1", disabled = true })
else
  main_screen_defaults()
end

-- handle lid toggles to closed
hl.bind("switch:on:Lid Switch", function()
  hl.monitor({ output = "eDP-1", disabled = true })
end, { locked = true })

-- handle lid toggles to open
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl reload config-only"), {
  locked = true,
})
