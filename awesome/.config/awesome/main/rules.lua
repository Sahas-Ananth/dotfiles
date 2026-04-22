-- Standard awesome library
local awful = require "awful"
-- Theme handling library
local beautiful = require "beautiful"

local _M = {}

-- reading
-- https://awesomewm.org/apidoc/libraries/awful.rules.html

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get(clientkeys, clientbuttons)
  local rules = {

    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        floating = false,
        titlebars_enabled = false,
      },
    },

    -- Floating clients.
    {
      rule_any = {
        instance = {
          "DTA", -- Firefox addon DownThemAll.
          "copyq", -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin", -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "Pavucontrol",
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester", -- xev.
        },
        role = {
          "AlarmWindow", -- Thunderbird's calendar.
          "ConfigManager", -- Thunderbird's about:config.
          "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        },
      },
      properties = {
        floating = true,
        titlebars_enabled = true,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered,
      },
    },

    -- Open Slack in workspace 3
    {
      rule = { class = "Slack" },
      properties = { tag = awful.tag.find_by_name(awful.screen.focused(), "Slack").name },
    },

    -- Zoom Rules:
    -- If you are zoom, be maximized, centered, and on the "Zoom" tag.
    {
      rule = { class = "^zoom$" },
      properties = {
        floating = false,
        maximized = true,
        -- maximized_vertical = true,
        -- maximized_horizontal = true,
        urgent = true,
        -- placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered,
        tag = awful.tag.find_by_name(awful.screen.focused(), "Zoom").name,
      },
    },

    -- Open Mail in workspace 5 - Outlook PWA has this WM_CLASS(STRING) = "crx_faolnafnngnfdaknnbpnkhgohbobgegn", "Brave-browser"
    {
      rule = { instance = "crx_faolnafnngnfdaknnbpnkhgohbobgegn" },
      properties = {
        tag = awful.tag.find_by_name(awful.screen.focused(), "Mail").name,
        titlebars_enabled = false,
        floating = false,
      },
    },

    -- Tile Brave-browser
    { rule = { class = "brave-browser" }, properties = { floating = false, maximized = false } },
  }

  return rules
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
  __call = function(_, ...)
    return _M.get(...)
  end,
})
