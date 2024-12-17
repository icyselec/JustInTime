---@meta ui.Callback

---@alias ui.MouseMovedCallback fun(self: ui.Component, x: number, y: number, dx: number, dy: number, istouch: boolean): ui.Component?
---@alias ui.MousePressedCallback fun(self: ui.Component, x: number, y: number, button: number, istouch: boolean, presses: number): ui.Component?
---@alias ui.MouseReleasedCallback fun(self: ui.Component, x: number, y: number, button: number, istouch: boolean): ui.Component?
---@alias ui.MouseFocusCallback fun(self: ui.Component, focus: boolean): ui.Component?

---@alias ui.KeyPressedCallback fun(self: ui.Component, key: love.KeyConstant, scancode: love.Scancode, isrepeat: boolean): ui.Component?
---@alias ui.KeyReleasedCallback fun(self: ui.Component, key: love.KeyConstant, scancode: love.Scancode): ui.Component?
---@alias ui.FocusCallback fun(self: ui.Component, focus: boolean): ui.Component?

---@alias ui.QuitCallback fun(self: ui.Component): ui.Component?

---@alias ui.DrawCallback fun(self: ui.Component, renderer: ui.Renderer): ui.Component?
---@alias ui.UpdateCallback fun(self: ui.Component, dt: number): ui.Component?