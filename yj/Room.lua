local Yami = require 'Yami'

---@class yj.Room
---@field width number
---@field height number
local Room, ctor = Yami.def 'yj.Room'

function Room:new (width, height)
    return ctor {
        width = width or 1,
        height = height or 1,
    }
end

return Room