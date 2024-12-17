local Yami = require 'Yami'

---@class ui.Iterable
local Iterable = Yami.def()
local base = Yami.base(Iterable)

---@alias ui.Delegate fun(self: ui.Component, ...): ui.Component?

---@param f ui.Delegate
---@param ... any
function Iterable:foreach (
    f,
    ...
)
    for _, comp in ipairs(self) do
        f(comp, ...)
    end
end

---@param f ui.Delegate
---@param ... any
function Iterable:find (
    f,
    ...
)
    for _, comp in ipairs(self) do
        local v = f(comp, ...)
        if v then
            return v
        end
    end

    return nil
end

---@param f ui.Delegate
---@param ... any
function Iterable:findLast (
    f,
    ...
)
    local v

    for _, comp in ipairs(self) do
        v = f(comp, ...) or v
    end

    return v
end


return Iterable