local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

local Renderer = require 'ui.Renderer'

---@class ui.Label: ui.Drawable.Text
---@field font love.Font
local Label = Yami.def 'ui.Drawable'
local base = Yami.base(Label)

do
    ---@class ui.Label.Dimension: yj.comp.Dimension
    ---@field textBatch love.TextBatch
    local Dimension = Yami.def 'yj.comp.Dimension' ---@diagnostic disable-line: redefined-local
    local base = Yami.base(Dimension)
    local virtual_index = {
        width = function (self)
            return self.textBatch:getWidth()
        end,
        height = function (self)
            return self.textBatch:getHeight()
        end,
    }
    virtual_index.getDimensions = function (self)
        return virtual_index:width(), virtual_index:height()
    end
    function Dimension:__index (key)
        local v = rawget(Dimension, key)
        if v ~= nil then return v end
        return virtual_index[key](self)
    end

    function Dimension.newDimension (
        textBatch
    )
        return base {
            textBatch = textBatch,
            visible = true,
        }
    end

    Dimension.__mode = 'v'

    Label.newDimension = Dimension.newDimension
end

---@param text? string
---@param font? love.Font
function Label.new (
    text,
    font,
    position
)
    local textBatch
    if text then
        textBatch = love.graphics.newTextBatch(font or love.graphics.getFont(), text)
    end

    local o = {
        textBatch = textBatch,
        font = font or love.graphics.getFont(),
        position = position or Position.new(0, 0),
        dimension = Label.newDimension(textBatch),
        active = true,
        visible = true,
        pushes = 0,
    }

    return base(o)
end

function Label:getWidth ()
    return self.textBatch:getWidth()
end

function Label:getHeight ()
    return self.textBatch:getHeight()
end

function Label:getDimensions ()
    return self.textBatch:getDimensions()
end

---@type ui.Common.OnDraw
function Label:onDraw ()
    self:backup(true)
    love.graphics.setFont(self.font)
    --love.graphics.print(self.text, self.position.x - (self.dimension.width/2), self.position.y - (self.dimension.height/2))

    Renderer:drawTextBatch(self)

    self:backup(false)
end

function Label:setText (text)
    if self.textBatch then
        self.textBatch:clear()
        self.textBatch:add(text)
    end
end

return Label