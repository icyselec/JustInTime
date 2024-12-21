local Yami = require 'Yami'

---@class ui.Container
---@field [number] ui.Component
---@field position? yj.comp.Position
local Container = {}

---@generic T: ui.Component
---@param comp T
---@return T
function Container:addComponent (
    comp
)
    table.insert(self, comp)
    return comp
end

---@generic T: ui.Component
---@param comp T
---@return T?
function Container:removeComponent (
    comp
)
    for i, v in ipairs(self) do
        if v == comp then
            table.remove(self, i)
            return v
        end
    end

    return nil
end

return Container