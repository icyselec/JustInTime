local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'
local Color = require 'yj.comp.Color'

---@class ui.Renderer
---@field transform love.Transform
local Renderer = Yami.def()
local base = Yami.base(Renderer)

function Renderer.new ()
    return base {
        transform = love.math.newTransform(),
    }
end

local default_pos = Position.new(0, 0)
local default_dim = Dimension.new(32, 32)
local panel_col = Color.new(238/255, 238/255, 238/255, 1) -- light gray color
local panel_border_col = Color.new(0, 0, 0, 1) -- black color

-- Button colors

local normal_col = Color.new(0.5, 0.5, 160/255, 1) -- gray and slightly blue color
local hovered_col = Color.new(192/255, 192/255, 1, 1) -- light blue color
local clicked_col = Color.new(0, 111/255, 222/255, 1) -- dark blue color
local disabled_col = Color.new(0.75, 0.75, 1, 1) -- light gray color

local text_col = Color.new(0, 0, 0, 1) -- black color

-- 0.0 - 1.0
local roundness = 2/32

---@param self ui.Renderer
---@param this ui.Drawable
---@param color? yj.comp.Color
function Renderer:drawBackPanel (
    this,
    color
)
    color = color or panel_col

    local x, y = this.position.x, this.position.y
    local w, h = this.dimension.width, this.dimension.height

    -- draw panel
    love.graphics.setColor(color)
    love.graphics.rectangle(
        'fill',
        x - math.floor(w/2),
        y - math.floor(h/2),
        w,
        h,
        w * roundness,
        h * roundness
    )
end

---@param this ui.Drawable
---@param color? yj.comp.Color
function Renderer:drawBorder (
    this,
    color
)
    color = color or panel_border_col

    local x, y = this.position.x, this.position.y
    local w, h = this.dimension.width-2, this.dimension.height-2

    -- draw border
    love.graphics.setColor(color)
    love.graphics.rectangle(
        'line',
        x - math.floor(w/2) + 0.5,
        y - math.floor(h/2) + 0.5,
        w - 1.0,
        h - 1.0,
        w * roundness,
        h * roundness
    )
end

---@param this ui.Drawable
---@param color? yj.comp.Color
---@param border_color? yj.comp.Color
function Renderer:drawPanel (
    this,
    color,
    border_color
)
    self:drawBackPanel(this, color)
    self:drawBorder(this, border_color)
end

---@param this ui.Drawable.Button
function Renderer:drawButton (
    this
)
    self:drawBackPanel(this, normal_col)
    if this.clicked then
        self:drawBorder(this, clicked_col)
    elseif this.hovered then
        self:drawBorder(this, hovered_col)
    else
        self:drawBorder(this, normal_col)
    end
end



---@param this ui.Drawable.Text
---@param textBatch? love.TextBatch
function Renderer:drawTextBatch (
    this,
    textBatch
)
    textBatch = textBatch or this.textBatch
    -- text dimensions
    local tw, th = textBatch:getDimensions()

    love.graphics.push('all')
    love.graphics.setColor(text_col)
    -- draw text
    love.graphics.draw(
        textBatch,
        this.position.x - math.floor(tw/2),
        this.position.y - math.floor(th/2)
    )

    love.graphics.pop()
end

function Renderer:drawText (
    this,
    text
)
    love.graphics.print(text, this.position.x, this.position.y)
end

--- Wrapper for love.graphics.draw, but apply Renderer's own state.
---@overload fun(drawable: love.Drawable, x?: number, y?: number, r?: number, sx?: number, sy?: number, ox?: number, oy?: number, kx?: number, ky?: number)
---@overload fun(texture: love.Texture, quad: love.Quad, x: number, y: number, r?: number, sx?: number, sy?: number, ox?: number, oy?: number, kx?: number, ky?: number)
---@overload fun(drawable: love.Drawable, transform: love.Transform)
---@overload fun(texture: love.Texture, quad: love.Quad, transform: love.Transform)
function Renderer:draw (...)
    love.graphics.replaceTransform(self.transform)
    love.graphics.draw(...)
end

return Renderer