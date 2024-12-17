local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Health = require 'yj.comp.Health'

local Unit = require 'yj.Unit'

---@class yj.Player: yj.Unit.Impl
---@field health yj.comp.Health
local Player = Yami.def()
local base = Yami.base(Player)

---comment
---@param pos yj.comp.Position
---@param health yj.comp.Health
---@return yj.Player
function Player.new (pos, health)
    return base {
        position = pos or Position.new(),
        health = health or Health.new(100),
    }
end

---@param x number
---@param y number
---@return yj.comp.Position
function Player:move (x, y)
    return self.position:move(x, y)
end

return Player