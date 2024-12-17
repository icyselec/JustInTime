local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'
local BaseUI = require 'ui.BaseUI'

---@class ui.Panel: ui.Component, ui.Container, ui.Drawable, ui.Contactable
local Panel = Yami.def('ui.Component', 'ui.Container')
local base = Yami.base(Panel)

---comment
---@param pos yj.comp.Position
---@param dim yj.comp.Dimension
function Panel.new (
    pos,
    dim
)
    return base {
        position = pos or Position.new(0, 0),
        dimension = dim or Dimension.new(25, 25),
        visible = true,
    }
end

local function draw_children (self)
    if self.onDraw then
        self:onDraw()
        return
    end
end

---@param parent { position: yj.comp.Position }
function Panel:onDraw (
    parent
)
    if not self.visible then return self end

    BaseUI.drawPanel(self)
    self:invokeHandler('onDraw', parent)

    local retval

    love.graphics.push('all')
    love.graphics.translate(self.position.x, self.position.y)
    retval = self:foreach(false, draw_children)
    love.graphics.pop()
    return retval
end

---@param x number
---@param y number
---@return boolean
function Panel:isContact (
    x,
    y
)
    local self_x = self.position.x - (self.dimension.width / 2)
    local self_y = self.position.y - (self.dimension.height / 2)

    return x >= self_x and x <= self_x + self.dimension.width
        and y >= self_y and y <= self_y + self.dimension.height
end

local function propagateEnterEvent (self, x, y)
    return self.onEnter and self:onEnter(x, y)
end

---@param x number
---@param y number
---@return ui.Component?
function Panel:onEnter (
    x,
    y
)
    if self:isContact(x, y) then
        return self:invokeHandler('onEnter', x, y) or self
    end

    return self:foreach(true, propagateEnterEvent, self.position:toLocal(x, y))
end

---comment
---@param x number
---@param y number
function Panel:onStay (
    x,
    y
)
    return self:invokeHandler('onStay', x, y) or self
end

---@param x number
---@param y number
function Panel:onLeave (
    x,
    y
)
    if not self:isContact(x, y) then
        return self:invokeHandler('onLeave', x, y) or self
    end

    return nil
end

return Panel