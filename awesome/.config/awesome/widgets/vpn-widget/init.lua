local awful = require "awful"
local wibox = require "wibox"
local watch = require "awful.widget.watch"
local beautiful = require "beautiful"
local naughty = require "naughty"

local vpn_widget = {}

local function worker(user_args)
  local status = false

  local args = user_args or {}
  args.off_bg_color = args.off_bg_color or "#CD1C18"
  args.on_bg_color = args.on_bg_color or "#008000"
  args.widget_width = args.widget_width or 80
  args.widget_height = args.widget_height or 25

  local vpn_widget_nb = wibox.widget {
    font = beautiful.font,
    align = "center",
    valign = "center",
    forced_height = args.widget_height,
    forced_width = args.widget_width,
    widget = wibox.widget.textbox,
    text = "",
    visibile = true,
  }
  vpn_widget = wibox.container.background(vpn_widget_nb)

  local function update_widget(widget, stdout)
    local status_str = ""
    -- Get the status of the vpn
    for s in stdout:gmatch "[^\r\n]+" do
      local cur_status = string.match(s, ":%s*(%w*)")
      if cur_status ~= nil then
        if cur_status == "Disconnected" then
          -- GlobalProtect status: disabled
          status_str = "Off"
          status = false
          widget.bg = args.off_bg_color
        elseif cur_status == "Connected" then
          -- GlobalProtect status: Connected
          status_str = "On"
          widget.bg = args.on_bg_color
          status = true
        end
      end
    end
    vpn_widget_nb.markup = "<b>VPN: " .. status_str .. "</b>"
  end

  local function toggle_vpn(on)
    if on then
      awful.spawn.easy_async(
        -- [[bash -c "globalprotect connect -p vpn.torc.tech && globalprotect connect -g BCB"]],
        [[bash -c "globalprotect connect -p vpn.torc.tech"]],
        function(_, _, _, _)
          naughty.notify { title = "VPN: ON" }
        end
      )
    else
      awful.spawn.easy_async([[bash -c "globalprotect disconnect"]], function(_, _, _, _)
        naughty.notify { title = "VPN: OFF" }
      end)
    end
  end

  watch("globalprotect show --status", 10, update_widget, vpn_widget)

  vpn_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      status = not status
      toggle_vpn(status)
    end
  end)
  return vpn_widget
end

return setmetatable(vpn_widget, {
  __call = function(_, ...)
    return worker(...)
  end,
})
