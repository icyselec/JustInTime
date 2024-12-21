local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

---@alias ui.Drawable.OnDraw fun(self: ui.Component, renderer: ui.Renderer): ui.Component?
---@alias ui.Drawable.OnOverlay fun(self: ui.Component, renderer: ui.Renderer): ui.Component?

---@class ui.Drawable.Callback
---@field onDraw? ui.Drawable.OnDraw
---@field onOverlay? ui.Drawable.OnOverlay

---@class ui.Drawable.Text: ui.Drawable
---@field textBatch love.TextBatch

---@class ui.Drawable.Button: ui.Drawable.Text
---@field hovered boolean
---@field clicked boolean
---@field enabled boolean

---@class ui.Drawable: ui.Component, ui.Drawable.Callback
---@field dimension yj.comp.Dimension
---@field hidden boolean
---@field visible boolean
local Drawable = Yami.def('ui.Component')
local base = Yami.base(Drawable)

---@param pos yj.comp.Position
---@param dim yj.comp.Dimension
function Drawable.new (
    pos,
    dim
)
    return base {
        position = pos or Position.new(0, 0),
        dimension = dim or Dimension.new(25, 25),
    }
end

---@deprecated
---@return boolean
function Drawable:isHidden () return self.hidden end

---@deprecated
---@param hidden boolean
function Drawable:setHidden (hidden) self.hidden = hidden end

---@return boolean
function Drawable:isVisible () return self.visible end

---@param visible boolean
function Drawable:setVisible (visible) self.visible = visible end

return Drawable