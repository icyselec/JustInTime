local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'
local BaseUI = require 'ui.Renderer'

---@class ui.Panel: ui.Component, ui.Container, ui.Drawable, ui.Contactable, ui.Iterable
local Panel = Yami.def('ui.Component', 'ui.Container', 'ui.Iterable')
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
        activated = true,
    }
end

---@param self ui.Drawable
---@param renderer ui.Renderer
local function draw_children (self, renderer)
    if self.onDraw then
        self:onDraw(renderer)
        return
    end
end

---@param renderer ui.Renderer
function Panel:onDraw (
    renderer
)
    if not self.activated then return self end

    renderer:drawPanel(self)
    self:invokeHandler('onDraw', renderer)

    local retval

    love.graphics.push('all')
    love.graphics.translate(self.position.x, self.position.y)
    retval = self:foreach(draw_children, renderer)
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

    return self:find(propagateEnterEvent, self.position:toLocal(x, y))
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

local function propagateMousePressedEvent (self, x, y, button)
    return self.onMousePressed and self:onMousePressed(x, y, button)
end

---comment
---@param x number
---@param y number
---@param button number
---@return ui.Component?
function Panel:onMousePressed (
    x,
    y,
    button
)
    local contact

    if self:isContact(x, y) then
        contact = self:invokeHandler('onMousePressed', x, y, button) or self
    end

    -- if self is kind of Container, it is required to compute a local position.
    x, y = self.position:toLocal(x, y)

    return self:find(function (comp)
        return propagateMousePressedEvent(comp, x, y, button)
    end) or contact
end

return Panel