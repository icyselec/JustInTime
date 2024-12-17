local Yami = require 'Yami'

---@class yj.comp.Color
---@field [1] number # red
---@field [2] number # green
---@field [3] number # blue
---@field [4] number # alpha
local Color = Yami.def()
local base = Yami.base(Color)

--- default color is white
---@param red number
---@param green number
---@param blue number
---@param alpha number
function Color.new (red, green, blue, alpha)
    return base {
        red or 1,
        green or 1,
        blue or 1,
        alpha or 1,
    }
end

function Color:unpack ()
    return table.unpack(self)
end

function Color:pack (red, green, blue, alpha)
    self[1] = red
    self[2] = green
    self[3] = blue
    self[4] = alpha
    return self
end

function Color:packLegacy (red, green, blue, alpha)
    self[1] = red/255
    self[2] = green/255
    self[3] = blue/255
    self[4] = alpha/255
    return self
end

return Color