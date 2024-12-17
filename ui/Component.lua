local Yami = require 'Yami'

---@alias ui.Component.OnUpdate fun(self: ui.Component, dt: number): ui.Component?
---@alias ui.Component.OnMouseMoved fun(self: ui.Component, x: number, y: number, dx: number, dy: number, istouch: boolean): ui.Component?
---@alias ui.Component.OnMousePressed fun(self: ui.Component, x: number, y: number, button: number, istouch: boolean, presses: number): ui.Component?
---@alias ui.Component.OnMouseReleased fun(self: ui.Component, x: number, y: number, button: number, istouch: boolean): ui.Component?
---@alias ui.Component.OnMouseFocus fun(self: ui.Component, focus: boolean): ui.Component?
---@alias ui.Component.OnKeyPressed fun(self: ui.Component, key: love.KeyConstant, scancode: love.Scancode, isrepeat: boolean): ui.Component?
---@alias ui.Component.OnKeyReleased fun(self: ui.Component, key: love.KeyConstant, scancode: love.Scancode): ui.Component?

---@class ui.Component.Event
---@field onUpdate ui.Component.OnUpdate
---@field onMouseMoved ui.Component.OnMouseMoved
---@field onMousePressed ui.Component.OnMousePressed
---@field onMouseReleased ui.Component.OnMouseReleased
---@field onKeyPressed ui.Component.OnKeyPressed
---@field onKeyReleased ui.Component.OnKeyReleased

---@class ui.Component.Callback
---@field Update? ui.Component.OnUpdate
---@field MouseMoved? ui.Component.OnMouseMoved
---@field MousePressed? ui.Component.OnMousePressed
---@field MouseReleased? ui.Component.OnMouseReleased
---@field KeyPressed? ui.Component.OnKeyPressed
---@field KeyReleased? ui.Component.OnKeyReleased

---@class ui.Component: ui.Component.Event
---@field position yj.comp.Position
---@field handlers { [string]: fun(self: self, ...): any }
---@field userData any
---@field callback ui.Component.Callback
local Component = Yami.def()
-- Component는 추상 클래스에 가깝다. (정확히는 추상 클래스가 아니고, 함수의 집합인 모듈.)
-- 그래서 Component는 base를 가질 필요가 없으니까 base 자동 완성 하지 마라.

-- Yami의 입장에서, 모든 모듈은 함수의 집합인 모듈로 간주한다. 그래서 def은 클래스를 정의하는 함수이기도 한데 본질적으로 보면 모듈 이름 여러개를 받아서 그걸 모두 합성한 새로운 모듈을 반환하는 함수이다.
-- 그렇게 반환받은 모듈에 이름을 붙히고 마음대로 사용하면 된다. 어차피 반환받은 모듈은 실제 모듈이 아니고 모듈의 복사본이므로 원래 모듈에 영향이 전혀 가지 않는다.

-- Component는 The Powder Toy의 UI Component와 비슷하다. (애초에 그거 보고 따라 만듬)

--- This function is move the component to the new position.
---@param dx number
---@param dy number
function Component:move (dx, dy)
    self.position:move(dx, dy)
end

---@alias ui.Component.EventHandler fun(self: ui.Component, ...): ui.Component?

function Component:getCallback (name)
    if not self.callback then
        return nil
    end

    return self.callback[name]
end

--- Add event callbacks.
---@param name string
---@param callback ui.CallbackFunction
---@return ui.CallbackFunction?
function Component:setCallback (name, callback)
    if not self.callback then
        self.callback = {}
    end

    local prev_callback = self.callback[name]
    self.callback[name] = callback
    return prev_callback
end

--- Invoke callbacks.
---@param name string
---@param ... any
---@return ui.Component?
function Component:invokeCallback (name, ...)
    if self.callback and self.callback[name] then
        return self.callback[name](self, ...)
    end

    return nil
end

return Component