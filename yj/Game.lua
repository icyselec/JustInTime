local Yami = require 'Yami'

---@class yj.Game
local Game = Yami.def()
local base = Yami.base(Game)

function Game.new ()
    return base {
    }
end

function Game:update (dt)

end

function Game:draw ()

end

function Game:onMouseMoved (x, y, dx, dy)

end

function Game:onMousePressed (x, y, button, istouch, presses)

end

function Game:onMouseReleased (x, y, button, istouch, presses)

end

return Game