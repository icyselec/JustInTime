local Yami = require 'Yami'

local Color = require 'yj.comp.Color'

local Renderer = require 'ui.Renderer'

---@class ui.Theme: ui.Renderer
---@field font? love.Font
---@field color? yj.comp.Color
---@field fontColor? yj.comp.Color
---@field panelColor? yj.comp.Color
---@field borderColor? yj.comp.Color
---@field buttonColor? yj.comp.Color
---@field panelImage? love.Texture
---@field roundness number
local Theme = Yami.def 'ui.Renderer'
local base = Yami.base(Theme)

function Theme.new (
    font,
    color
)
    return base {
        font = font or love.graphics.getFont(),
        color = color,
        roundness = 2/32,
    }
end

function Theme:setPanelImage (image)
    self.panelImage = image
    return self
end

function Theme:drawBackPanel (
    this,
    color
)
    color = color or self.panelColor

    local x, y = this.position.x, this.position.y
    local w, h = this.dimension.width, this.dimension.height

    if self.panelImage then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.panelImage, x - w/2, y - h/2, 0, w/self.panelImage:getWidth(), h/self.panelImage:getHeight())
    else
        -- invoke default
        Renderer.drawBackPanel(self, this, color)
    end
end

function Theme:drawBorder (
    this,
    color
)
    if self.panelImage then return end

    -- draw border
    Renderer.drawBorder(self, this, color)
end


return Theme