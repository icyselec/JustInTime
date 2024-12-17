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

    self:invokeHandler('onDraw', renderer)

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
        return self:invokeHandler('onEnter', x, y) or self
    end
end

---@param x number
---@param y number
function Button:onLeave (
    x,
    y
)
    if not self:isContact(x, y) then
        self:invokeHandler('onLeave', x, y)
    end
end

function Button:onClick ()
    if not (self.enabled or self.activated) then return end

    self:invokeHandler('onClick')
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
    if button == 1 and self:isContact(x, y) then
        return self
    end

    return nil
end

function Button:onMouseReleased (
    x,
    y,
    button
)
    if button == 1 and self:isContact(x, y) then
        self:invokeHandler('onClick', x, y, button)
    end
end



return Button