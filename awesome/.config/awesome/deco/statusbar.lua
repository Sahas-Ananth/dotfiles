-- Standard awesome library
local gears = require "gears"
local awful = require "awful"
local beautiful = require "beautiful"

-- Wibox handling library
local wibox = require "wibox"

-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require "deco.wallpaper",
  taglist = require "deco.taglist",
  tasklist = require "deco.tasklist",
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local custom_widgets = {
  bat_widget = require "widgets.batteryarc-widget.batteryarc" {
    show_current_level = true,
    size = 25,
    show_notification_mode = "on_click",
    warning_msg_position = "top_left",
  },
  logout_widget = require "widgets.logout-menu-widget.logout-menu" {
    onlock = function()
      awful.util.spawn("lockscreen", false)
    end,
  },
  vol_widget = require "widgets.volume-widget.volume" {
    widget_type = "icon_and_text",
    step = 1,
  },
  cal_widget = require "widgets.calendar-widget.calendar" {
    placement = "top_right",
    start_sunday = true,
    auto_hide = true,
  },
  vpn_widget = require "widgets.vpn-widget"(),
  mon_bright_widget = require "widgets.brightness-widget.brightness" {
    type = "icon_and_text",
    program = "ddcutil",
    step = 1,
    base = 50,
  },
  -- lap_bright_widget = require "widgets.brightness-widget.brightness" {
  --   type = "icon_and_text",
  --   program = "brightnessctl",
  --   step = 1,
  --   base = 50,
  -- },
  blue_bat_widget = require "widgets.bluetooth-batteryarc-widget.batteryarc" {
    show_current_level = true,
    size = 25,
    show_notification_mode = "on_click",
    warning_msg_position = "top_left",
  },
  -- music_widget = require "widgets.mpris-widget"(),
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%c", 1)
mytextclock:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    custom_widgets.cal_widget.toggle()
  end
end)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  ))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    style = {
      shape_border_width = 1,
      shape_border_color = "#777777",
      shape = gears.shape.rounded_bar,
    },
    layout = {
      spacing = 10,
      spacing_widget = {
        {
          forced_width = 5,
          shape = gears.shape.circle,
          widget = wibox.widget.separator,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      layout = wibox.layout.flex.horizontal,
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
      {
        {
          {
            {
              id = "icon_role",
              widget = wibox.widget.imagebox,
            },
            margins = 2,
            widget = wibox.container.margin,
          },
          {
            id = "text_role",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = 10,
        right = 10,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    },
  }

  -- Create the wibox
  s.mywibox = awful.wibar { position = "top", screen = s, height = 25 }

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      spacing = 10,
      RC.launcher,
      s.mytaglist,
      s.mypromptbox,
    },
    {
      layout = wibox.layout.align.horizontal,
      s.mytasklist, -- Middle widget
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      spacing = 15,
      custom_widgets.blue_bat_widget,
      custom_widgets.vpn_widget,
      wibox.widget.systray(),
      custom_widgets.mon_bright_widget,
      custom_widgets.vol_widget,
      custom_widgets.bat_widget,
      -- custom_widgets.lap_bright_widget,
      -- custom_widgets.music_widget,
      -- mykeyboardlayout,
      mytextclock,
      custom_widgets.logout_widget,
      s.mylayoutbox,
    },
  }
end)
-- }}}
