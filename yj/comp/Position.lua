local Yami = require 'Yami'

---@class yj.comp.Position
---@field x number
---@field y number
local Position = Yami.def 'yj.comp.Vector'
local base = Yami.base(Position)

---@param x? number
---@param y? number
function Position.new (x, y)
    return base {
        x = x or 0,
        y = y or 0,
    }
end

function Position:move (dx, dy)
    self.x = math.floor(self.x + dx)
    self.y = math.floor(self.y + dy)
    return self
end

---@param x number
---@param y number
function Position:toLocal (x, y)
    return x - self.x, y - self.y
end

return Position