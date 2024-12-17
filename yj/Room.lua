local Yami = require 'Yami'

---@class yj.Room
---@field width number
---@field height number
---@field player { position: yj.comp.Position }
--- Event Handlers
---@field onInit fun(self: yj.Room)
local Room = Yami.def()
local base = Yami.base(Room)

function Room.new (width, height)
    return base {
        width = width or 1,
        height = height or 1,
    }
end

function Room:setPlayer (player)
    self.player = player.position and player or nil
end

function Room:setController (controller)
    self.controller = controller
end

return Room