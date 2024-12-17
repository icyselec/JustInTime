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

---@param breaking boolean
---@param f ui.Component.EventHandler
---@param ... any
---@return ui.Component?
function Container:foreach (
    breaking,
    f,
    ...
)
    local retval

    for _, comp in ipairs(self) do
        retval = f(comp, ...)
        if breaking and retval then
            return retval
        end
    end

    return retval
end



return Container