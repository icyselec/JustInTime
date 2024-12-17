local Yami = require 'Yami'

---@class ui.Container
---@field [number] ui.Component
---@field position? yj.comp.Position
local Container = {}

---@param comp ui.Component
function Container:addComponent (
    comp
)
    table.insert(self, comp)
    return self
end

---@param comp ui.Component
function Container:removeComponent (
    comp
)
    for i, v in ipairs(self) do
        if v == comp then
            table.remove(self, i)
            return self
        end
    end
end

return Container