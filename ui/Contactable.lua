
---@alias ui.Contactable.OnEnter fun(self: self, x: number, y: number): boolean
---@alias ui.Contactable.OnStay fun(self: self, x: number, y: number): boolean
---@alias ui.Contactable.OnLeave fun(self: self, x: number, y: number): boolean
---@alias ui.Contactable.OnGrab fun(self: self, x: number, y: number): boolean

---@class ui.Contactable.Event
---@field onEnter ui.Contactable.OnEnter
---@field onStay ui.Contactable.OnStay
---@field onLeave ui.Contactable.OnLeave
---@field onGrab ui.Contactable.OnGrab

---@class ui.Contactable.Callback
---@field Enter? ui.Contactable.OnEnter
---@field Stay? ui.Contactable.OnStay
---@field Leave? ui.Contactable.OnLeave
---@field Grab? ui.Contactable.OnGrab

---@class ui.Contactable: ui.Contactable.Event
---@field isContact fun(self: self, x: number, y: number): boolean
---@field callback ui.Contactable.Callback
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