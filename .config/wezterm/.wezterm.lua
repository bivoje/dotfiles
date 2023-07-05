-- wezterm config file
-- put this file in the home directory (windows/linux)

local WEBHOOK_URL = '' -- replace this with valid URL

-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Andromeda'

-- for some reason, they look awful, maybe due to aliasing options...???
-- i'll stick to the default for now
--config.font = wezterm.font 'Ubuntu Mono'
--config.font_size = 14.0

-- no windows title bar
--config.window_decorations = "TITLE | RESIZE"
config.window_decorations = "RESIZE"

-- start with powershell, not cmd
config.default_prog = { 'powershell.exe' }

-- flashing-yellow visual bell
config.visual_bell = {
  fade_in_duration_ms = 30,
  fade_out_duration_ms = 30,
  target = 'BackgroundColor',
}
config.colors = {
  visual_bell = '#fcf988',
}

config.mouse_bindings = {
  { event = { Down = { streak = 1, button = 'Right' } },
    mods = 'SHIFT',
    action = act.PasteFrom 'Clipboard',
  },
  { event = { Down = { streak = 1, button = 'Right' } },
    mods = 'CTRL',
    action = act.CopyTo 'Clipboard',
  },
}


-- an watch dog for a pavlov's bell, creates notification when audible bell rings
-- https://wezfurlong.org/wezterm/config/lua/window-events/bell.html
wezterm.on('bell', function(window, pane)

  if not pane:has_unseen_output() then
    return
  end

  -- https://stackoverflow.com/a/6192354
  -- using lua 'pattern'
  local succ, command = "NIL", "NIL"
  gm = string.gmatch(pane:get_logical_lines_as_text(), "\nNOTIF: ([^ ]+) ([^\n]+)")
  for s,c in gm do succ, command = s, c end
  
  local message = succ .. " - " .. command

  -- this is useless since it gets the WD of hosting shell (powershell)
  -- and almost always results in the windows home dir
  --message = message .. " at " .. (pane:get_current_working_dir() or "NIL")

  wezterm.log_info('bell rung at ' .. pane:pane_id() .. '! ' .. message)

  ---[[
  -- https://stackoverflow.com/a/70690633
  -- os.execute uses cmd.exe in windows, which treats quoted string in abnormal way.
  -- found by try & error using 'python.exe -c "import sys; print(sys.argv)" "a ""b"" c"
  
  -- https://superuser.com/a/1252488
  -- appending >NUL 2>&1 to silence the output
  
  -- https://stackoverflow.com/a/62301184
  -- discord webhook example from the stackoverflow

  -- https://www.lua.org/manual/5.1/manual.html#pdf-os.execute
  os.execute('curl'
    .. ' -i -X POST'
    .. ' -H "Accept: application/json" -H "Content-Type:application/json"'
    .. ' --data "{""content"": ""' .. message .. '""}"'
    .. ' "' .. WEBHOOK_URL .. '"'
    .. ' >NUL 2>&1'
  )
  -- FIXME what if WEBHOOK_URL is wrong or server errors?
  --]]
end)

-- and finally, return the configuration to wezterm
return config
