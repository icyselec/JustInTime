local Yami = require 'Yami'

---@class yj.comp.Position: yj.comp.Vector
---@field x number
---@field y number
local Position, ctor = Yami.def('yj.comp.Position', dofile 'yj/comp/Vector.lua')

function Position.new (x, y)
    return ctor {
        x = x or 0,
        y = y or 0,
    }
end

return Position