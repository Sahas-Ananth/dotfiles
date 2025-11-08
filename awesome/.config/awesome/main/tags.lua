-- Standard awesome library
local awful = require "awful"

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local tags = {}

  local tagpairs = {
    names = { "Work 1", "Work 2", "Slack", "Zoom", "Mail", "6", "7", "Obsidian", "Music" },
    layout = {
      RC.layouts[1],
      RC.layouts[1],
      RC.layouts[3],
      RC.layouts[3],
      RC.layouts[1],
      RC.layouts[1],
      RC.layouts[1],
      RC.layouts[1],
      RC.layouts[1],
    },
  }

  awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tagpairs.names, s, tagpairs.layout)
  end)

  return tags
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
  __call = function(_, ...)
    return _M.get(...)
  end,
})
