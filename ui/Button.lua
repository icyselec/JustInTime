local Yami = require 'Yami'

local BaseUI = require 'ui.BaseUI'

---@class ui.Button: ui.Component, ui.Drawable.Button
local Button = Yami.def 'ui.Component'
local base = Yami.base(Button)

---@param text? string
---@param enabled boolean
function Button.new (text, enabled)
    local textBatch

    if text then
        textBatch = love.graphics.newTextBatch(BaseUI.font)
        textBatch:add(text, 0, 0)
    end

    return base {
        textBatch = textBatch,
        enabled = enabled or true,
        hovered = false,
        clicked = false,
    }
end

function Button:draw ()
    if not self.activated then
        return self
    end

    love.graphics.push('all')

    BaseUI.drawButton(self)
    if self.textBatch then
        BaseUI.drawText(self, self.textBatch)
    end

    love.graphics.pop()

    return self
end

function Button:isContact (x, y)
    local self_x = self.position.x - (self.dimension.width / 2)
    local self_y = self.position.y - (self.dimension.height / 2)

    return x >= self_x and x <= self_x + self.dimension.width
        and y >= self_y and y <= self_y + self.dimension.height
end

function Button:onEnter(x, y)
    
end


return Button