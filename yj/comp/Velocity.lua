local Yami = require 'Yami'

---@class yj.comp.Velocity: yj.comp.Vector
---@field x number
---@field y number
local Velocity, ctor = Yami.def('yj.comp.Velocity', dofile 'yj/comp/Vector.lua')

function Velocity.new (x, y)
    return ctor {
        x = x or 0,
        y = y or 0,
    }
end

return Velocity