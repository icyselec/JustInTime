local Yami = require 'Yami'

---@class ui.IComponent

---@class ui.Component
---@field position yj.comp.Position
---@field handlers { [string]: fun(self: self, ...): any }
---@field userData any
---@field onUpdate ui.UpdateCallback
---@field onMouseMoved ui.MouseMovedCallback
---@field onMousePressed ui.MousePressedCallback
---@field onMouseReleased ui.MouseReleasedCallback
local Component = Yami.def()
-- Component는 추상 클래스에 가깝다. (정확히는 추상 클래스가 아니고, 함수의 집합인 모듈.)
-- 그래서 Component는 base를 가질 필요가 없으니까 base 자동 완성 하지 마라.

-- Yami의 입장에서, 모든 모듈은 함수의 집합인 모듈로 간주한다. 그래서 def은 클래스를 정의하는 함수이기도 한데 본질적으로 보면 모듈 이름 여러개를 받아서 그걸 모두 합성한 새로운 모듈을 반환하는 함수이다.
-- 그렇게 반환받은 모듈에 이름을 붙히고 마음대로 사용하면 된다. 어차피 반환받은 모듈은 실제 모듈이 아니고 모듈의 복사본이므로 원래 모듈에 영향이 전혀 가지 않는다.

-- Component는 The Powder Toy의 UI Component와 비슷하다. (애초에 그거 보고 따라 만듬)

---@alias ui.Component.SupportedEvent
---| '"onMouseMoved"'
---| '"onMousePressed"'
---| '"onMouseReleased"'
---| '"onEnter"'
---| '"onLeave"'
---| '"onDraw"'
---| '"onClick"'

--- This function is move the component to the new position.
---@param dx number
---@param dy number
function Component:move (dx, dy)
    self.position:move(dx, dy)
end

---@alias ui.Component.EventHandler fun(self: ui.Component, ...): ui.Component?

---@param name string
---@return ui.Component.EventHandler?
function Component:getHandler (
    name
)
    if not self.handlers then
        return nil
    end

    return self.handlers[name]
end

---@param name ui.Component.SupportedEvent
---@param handler ui.Component.EventHandler
---@return ui.Component.EventHandler
function Component:setHandler (
    name,
    handler
)
    if not self.handlers then
        self.handlers = {}
    end

    local prev_handler = self.handlers[name]
    self.handlers[name] = handler
    return prev_handler
end

---comment
---@param name string
---@param ... any
---@return ui.Component?
function Component:invokeHandler (
    name,
    ...
)
    local handler = self:getHandler(name)
    if handler then
        return handler(self, ...)
    end

    return nil
end


return Component