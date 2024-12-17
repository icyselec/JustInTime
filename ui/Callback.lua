local Yami = require 'Yami'

-- on ~ is event handler
-- ~ is (for example, Update) is callback

---@alias ui.CallbackFunction fun(self: ui.Component, ...): ui.Component?

--- for extra type safety
---@enum ui.Callback
local Callback = {

}

return Callback