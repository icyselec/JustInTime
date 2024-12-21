
---@alias ui.Contactable.MouseOver fun(self: ui.Component, focus: boolean): ui.Component?
---@alias ui.Contactable.MouseMove fun(self: ui.Component, x: number, y: number): ui.Component?
---@alias ui.Contactable.MouseDrag fun(self: ui.Component, dx: number, dy: number): ui.Component?
---@alias ui.Contactable.MouseScroll fun(self: ui.Component, value: number, horizontal: boolean): ui.Component?

---@alias ui.Contactable.KeyboardPress fun(self: ui.Component, key: love.KeyConstant): ui.Component?
---@alias ui.Contactable.KeyboardRelease fun(self: ui.Component, key: love.KeyConstant): ui.Component?

---@deprecated
---@alias ui.Contactable.OnEnter fun(self: ui.Contactable, x: number, y: number): boolean
---@deprecated
---@alias ui.Contactable.OnStay fun(self: ui.Contactable, x: number, y: number): boolean
---@deprecated
---@alias ui.Contactable.OnLeave fun(self: ui.Contactable, x: number, y: number): boolean


---@alias ui.Contactable.OnGrab fun(self: ui.Contactable, dx: number, dy: number): boolean
---@alias ui.Contactable.OnScroll fun(self: ui.Contactable, dx: number, dy: number): boolean
---@alias ui.Contactable.OnDrag fun(self: ui.Contactable, dx: number, dy: number): boolean

---@class ui.Contactable.Callback
---@field onMouseOver? ui.Contactable.MouseOver
---@field onMouseMove? ui.Contactable.MouseMove
---@field onEnter? ui.Contactable.OnEnter
---@field onStay? ui.Contactable.OnStay
---@field onLeave? ui.Contactable.OnLeave
---@field onGrab? ui.Contactable.OnGrab
---@field onScroll? ui.Contactable.OnScroll
---@field onDrag? ui.Contactable.OnDrag

---@class ui.Contactable: ui.Contactable.Callback
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