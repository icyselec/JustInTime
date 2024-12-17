local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

---@class ui.Button: ui.Component, ui.Drawable.Button, ui.Contactable
local Button = Yami.def 'ui.Component'
local base = Yami.base(Button)


---@param text? string
---@param position? yj.comp.Position
function Button.new (
    text,
    position,
    dimension
)
    local textBatch

    if text then
        textBatch = love.graphics.newTextBatch(love.graphics.getFont(), text)
    end

    return base {
        textBatch = textBatch,
        enabled = true,
        hovered = false,
        clicked = false,
        position = position or Position.new(0, 0),
        dimension = dimension or Dimension.new(25, 25),
        activated = true,
    }
end

---@param dt number
function Button:onUpdate(
    dt
)
    self:invokeCallback('Update', dt)
end

---@param renderer ui.Renderer
function Button:onDraw (
    renderer
)
    if not self.activated then return self end

    love.graphics.push('all')

    renderer:drawButton(self)
    if self.textBatch then
        renderer:drawTextBatch(self, self.textBatch)
    end

    self:invokeCallback('Draw', renderer)

    love.graphics.pop()
end

function Button:isContact (x, y)
    local self_x = self.position.x - (self.dimension.width / 2)
    local self_y = self.position.y - (self.dimension.height / 2)

    return x >= self_x and x <= self_x + self.dimension.width
        and y >= self_y and y <= self_y + self.dimension.height
end

---@param x number
---@param y number
function Button:onEnter(
    x,
    y
)
    if self:isContact(x, y) then
        return self:invokeCallback('Enter', x, y) or self
    end
end

---@param x number
---@param y number
function Button:onLeave (
    x,
    y
)
    if not self:isContact(x, y) then
        self:invokeCallback('Leave', x, y)
    end
end

function Button:onClick ()
    if not (self.enabled or self.activated) then return end

    self:invokeCallback('Click')
end

---comment
---@param x number
---@param y number
---@param button number
---@return ui.Component?
function Button:onMousePressed (
    x,
    y,
    button
)
    if self:isContact(x, y) then
        return self
    end

    return nil
end

function Button:onMouseReleased (
    x,
    y,
    button
)
    if self:isContact(x, y) then
        self:invokeCallback('Click', x, y, button)
    end
end


return Button