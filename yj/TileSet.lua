local Yami = require 'Yami'

local Dimension = require 'yj.comp.Dimension'
local Position = require 'yj.comp.Position'

---@class yj.TileSet
---@field dimension yj.comp.Dimension
---@field tileDimension yj.comp.Dimension
---@field image love.Texture
---@field quads love.Quad[]
---@field spriteBatch love.SpriteBatch
---@field position yj.comp.Position
local TileSet = Yami.def()
local base = Yami.base(TileSet)

---@param dimension? yj.comp.Dimension
---@param tileDimension yj.comp.Dimension
---@param tileSetImage love.Texture
---@param quads? love.Quad[]
---@param spriteBatch? love.SpriteBatch
---@param position? yj.comp.Position
function TileSet.new (
    dimension,
    tileDimension,
    tileSetImage,
    quads,
    spriteBatch,
    position
)
    assert(tileDimension, 'tileDimension must be provided')
    assert(tileSetImage, 'tileSetImage must be provided')
    dimension = dimension or Dimension.new(
        tileSetImage:getWidth() / tileDimension.width,
        tileSetImage:getHeight() / tileDimension.height
    )

    if not quads then
        quads = {}

        for y = 0, dimension.height - 1 do
            for x = 0, dimension.width - 1 do
                quads[y * dimension.width + x] = love.graphics.newQuad(
                    x * tileDimension.width,
                    y * tileDimension.height,
                    tileDimension.width,
                    tileDimension.height,
                    tileSetImage:getDimensions()
                )
            end
        end
    end

    if not spriteBatch then
        spriteBatch = love.graphics.newSpriteBatch(tileSetImage, dimension.width * dimension.height)
    end

    return base {
        dimension = dimension,
        tileDimension = tileDimension,
        image = tileSetImage,
        quads = quads,
        spriteBatch = spriteBatch,
        position = position or Position.new(),
    }
end

function TileSet:placeTile (x, y, tileIndex)
    self.spriteBatch:add(self.quads[tileIndex], x * self.tileDimension.width, y * self.tileDimension.height)
end

function TileSet:draw (x, y)
    x = x or self.position.x
    y = y or self.position.y

    love.graphics.draw(self.spriteBatch, x, y)
end

return TileSet