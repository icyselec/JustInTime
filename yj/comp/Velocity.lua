local Yami = require 'Yami'

---@class yj.comp.IVelocity
---@field vx number
---@field vy number

---@deprecated
---@class yj.comp.Velocity: yj.comp.IVelocity, yj.comp.Vector
local Velocity = Yami.def 'yj.comp.Vector'
local base = Yami.base(Velocity)

function Velocity.new (vx, vy)
    return base {
        vx = vx or 0,
        vy = vy or 0,
    }
end

return Velocity