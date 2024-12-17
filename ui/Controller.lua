local Yami = require 'Yami'

---@class ui.Controller: ui.Container
---@field animation_time number
local Controller = Yami.def()
local base = Yami.base(Controller)

function Controller.new ()
    return base {

    }
end

local function update_component (self, cont)
    if self.update then
        self:update(cont)
    end
end

function Controller:update (dt)
    self:foreach(update_component)
end

local function draw_component (self, cont)
    if self.draw then
        self:draw(cont)
    end
end

function Controller:draw ()
    self:foreach(draw_component)
end

function Controller:onMouseMoved (x, y)

end

return Controller