---@class ui.Contactable
---@field isContact fun(self: self, x: number, y: number): boolean
---@field onEnter fun(self: self, x: number, y: number): boolean
---@field onStay fun(self: self, x: number, y: number): boolean
---@field onLeave fun(self: self, x: number, y: number): boolean
local Contactable = {}

---@param x number
---@param y number
function Contactable:isContact (
    x,
    y
)
    ---@cast self {position: yj.comp.Position}
    assert(self.position, 'Position is not implemented.')
    if x == self.position.x and y == self.position.y then
        return true
    end

    return false
end

---@param x number
---@param y number
---@return boolean
function Contactable:onEnter (
    x,
    y
)
    return self:isContact(x, y)
end

---@param x number
---@param y number
function Contactable:onLeave (
    x,
    y
)
    return not self:isContact(x, y)
end

return Contactable