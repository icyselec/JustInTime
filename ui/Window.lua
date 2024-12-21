-- ui.Window
-- Window는 모든 UI 컴포넌트를 제어하는 최상위 컴포넌트이다.
-- 컴포넌트에는 Window도 포함되므로, Window 안에 Window가 있을 수 있다.
-- Window는 UI 컴포넌트를 관리하고, 이벤트를 처리한다.
-- Window는 UI 컴포넌트를 그리는 역할도 한다.
-- Window는 UI 컴포넌트를 업데이트하는 역할도 한다.
-- 아무튼 많은 역할을 담당하지만 Window는 ui.Component의 일종이라는 것을 기억해야 한다.

-- ui.Window 설계 패러다임
-- 기본적으로 ui.Window는 윈도우 시스템을 모방한다. 그래서 어떤 Window에 입력 이벤트가 발생하는 것은 데스크탑 환경에서 윈도우에 마우스 이벤트가 발생하는 것과 동치로 취급한다.
-- 그래서 기능이 적고 콜백 함수를 부착하는 방식으로 설계된 것이다.
-- 프로그램에서 생성한 루트 윈도우는 그 프로그램의 프로세스와 같은 것으로 생각한다. 그래서 그 루트 윈도우가 모든 입력 이벤트를 잡아야 하며, 하위 윈도우에게 적절히 분배하여야 한다.

-- 메타컴포넌트 개념 이론
-- Lua에 메타테이블이 있듯이, 우리 프레임워크에서는 메타컴포넌트가 있다.
-- 메타테이블은 어떤 객체에 이벤트가 발생했을 때, 호출되는 메타메서드의 집합이다.
-- 메타컴포넌트는 어떤 컴포넌트에 이벤트가 발생했을 때, 호출되는 메타콜백의 집합이다. 
-- 아주 간단하지만, 활용도가 무척 높다. 우리 프레임워크에서는 상속을 사용하지 않는 경향이 강한데, UI에서는 상속의 이점이 매우 크기 때문에 메타컴포넌트라는 개념을 만든 것이다.
-- 메타컴포넌트 개념을 사용하면 풍부한 타입 힌트를 제공하기 어렵다는 점도 극복해낼 수 있다.
-- 예를 들어, 어떤 이벤트 형식이든 간에 현재로서는 첫번째 인자가 `ui.Common` 형식을 받도록 제한되어 있다.
-- 하지만 메타컴포넌트 개념을 사용하면 콜백 함수를 추가하는 것은 단순히 그 컴포넌트의 동작을 재정의하는 것이 되므로 이런 제한을 극복할 수 있다.

--- Helper module
local Yami = require 'Yami'

--- Extend from
local Component = require 'ui.Component'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

local Renderer = require 'ui.Renderer'

-- 짧은 Lua 최적화 테크닉.
-- 함수는 사실 클로저이다.
-- 클로저를 대량 생성하면 성능이 저하될 수 있다.
-- 미리 생성해놓고 나중에 필요할 때 호출하는 것이 최적의 성능을 낸다.
-- 또한, 너무 무분별한 업밸류 사용을 자제하는 것이 좋다.
-- 그거 편리해보이지만, 다 비용이 든다.

-- 생각이 짧았다. 클로저를 많이 생성하는 것보다 가변 인자를 쓰는게 훨씬 성능에 최악이다.


---@alias ui.Window.OnClose fun(self: ui.Component): any
---@alias ui.Window.OnQuitAborted fun(self: ui.Component): boolean
---@alias ui.Window.OnError fun(self: ui.Component, msg: string): any
---@alias ui.Window.OnGrab fun(self: ui.Component, grab: boolean): any

---@alias ui.Window.OnHoveringChanged fun(self: ui.Component, new?: ui.Component): any
---@alias ui.Window.OnGrabbingChanged fun(self: ui.Component, new?: ui.Component): any

---@class ui.Window.Callback: ui.Common.Callback
---@field onClose? ui.Window.OnClose
---@field onQuitAborted? ui.Window.OnQuitAborted
---@field onError? ui.Window.OnError
---@field onHoveringChanged? ui.Window.OnHoveringChanged
---@field onGrabbingChanged? ui.Window.OnGrabbingChanged
---@field onGrab? ui.Window.OnGrab

---@class ui.Window: ui.Component, ui.Container, ui.Iterable, ui.Window.Callback, ui.Contactable, ui.Drawable
---@field hovering? ui.Component # 현재 마우스가 가리키고 있는 컴포넌트
---@field grabbing? ui.Component # 현재 마우스가 클릭하고 있는 컴포넌트
---@field activated boolean
---@field mousePosition yj.comp.Position
---@field renderer ui.Renderer
---@field callback ui.Window.Callback
---@field visible boolean
local Window = Yami.def('ui.Component', 'ui.Container', 'ui.Iterable')
local base = Yami.base(Window)

--- Create a new root window.
---@param pos? yj.comp.Position
---@param dim? yj.comp.Dimension
---@return ui.Window
function Window.new (
    pos,
    dim
)
    local w, h = love.graphics.getDimensions()

    return base {
        position = pos or Position.new(w/2, h/2),
        dimension = dim or Dimension.new(w, h),
        active = true,
        visible = true,
    }
end

function Window:show ()
    self.visible = true
end

function Window:hide ()
    self.visible = false
end

-- Implement ui.Contactable

function Window:isContact (x, y)
    local self_x, self_y = self.position.x - self.dimension.width / 2, self.position.y - self.dimension.height / 2

    return x >= self_x and x <= self_x + self.dimension.width and y >= self_y and y <= self_y + self.dimension.height
end


---@param self ui.Container
---@param comp? ui.Component
---@param index? integer
---@return integer?
local function findIndex (self, comp, index)
    index = index or #self

    if index < 1 then
        return nil
    end

    if self[index] == comp then
        return index
    end

    return findIndex(self, comp, index - 1)
end

local function toTop (a, b)

end

---@deprecated Use `setFocusing` instead.
--- Reorder the component.
--- The component is moved to the last index.
--- If the component is not found, nothing happens.
---@param comp ui.Component
function Window:reorder (comp)
    table.sort(self, function (a, _)
        return a ~= comp
    end)
end


local debugcount = 0
function Window:getFocusing ()
    for i = #self, 1, -1 do
        debugcount = debugcount + 1
        if debugcount > 75*10 then
            error('possible infinite loop')
        end
        local v = self[i]
        if v.active and v.visible and v.isContact then
            return v
        end
    end
end

---@param comp ui.Component
function Window:setFocusing (comp)
    if not comp then
        return
    end

    local index

    for i = #self, 1, -1 do
        local v = self[i]
        if v == comp then
            index = i
            break
        end
    end

    table.remove(self, index)
    self[#self + 1] = comp
end


local function defaultAudioDisconnectedHandler (self, ...)
    return select('#', ...) ~= 0
end
---@param self ui.Component
local function propAudioDisconnectedEvent (self, sources)
    local behavior = self.onAudioDisconnected

    if not behavior then
        return
    end

    local _, result = behavior(self, sources)
    return result
end
---@type ui.Common.OnAudioDisconnected
function Window:onAudioDisconnected (
    sources
)
    return self:propagate(defaultAudioDisconnectedHandler, propAudioDisconnectedEvent, sources)
end

---@type ui.Common.OnDirectoryDropped
function Window:onDirectoryDropped (
    path
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onDirectoryDropped

        if not behavior then
            return true
        end

        return behavior(focusing, path)
    end
end

---@type ui.Common.OnDisplayRotated
local function propDisplayRotatedEvent (
    self,
    index,
    orientation
) ---@cast self ui.Component
    local behavior = self.onDisplayRotated

    if not behavior then
        return true
    end

    return behavior(self, index, orientation)
end

---@type ui.Common.OnDisplayRotated
function Window:onDisplayRotated (
    index,
    orientation
)
    self:foreach(propDisplayRotatedEvent, index, orientation)
end


---@type ui.Common.OnDraw
local function drawChildren (self) ---@cast self ui.Component, +ui.Drawable
    local behavior = self.visible and self.onDraw

    if not behavior then
        return true
    end

    return behavior(self)
end
---@type ui.Common.OnDraw
function Window:onDraw ()
    love.graphics.push('all')
    love.graphics.translate(self.position.x, self.position.y)

    self:foreach(drawChildren)
    love.graphics.pop()
end

local function getTop (self, x, y)
    if self.active and self.visible and self.isContact and self:isContact(x, y) then
        return self
    end
end

---@type ui.Common.OnErrorHandler
function Window:onErrorHandler (
    msg
)
    
end

---@type ui.Common.OnFileDropped
function Window:onFileDropped (
    file
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onFileDropped

        if not behavior then
            return true
        end

        return behavior(focusing, file)
    end
end

---@type ui.Common.OnFocus
function Window:onFocus (
    focus
)
    if self.grabbing then
        local onGrabbingChanged = self.onGrabbingChanged

        if onGrabbingChanged then
            onGrabbingChanged(self, nil)
        end
    end
end



---@type ui.Common.OnGamepadAxis
function Window:onGamepadAxis (
    joystick,
    axis,
    value
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onGamepadAxis

        if not behavior then
            return true
        end

        return behavior(focusing, joystick, axis, value)
    end
end
---@type ui.Common.OnGamepadPressed
function Window:onGamepadPressed (
    joystick,
    button
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onGamepadPressed

        if not behavior then
            return true
        end

        return behavior(focusing, joystick, button)
    end
end
---@type ui.Common.OnGamepadReleased
function Window:onGamepadReleased (
    joystick,
    button
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onGamepadReleased

        if not behavior then
            return true
        end

        return behavior(focusing, joystick, button)
    end
end





---@param self ui.Component
local function propJoystickAddedEvent (self, joystick)
    local behavior = self.onJoystickAdded

    if not behavior then
        return true
    end

    return behavior(self, joystick)
end
---@type ui.Common.OnJoystickAdded
function Window:onJoystickAdded (
    joystick
)
    self:foreach(propJoystickAddedEvent, joystick)
end
---@type ui.Common.OnJoystickAxis
function Window:onJoystickAxis (
    joystick,
    axis,
    value
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onJoystickAxis

        if not behavior then
            return true
        end

        return behavior(self, joystick, axis, value)
    end
end
---@type ui.Common.OnJoystickHat
function Window:onJoystickHat (
    joystick,
    hat,
    direction
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onJoystickHat

        if not behavior then
            return true
        end

        return behavior(self, joystick, hat, direction)
    end
end
---@type ui.Common.OnJoystickPressed
function Window:onJoystickPressed (
    joystick,
    button
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onJoystickPressed

        if not behavior then
            return true
        end

        return behavior(self, joystick, button)
    end
end
---@type ui.Common.OnJoystickReleased
function Window:onJoystickReleased (
    joystick,
    button
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onJoystickReleased

        if not behavior then
            return true
        end

        return behavior(self, joystick, button)
    end
end
---@param self ui.Component
local function propJoystickRemovedEvent (self, joystick)
    local behavior = self.onJoystickRemoved

    if not behavior then
        return true
    end

    return behavior(self, joystick)
end
---@type ui.Common.OnJoystickRemoved
function Window:onJoystickRemoved (
    joystick
)
    self:foreach(propJoystickRemovedEvent, joystick)
end
---@type ui.Common.OnJoystickSensorUpdated
function Window:onJoystickSensorUpdated (
    joystick,
    sensorType,
    x,
    y,
    z
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onJoystickSensorUpdated

        if not behavior then
            return true
        end

        return behavior(self, joystick, sensorType, x, y, z)
    end
end





---@type ui.Common.OnKeyPressed
function Window:onKeyPressed (
    key,
    scancode,
    isrepeat
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onKeyPressed

        if not behavior then
            return true
        end

        -- 저는 여기의 첫번째 인자가 self 였다는 사실이 믿기지가 않습니다.
        return behavior(focusing, key, scancode, isrepeat)
    end
end
---@param key love.KeyConstant
---@param scancode love.Scancode
function Window:onKeyReleased (
    key,
    scancode
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onKeyReleased

        if not behavior then
            return true
        end

        return behavior(focusing, key, scancode)
    end
end

---@param self ui.Component
local function propLocaleChangedEvent (self)
    local behavior = self.onLocaleChanged

    if not behavior then
        return true
    end

    return behavior(self)
end
---@type ui.Common.OnLocaleChanged
function Window:onLocaleChanged ()
    self:foreach(propLocaleChangedEvent)
end

---@param self ui.Component
local function propLowMemoryEvent (self)
    local behavior = self.onLowMemory

    if not behavior then
        return true
    end

    return behavior(self)
end
---@type ui.Common.OnLowMemory
function Window:onLowMemory ()
    self:foreach(propLowMemoryEvent)
end

--- Entry point of the mouse event.

---@type ui.Common.OnMouseFocus
function Window:onMouseFocus (
    focus
)
    return true
end

function Window:isHover (x, y)
    if self.active and self.visible and self.isContact and self:isContact(x, y) then
        return self
    end
end

function Window:findTop (x, y)
    local value, index

    for i, v in ipairs(self) do
        -- 임시로 diagnostic을 비활성화 했고 나중에 고칠 계획.
        if v.active and v.visible and v.isContact and v:isContact(x, y) then ---@diagnostic disable-line: undefined-field
            value = v
            index= i
        end
    end

    return value, index
end

---@type ui.Common.OnMouseMoved
function Window:onMouseMoved (
    x,
    y,
    dx,
    dy,
    istouch
)
    local lx, ly = self.position:toLocal(x, y)

    if self.grabbing then
        local behavior = self.grabbing.onMouseMoved

        if not behavior then
            return true
        end

        return behavior(self.grabbing, lx, ly, dx, dy, istouch)
    else
        local top, index = self:findTop(lx, ly)

        if self.hovering ~= top then
            local behavior = self.onHoveringChanged

            if behavior then
                behavior(self, top)
            end
        end

        if top then
            local behavior = top.onMouseMoved

            if not behavior then
                return true
            end

            return behavior(top, lx, ly, dx, dy, istouch)
        end
    end
end


---@type ui.Common.OnMousePressed
function Window:onMousePressed (
    x,
    y,
    button,
    istouch,
    presses
)
    local lx, ly = self.position:toLocal(x, y)

    if self.grabbing then
        local behavior = self.grabbing.onMousePressed

        if not behavior then
            return true
        end

        return behavior(self.grabbing, lx, ly, button, istouch, presses)
    else
        local top, index = self:findTop(lx, ly)

        if self.hovering ~= top then
            local behavior = self.onHoveringChanged

            if behavior then
                behavior(self, top)
            end
        end

        if top then
            local behavior

            behavior = self.onGrabbingChanged

            if behavior then
                behavior(self, top)
            end

            behavior = top.onMousePressed

            if not behavior then
                return true
            end

            return behavior(top, lx, ly, button, istouch, presses)
        end
    end
end

---@type ui.Common.OnMouseReleased
function Window:onMouseReleased (
    x,
    y,
    button,
    istouch
)
    local lx, ly = self.position:toLocal(x, y)

    if self.grabbing then
        local behavior = self.grabbing.onMouseReleased

        if not behavior then
            return true
        end

        behavior(self.grabbing, lx, ly, button, istouch)

        local onGrabbingChanged = self.onGrabbingChanged

        if not onGrabbingChanged then
            return true
        end

        return onGrabbingChanged(self, nil)
    else
        local top, index = self:findTop(lx, ly)

        if self.hovering ~= top then
            local behavior = self.onHoveringChanged

            if behavior then
                behavior(self, top)
            end
        end

        if top then
            local behavior = top.onMouseReleased

            if not behavior then
                return true
            end

            return behavior(top, lx, ly, button, istouch)
        end
    end
end

---@param self ui.Component | ui.Window
local function defaultQuitAbortedHandler (self)
    local behavior = self.onQuitAborted

    if not behavior then
        return true, false
    end

    return behavior(self)
end
---@param self ui.Component
local function propQuitEvent (self)
    local behavior = self.onQuit

    if not behavior then
        return true, false
    end

    return behavior(self)
end
---@type ui.Common.OnQuit
function Window:onQuit ()
    return self:propagate(defaultQuitAbortedHandler, propQuitEvent)
end
---@return boolean?
function Window:onQuitAborted () end

---@type ui.Common.OnResize
function Window:onResize (
    w,
    h
)
    self.dimension.width = w
    self.dimension.height = h

    return true
end

---@type ui.Common.OnSensorUpdated
function Window:onSensorUpdated (
    sensorType,
    x,
    y,
    z
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onSensorUpdated

        if not behavior then
            return true
        end

        return behavior(focusing, sensorType, x, y, z)
    end
end

---@type ui.Common.OnTextEdited
function Window:onTextEdited (
    text,
    start,
    length
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onTextEdited

        if not behavior then
            return true
        end

        return behavior(focusing, text, start, length)
    end
end
---@type ui.Common.OnTextInput
function Window:onTextInput (
    text
)
    local focusing = self:getFocusing()

    if focusing then
        local behavior = focusing.onTextInput

        if not behavior then
            return true
        end

        return behavior(focusing, text)
    end
end

---@param self ui.Component
---@param dt number
local function propUpdateEvent (self, dt)
    local behavior = self.active and self.onUpdate

    if not behavior then
        return true
    end

    return behavior(self, dt)
end
---@type ui.Common.OnUpdate
function Window:onUpdate (
    dt
)
    self:foreach(propUpdateEvent, dt)

    return true
end

---@type ui.Common.OnVisible
function Window:onVisible (
    visible
)
    self.visible = visible
    return true
end

---@type ui.Common.OnWheelMoved
function Window:onWheelMoved (
    x,
    y
)
    if self.hovering then
        local behavior = self.hovering.onWheelMoved

        if not behavior then
            return true
        end

        return behavior(self.hovering, x, y)
    end
end

--- ui.Window's callback definition
--- 만약, 콜백을 적절히 조합해서 움직일 수 있는 컴포넌트를 구현하고자 한다면 다음의 주의사항을 읽어봐야 한다.
--- 1. 컴포넌트가 움직이면 스택의 최상단으로 이동해야 한다. 그렇지 않으면 나쁜 사용자 경험과 버그를 마주하게 된다.
--- 2. 아래에 있는 콜백을 반드시 구현해야 한다. 또한, `onFocusingChanged` 콜백에서는 컴포넌트의 우선순위를 재정렬해주어야 한다.

---@type ui.Window.OnHoveringChanged
function Window:onHoveringChanged (
    new
)
    if self.hovering then
        local behavior = self.hovering.onHoveringChanged

        if behavior then
            behavior(self.hovering, false)
        end
    end

    if new then
        local behavior = new.onMouseFocus

        if behavior then
            behavior(new, true)
        end
    end

    return true
end

---@param grab boolean
function Window:onGrab (
    grab
)
    return true
end

---@type ui.Window.OnGrabbingChanged
function Window:onGrabbingChanged (
    new
)
    if self.grabbing then
        local behavior = self.grabbing.onGrab

        if behavior then
            behavior(self.grabbing, false)
        end
    end

    if new then
        local behavior = new.onGrab

        if behavior then
            behavior(new, true)
        end
    end

    self.grabbing = new

    return true
end


return Window