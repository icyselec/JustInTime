local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

local Renderer = require 'ui.Renderer'

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
        active = true,
        visible = true,
    }
end

---@type ui.Common.OnDraw
function Button:onDraw ()
    love.graphics.push('all')

    Renderer:drawButton(self)
    if self.textBatch then
        Renderer:drawTextBatch(self, self.textBatch)
    end

    love.graphics.pop()
end

function Button:isContact (x, y)
    local self_x = self.position.x - (self.dimension.width / 2)
    local self_y = self.position.y - (self.dimension.height / 2)

    return x >= self_x and x <= self_x + self.dimension.width
        and y >= self_y and y <= self_y + self.dimension.height
end

return Button