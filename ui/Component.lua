local Yami = require 'Yami'

local Position = require 'yj.comp.Position'


---@alias ui.Component.OnMetaComponentChanged fun(self: ui.Component, prev?: ui.Component, now?: ui.Component): ui.Component?

---@class ui.Component.Callback: ui.Common.Callback
---@field onMetaComponentChanged? ui.Component.OnMetaComponentChanged


--[[
# `ui.Component`
## 



--]]
---@class ui.Component: ui.Component.Callback, ui.Common
---@field position yj.comp.Position
---@field handlers { [string]: fun(self: self, ...): any }
---@field userData any
---@field callback ui.Component.Callback
---@field active boolean
---@field private metaComponent? ui.Component
local Component = Yami.def()
local base = Yami.base(Component)
-- Component는 추상 클래스에 가깝다. (정확히는 추상 클래스가 아니고, 함수의 집합인 모듈.)
-- 그래서 Component는 base를 가질 필요가 없으니까 base 자동 완성 하지 마라.

-- Yami의 입장에서, 모든 모듈은 함수의 집합인 모듈로 간주한다. 그래서 def은 클래스를 정의하는 함수이기도 한데 본질적으로 보면 모듈 이름 여러개를 받아서 그걸 모두 합성한 새로운 모듈을 반환하는 함수이다.
-- 그렇게 반환받은 모듈에 이름을 붙히고 마음대로 사용하면 된다. 어차피 반환받은 모듈은 실제 모듈이 아니고 모듈의 복사본이므로 원래 모듈에 영향이 전혀 가지 않는다.

-- Component는 The Powder Toy의 UI Component와 비슷하다. (애초에 그거 보고 따라 만듬)

-- 이러한 기본 계획을 뒤집고 기본 생성자를 추가하도록 했다.

function Component.new (
    position
)
    return base {
        position = position or Position.new(0, 0),
        handlers = {},
        userData = nil,
        callback = nil,
        active = true,
        metaComponent = nil,
    }
end

--- This function is move the component to the new position.
---@param dx number
---@param dy number
function Component:move (dx, dy)
    self.position:move(dx, dy)
end

---@alias ui.Component.EventHandler fun(self: ui.Component, ...): ui.Component?





---@return boolean
function Component:isActive () return self.active end

---@param active boolean
function Component:setActive (active) self.active = active end

local function getTop (self, x, y)
    if self.active and not self.hidden and self.isContact then
        if self:isContact(x, y) then
            return self
        end
    end
end

---@generic T
---@param this T
---@param eventName string
---@return fun(self: T, x: number, y: number, button: number, istouch: boolean, presses: number)
function Component.mouseEventHelper (
    this,
    eventName
)
    return function (self, x, y, button, istouch, presses)
        local lx, ly = self.position:toLocal(x, y)

        local focusing = self:findLast(getTop, lx, ly)

        if focusing ~= self.focusing then
            self.focusing:onMouseFocus(false)

            if focusing then
                focusing:onMouseFocus(true)
                focusing[eventName](lx, ly, button, istouch, presses)
            end

            self.focusing = focusing
        else
            if focusing then
                focusing[eventName](lx, ly, button, istouch, presses)
            else
                self:invokeCallback(eventName, x, y, button, istouch, presses)
            end
        end
    end
end


local dummy = {}

---@deprecated Use `getBehavior` instead.
function Component:send (
    _
)
    error('Obsolete function call.')
end


---@deprecated Just indexing the table directly.
---@param name string
function Component:getBehavior (
    name
)
    local v = assert(getmetatable(self), 'no metatable found.')
    return rawget(v, name)
end

---@deprecated Use `getCallback` instead.
function Component:done (_)
    error('Obsolete function call.')
end

---@deprecated Just indexing the table directly.
function Component:getCallback (
    name
)
    local v = rawget(self, name)
    if v ~= nil then return v end
    local m = rawget(self, 'metaComponent')
    if m == nil then return nil end
    return m:getCallback(name)
end

---@param self ui.Component
---@param sources table
local function propAudioDisconnected (
    self,
    sources
)
    if self.onAudioDisconnected then
        self:onAudioDisconnected(sources)
    end
end

--- Start of base event handlers.
--- 기본 이벤트 핸들러 정의의 시작.
--- 이 이벤트 핸들러들은 모든 컴포넌트의 기본 동작으로서 사용됩니다.
--- 만약, 어떤 파생 컴포넌트가 동작을 오버라이드하고 싶다면, 여기에 명시되어 있는 기본 동작을 대신 사용하면 됩니다.
--- 또는, 상속의 기본값이기 때문에 파생 컴포넌트에 이러한 이벤트들을 호출하는 것은 언제나 안전합니다.
--- 
--- 안전성을 위해 언젠가부터 기본 동작(콜백 함수 호출)이 제거되었습니다. 이제 콜백 함수 호출을 원하면 파생 클래스에서 직접 호출하는 코드를 작성해야 합니다.

---@type ui.Common.OnAudioDisconnected
function Component:onAudioDisconnected (
    sources
)
    return true, false
end

---@type ui.Common.OnDirectoryDropped
function Component:onDirectoryDropped (
    path
)
    return true
end

---@type ui.Common.OnDisplayRotated
function Component:onDisplayRotated (
    index,
    orientation
)
    return true
end

---@type ui.Common.OnDraw
function Component:onDraw ()
    return true
end

---@type ui.Common.OnErrorHandler
function Component:onErrorHandler (
    msg
)
    return true
end

---@type ui.Common.OnFileDropped
function Component:onFileDropped (
    file
)
    return true
end

---@type ui.Common.OnFocus
function Component:onFocus (
    focus
)
    return true
end

---@type ui.Common.OnGamepadAxis
function Component:onGamepadAxis (
    joystick,
    axis,
    value
)
    return true
end

---@type ui.Common.OnGamepadPressed
function Component:onGamepadPressed (
    joystick,
    button
)
    return true
end

---@type ui.Common.OnGamepadReleased
function Component:onGamepadReleased (
    joystick,
    button
)
    return true
end

---@type ui.Common.OnJoystickAdded
function Component:onJoystickAdded (
    joystick
)
    return true
end

---@type ui.Common.OnJoystickHat
function Component:onJoystickHat (
    joystick,
    hat,
    direction
)
    return true
end

---@type ui.Common.OnJoystickPressed
function Component:onJoystickPressed (
    joystick,
    button
)
    return true
end

---@type ui.Common.OnJoystickReleased
function Component:onJoystickReleased (
    joystick,
    button
)
    return true
end

---@type ui.Common.OnJoystickRemoved
function Component:onJoystickRemoved (
    joystick
)
    return true
end

---@type ui.Common.OnJoystickSensorUpdated
function Component:onJoystickSensorUpdated (
    joystick,
    sensorType,
    x,
    y,
    z
)
    return true
end

---@type ui.Common.OnKeyPressed
function Component:onKeyPressed (
    key,
    scancode,
    isrepeat
)
    return true
end

---@type ui.Common.OnKeyReleased
function Component:onKeyReleased (
    key,
    scancode
)
    return true
end

---@type ui.Common.OnLocaleChanged
function Component:onLocaleChanged ()
    return true
end

---@type ui.Common.OnLowMemory
function Component:onLowMemory ()
    return true
end

---@type ui.Common.OnMouseFocus
function Component:onMouseFocus (
    focus
)
    return true
end

---@type ui.Common.OnMouseMoved
function Component:onMouseMoved (
    x,
    y,
    dx,
    dy,
    istouch
)
    return true
end

---@type ui.Common.OnMousePressed
function Component:onMousePressed (
    x,
    y,
    button,
    istouch,
    presses
)
    return true
end

---@type ui.Common.OnMouseReleased
function Component:onMouseReleased (
    x,
    y,
    button,
    istouch
)
    return true
end

---@type ui.Common.OnQuit
function Component:onQuit ()
    return true, false
end

---@type ui.Common.OnResize
function Component:onResize (
    w,
    h
)
    return true
end

---@type ui.Common.OnSensorUpdated
function Component:onSensorUpdated (
    sensorType,
    x,
    y,
    z
)
    return true
end

---@type ui.Common.OnTextEdited
function Component:onTextEdited (
    text,
    start,
    length
)
    return true
end

---@type ui.Common.OnTextInput
function Component:onTextInput (
    text
)
    return true
end

---@type ui.Common.OnThreadError
function Component:onThreadError (
    thread,
    errorstr
)
    return true
end

---@type ui.Common.OnTouchMoved
function Component:onTouchMoved (
    id,
    x,
    y,
    dx,
    dy,
    pressure
)
    return true
end

---@type ui.Common.OnTouchPressed
function Component:onTouchPressed (
    id,
    x,
    y,
    dx,
    dy,
    pressure
)
    return true
end

---@type ui.Common.OnTouchReleased
function Component:onTouchReleased (
    id,
    x,
    y,
    dx,
    dy,
    pressure
)
    return true
end

---@type ui.Common.OnUpdate
function Component:onUpdate (
    dt
)
    return true
end

---@type ui.Common.OnVisible
function Component:onVisible (
    visible
)
    return true
end

---@type ui.Common.OnWheelMoved
function Component:onWheelMoved (
    x,
    y
)
    return true
end

return Component