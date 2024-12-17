local Yami = require 'Yami'

---@class yj.comp.Dimension
---@field width number
---@field height number
local Dimension = Yami.def()
local base = Yami.base(Dimension)

function Dimension.new (width, height)
    assert(type(width) == 'number', 'width must be a number')
    assert(type(height) == 'number', 'height must be a number')

    return base {
        width = width,
        height = height,
    }
end

---@param width number
---@param height number
function Dimension:resize (width, height)
    self.width = width
    self.height = height
    return self
end

--- This function get the width of itself, or something.
---@return number width
function Dimension:getWidth ()
    return self.width
end

--- This function get the height of itself, or something.
---@return number height
function Dimension:getHeight ()
    return self.height
end

--- This function get the dimensions of itself, or something.
---@return number width
---@return number height
function Dimension:getDimensions ()
    return self.width, self.height
end


return Dimension