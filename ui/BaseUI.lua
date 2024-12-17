local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'
local Color = require 'yj.comp.Color'

---@class ui.BaseUI
---@field font love.Font
local BaseUI = {}

BaseUI.font = love.graphics.newFont(12)


local default_pos = Position.new(0, 0)
local default_dim = Dimension.new(32, 32)
local panel_col = Color.new(238/255, 238/255, 238/255, 1) -- light gray color
local panel_border_col = Color.new(0, 0, 0, 1) -- black color

-- Button colors

local normal_col = Color.new(0.5, 0.5, 160/255, 1) -- gray and slightly blue color
local hovered_col = Color.new(192/255, 192/255, 1, 1) -- light blue color
local clicked_col = Color.new(0, 111/255, 222/255, 1) -- dark blue color
local disabled_col = Color.new(0.75, 0.75, 1, 1) -- light gray color

-- 0.0 - 1.0
local roundness = 2/32

---@param this ui.Drawable
---@param color? yj.comp.Color
function BaseUI.drawBackPanel (
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
function BaseUI.drawBorder (
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
function BaseUI.drawPanel (
    this,
    color,
    border_color
)
    BaseUI.drawBackPanel(this, color)
    BaseUI.drawBorder(this, border_color)
end

---@param this ui.Drawable.Button
function BaseUI.drawButton (
    this
)
    BaseUI.drawBackPanel(this, normal_col)
    if this.clicked then
        BaseUI.drawBorder(this, clicked_col)
    elseif this.hovered then
        BaseUI.drawBorder(this, hovered_col)
    else
        BaseUI.drawBorder(this, normal_col)
    end
end



---@param this ui.Drawable.Text
---@param textBatch? love.TextBatch
function BaseUI.drawText (
    this,
    textBatch
)
    textBatch = textBatch or this.textBatch
    -- text dimensions
    local tw, th = textBatch:getDimensions()

    -- draw text
    love.graphics.draw(
        textBatch,
        this.position.x - math.floor(tw/2),
        this.position.y - math.floor(th/2)
    )
end

return BaseUI