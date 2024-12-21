local Yami = require 'Yami'

-- ui.Node
-- 일반적인 주의사항
-- 1. ui.Node는 콜백 함수의 동작이 기본적으로 정의된 클래스입니다.
-- 2. 절대로 ui.Node를 메타 컴포넌트로 설정하지 마십시오.
-- 3. 기본 동작이 필요하면 차라리 ui.Component를 상속 받으십시오. 아무 것도 하지 않는 것은 코드에서 어떤 상황에서도 가장 안전합니다.
-- 4. 주의사항을 모두 이해했다고 가정합니다. ui.Node의 메타 컴포넌트가 ui.Node의 파생 클래스일 경우, 오류를 내는 것 말고는 방법이 없습니다.

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'
local Component = require 'ui.Component'

---@deprecated DO NOT USE THIS
---@class ui.Node: ui.Component
local Node = Yami.def 'ui.Component'
local base = Yami.base(Node)

function Node.new (position, dimension)
    return base {
        position = position or Position.new(),
        dimension = dimension or Dimension.new(),
    }
end

---@type ui.Common.OnAudioDisconnected
function Node:onAudioDisconnected (
    sources
)
    return self:getCallback 'onAudioDisconnected' (self, sources) or false
end

---@type ui.Common.OnDirectoryDropped
function Node:onDirectoryDropped (
    path
)
    self:getCallback 'onDirectoryDropped' (self, path)
end

---@type ui.Common.OnDisplayRotated
function Node:onDisplayRotated (
    index,
    orientation
)
    self:getCallback 'onDisplayRotated' (self, index, orientation)
end

---@type ui.Common.OnDraw
function Node:onDraw ()
    self:getCallback 'onDraw' (self)
end

---@type ui.Common.OnErrorHandler
function Node:onErrorHandler (
    msg
)
    self:getCallback 'onErrorHandler' (self, msg)
end

---@type ui.Common.OnFileDropped
function Node:onFileDropped (
    file
)
    self:getCallback 'onFileDropped' (self, file)
end

---@type ui.Common.OnFocus
function Node:onFocus (
    focus
)
    self:getCallback 'onFocus' (self, focus)
end

---@type ui.Common.OnGamepadAxis
function Node:onGamepadAxis (
    joystick,
    axis,
    value
)
    self:getCallback 'onGamepadAxis' (self, joystick, axis, value)
end

---@type ui.Common.OnGamepadPressed
function Node:onGamepadPressed (
    joystick,
    button
)
    self:getCallback 'onGamepadPressed' (self, joystick, button)
end

---@type ui.Common.OnGamepadReleased
function Node:onGamepadReleased (
    joystick,
    button
)
    self:getCallback 'onGamepadReleased' (self, joystick, button)
end

---@type ui.Common.OnJoystickAdded
function Node:onJoystickAdded (
    joystick
)
    self:getCallback 'onJoystickAdded' (self, joystick)
end

---@type ui.Common.OnJoystickHat
function Node:onJoystickHat (
    joystick,
    hat,
    direction
)
    self:getCallback 'onJoystickHat' (self, joystick, hat, direction)
end

---@type ui.Common.OnJoystickPressed
function Node:onJoystickPressed (
    joystick,
    button
)
    self:getCallback 'onJoystickPressed' (self, joystick, button)
end

---@type ui.Common.OnJoystickReleased
function Node:onJoystickReleased (
    joystick,
    button
)
    self:getCallback 'onJoystickReleased' (self, joystick, button)
end

---@type ui.Common.OnJoystickRemoved
function Node:onJoystickRemoved (
    joystick
)
    self:getCallback 'onJoystickRemoved' (self, joystick)
end

---@type ui.Common.OnJoystickSensorUpdated
function Node:onJoystickSensorUpdated (
    joystick,
    sensorType,
    x,
    y,
    z
)
    self:getCallback 'onJoystickSensorUpdated' (self, joystick, sensorType, x, y, z)
end

---@type ui.Common.OnKeyPressed
function Node:onKeyPressed (
    key,
    scancode,
    isrepeat
)
    self:getCallback 'onKeyPressed' (self, key, scancode, isrepeat)
end

---@type ui.Common.OnKeyReleased
function Node:onKeyReleased (
    key,
    scancode
)
    self:getCallback 'onKeyReleased' (self, key, scancode)
end

---@type ui.Common.OnLocaleChanged
function Node:onLocaleChanged ()
    self:getCallback 'onLocaleChanged' (self)
end

---@type ui.Common.OnLowMemory
function Node:onLowMemory ()
    self:getCallback 'onLowMemory' (self)
end

---@type ui.Common.OnMouseFocus
function Node:onMouseFocus (
    focus
)
    self:getCallback 'onMouseFocus' (self, focus)
end

---@type ui.Common.OnMouseMoved
function Node:onMouseMoved (
    x,
    y,
    dx,
    dy,
    istouch
)
    self:getCallback 'onMouseMoved' (self, x, y, dx, dy, istouch)
end

---@type ui.Common.OnMousePressed
function Node:onMousePressed (
    x,
    y,
    button,
    istouch,
    presses
)
    self:getCallback 'onMousePressed' (self, x, y, button, istouch, presses)
end

---@type ui.Common.OnMouseReleased
function Node:onMouseReleased (
    x,
    y,
    button,
    istouch
)
    self:getCallback 'onMouseReleased' (self, x, y, button, istouch)
end

---@type ui.Common.OnQuit
function Node:onQuit ()
    return self:getCallback 'onQuit' (self) or false
end

---@type ui.Common.OnResize
function Node:onResize (
    w,
    h
)
    self:getCallback 'onResize' (self, w, h)
end

---@type ui.Common.OnSensorUpdated
function Node:onSensorUpdated (
    sensorType,
    x,
    y,
    z
)
    self:getCallback 'onSensorUpdated' (self, sensorType, x, y, z)
end

---@type ui.Common.OnTextEdited
function Node:onTextEdited (
    text,
    start,
    length
)
    self:getCallback 'onTextEdited' (self, text, start, length)
end

---@type ui.Common.OnTextInput
function Node:onTextInput (
    text
)
    self:getCallback 'onTextInput' (self, text)
end

---@type ui.Common.OnThreadError
function Node:onThreadError (
    thread,
    errorstr
)
    self:getCallback 'onThreadError' (self, thread, errorstr)
end

---@type ui.Common.OnTouchMoved
function Node:onTouchMoved (
    id,
    x,
    y,
    dx,
    dy,
    pressure
)
    self:getCallback 'onTouchMoved' (self, id, x, y, dx, dy, pressure)
end

---@type ui.Common.OnTouchPressed
function Node:onTouchPressed (
    id,
    x,
    y,
    dx,
    dy,
    pressure
)
    self:getCallback 'onTouchPressed' (self, id, x, y, dx, dy, pressure)
end

---@type ui.Common.OnTouchReleased
function Node:onTouchReleased (
    id,
    x,
    y,
    dx,
    dy,
    pressure
)
    self:getCallback 'onTouchReleased' (self, id, x, y, dx, dy, pressure)
end

---@type ui.Common.OnUpdate
function Node:onUpdate (
    dt
)
    self:getCallback 'onUpdate' (self, dt)
end

---@type ui.Common.OnVisible
function Node:onVisible (
    visible
)
    self:getCallback 'onVisible' (self, visible)
end

---@type ui.Common.OnWheelMoved
function Node:onWheelMoved (
    x,
    y
)
    self:getCallback 'onWheelMoved' (self, x, y)
end

return Node