local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

---@alias ui.Drawable.OnDraw fun(self: ui.Component, renderer: ui.Renderer): ui.Component?

---@class ui.Drawable.Event
---@field onDraw ui.Drawable.OnDraw

---@class ui.Drawable.Callback
---@field Draw? ui.Drawable.OnDraw

---@class ui.Drawable.Text: ui.Drawable
---@field textBatch love.TextBatch

---@class ui.Drawable.Button: ui.Drawable.Text
---@field hovered boolean
---@field clicked boolean
---@field enabled boolean

---@class ui.Drawable: ui.Component, ui.Drawable.Event
---@field dimension yj.comp.Dimension
---@field activated boolean
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

---@param activated boolean
function Drawable:activate (
    activated
)
    self.activated = activated
end

function Drawable:isActivated ()
    return self.activated
end

return Drawable