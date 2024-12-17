local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Velocity = require 'yj.comp.Velocity'

---@class yj.Unit
---@field position yj.comp.Position
---@field velocity yj.comp.Velocity
---@class yj.Unit.Impl: yj.Unit
local Unit  = Yami.def()
local base = Yami.base(Unit)

---@param pos? yj.comp.Position
---@param vel? yj.comp.Velocity
function Unit.new (pos, vel)
    return base {
        position = pos or Position.new(),
        velocity = vel or Velocity.new(),
    }
end

function Unit:move (dx, dy)
    self.position:move(dx, dy)
    return self
end

return Unit