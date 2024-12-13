local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Velocity = require 'yj.comp.Velocity'

---@class yj.Unit
---@field position yj.comp.Position
---@field velocity yj.comp.Velocity
local Unit , ctor= Yami.def 'yj.Unit'

---@param pos? yj.comp.Position
---@param vel? yj.comp.Velocity
function Unit.new (pos, vel)
    return ctor {
        position = pos or Position.new(),
        velocity = vel or Velocity.new(),
    }
end

return Unit