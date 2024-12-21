local Yami = require 'Yami'

--- Extend from
local Window = require 'ui.Window'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

local Renderer = require 'ui.Renderer'

---@class ui.Panel: ui.Window
local Panel = Yami.def('ui.Window')
local base = Yami.base(Panel)

---comment
---@param pos? yj.comp.Position
---@param dim? yj.comp.Dimension
function Panel.new (
    pos,
    dim
)
    return base {
        position = pos or Position.new(0, 0),
        dimension = dim or Dimension.new(25, 25),
        active = true,
        visible = true,
    }
end

---@param self ui.Drawable
local function drawChildren (
    self
)
    local behavior = self.visible and self.onDraw

    if not behavior then
        return true
    end

    if behavior then
        return behavior(self)
    end
end

---@type ui.Common.OnDraw
function Panel:onDraw ()
    love.graphics.push('all')
    Renderer:drawPanel(self)

    love.graphics.translate(self.position.x, self.position.y)
    self:foreach(drawChildren)
    love.graphics.pop()

    return true
end

--- Not supported events

Panel.onAudioDisconnected = nil
Panel.onDirectoryDropped = nil
Panel.onErrorHandler = nil
Panel.onFileDropped = nil
Panel.onLocaleChanged = nil
Panel.onLowMemory = nil
Panel.onQuit = nil
Panel.onResize = nil
Panel.onThreadError = nil

return Panel