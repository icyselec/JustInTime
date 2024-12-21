-- ui.Common class and common events.

local Yami = require 'Yami'

---@alias ui.Common.OnAudioDisconnected fun(self: ui.Common, sources: table): boolean?, boolean -- Love2D 12.0 or later

---@alias ui.Common.OnDirectoryDropped fun(self: ui.Common, path: string): boolean?
---@alias ui.Common.OnDisplayRotated fun(self: ui.Common, index: number, orientation: love.DisplayOrientation): boolean?

---@alias ui.Common.OnDraw fun(self: ui.Common): boolean?
--- `love.errorhandler`가 호출될 때 이벤트가 발생하여야 한다.
---@alias ui.Common.OnErrorHandler fun(self: ui.Common, msg: string): boolean?
---@alias ui.Common.OnFileDropped fun(self: ui.Common, file: love.DroppedFile): boolean?

---@alias ui.Common.OnFocus fun(self: ui.Common, focus: boolean): boolean?
---@alias ui.Common.OnGamepadAxis fun(self: ui.Common, joystick: love.Joystick, axis: love.GamepadAxis, value: number): boolean?

---@alias ui.Common.OnGamepadPressed fun(self: ui.Common, joystick: love.Joystick, button: love.GamepadButton): boolean?
---@alias ui.Common.OnGamepadReleased fun(self: ui.Common, joystick: love.Joystick, button: love.GamepadButton): boolean?

---@alias ui.Common.OnJoystickAdded fun(self: ui.Common, joystick: love.Joystick): boolean?
---@alias ui.Common.OnJoystickAxis fun(self: ui.Common, joystick: love.Joystick, axis: number, value: number): boolean?
---@alias ui.Common.OnJoystickHat fun(self: ui.Common, joystick: love.Joystick, hat: number, direction: love.JoystickHat): boolean?

---@alias ui.Common.OnJoystickPressed fun(self: ui.Common, joystick: love.Joystick, button: number): boolean?
---@alias ui.Common.OnJoystickReleased fun(self: ui.Common, joystick: love.Joystick, button: number): boolean?
---@alias ui.Common.OnJoystickRemoved fun(self: ui.Common, joystick: love.Joystick): boolean?
---@alias ui.Common.OnJoystickSensorUpdated fun(self: ui.Common, joystick: love.Joystick, sensorType: love.SensorType, x: number, y: number, z: number): boolean? -- Love2D 12.0 or later

---@alias ui.Common.OnKeyPressed fun(self: ui.Common, key: love.KeyConstant, scancode: love.Scancode, isrepeat: boolean): boolean?
---@alias ui.Common.OnKeyReleased fun(self: ui.Common, key: love.KeyConstant, scancode: love.Scancode): boolean?

---@alias ui.Common.OnLocaleChanged fun(self: ui.Common): boolean?
---@alias ui.Common.OnLowMemory fun(self: ui.Common): boolean?

---@alias ui.Common.OnMouseFocus fun(self: ui.Common, focus: boolean): boolean?
---@alias ui.Common.OnMouseMoved fun(self: ui.Common, x: number, y: number, dx: number, dy: number, istouch: boolean): boolean?
---@alias ui.Common.OnMousePressed fun(self: ui.Common, x: number, y: number, button: number, istouch: boolean, presses: number): boolean?
---@alias ui.Common.OnMouseReleased fun(self: ui.Common, x: number, y: number, button: number, istouch: boolean): boolean?

---@alias ui.Common.OnQuit fun(self: ui.Common): boolean?, boolean
---@alias ui.Common.OnResize fun(self: ui.Common, w: number, h: number): boolean?

---@alias ui.Common.OnSensorUpdated fun(self: ui.Common, sensorType: love.SensorType, x: number, y: number, z: number): boolean?
---@alias ui.Common.OnTextEdited fun(self: ui.Common, text: string, start: number, length: number): boolean?

---@alias ui.Common.OnTextInput fun(this: ui.Common, text: string): boolean?

---@alias ui.Common.OnThreadError fun(self: ui.Common, thread: love.Thread, errorstr: string): boolean?

---@alias ui.Common.OnTouchMoved fun(self: ui.Common, id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number): boolean?
---@alias ui.Common.OnTouchPressed fun(self: ui.Common, id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number): boolean?
---@alias ui.Common.OnTouchReleased fun(self: ui.Common, id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number): boolean?

---@alias ui.Common.OnUpdate fun(self: ui.Common, dt: number): boolean?
---@alias ui.Common.OnVisible fun(self: ui.Common, visible: boolean): boolean?
---@alias ui.Common.OnWheelMoved fun(self: ui.Common, x: number, y: number): boolean?




--[[
# `ui.Common`

## Supported Events
모든 이벤트는 특별히 명시하지 않는 한, 반환값에 대해서는 신경쓰지 않습니다. 일반적으로는, 아무 값도 반환하지 말아야 합니다.

일부 이벤트는 반환값을 유용하게 사용할 수 있습니다. 이러한 이벤트에 대해서는 별도로 작성합니다.

언젠가부터(아직 릴리즈되지 않았으므로) 이벤트 핸들러는 반드시 첫번째 반환값으로 boolean을 반환해야 합니다. 이 값은 이벤트가 성공적으로 끝났는지 여부를 나타냅니다.
만약, 이 값이 true라면 더이상 이벤트를 진행하지 말아야 합니다. 하지만, 이 값이 false 또는 부정을 의미하는 값이라면 이벤트에 해당하는 대상이 없다는 의미이므로 일부 컴포넌트의 경우 자신에게 이벤트가 해당하는 것으로 해석할 수 있습니다.
예를 들어, onMousePressed와 같은 이벤트는 오버라이딩을 통해 자신에게 이벤트가 발생했을 때의 동작을 재설정할 수 있습니다. 이 경우, 먼저 상속 이벤트 핸들러를 호출하고, 그 반환값을 확인하여 자신을 향한 이벤트인지를 판단할 수 있습니다.


### AudioDisconnected
`fun(self: ui.Common, sources: table): boolean`  
Available since Love2D 12.0.

###  DirectoryDropped
`fun(self: ui.Common, path: string): boolean`

### DisplayRotated
`fun(self: ui.Common, index: number, orientation: love.DisplayOrientation): boolean`

### Draw
`fun(self: ui.Common): boolean`

### Error
`fun(self: ui.Common, msg: string): boolean`
오류가 발생하면 호출된다. 이 이벤트는 Love2D 런타임이 호출할 수도 있고, 어떤 컴포넌트가 호출할 수도 있다. 이 이벤트는 전파되어야 하는지 명시하지 않는다.

### ErrorHandler
`fun(self: ui.Common, msg: string): boolean`
이 이벤트는 deprecated 되었습니다. 대신, Error를 사용하십시오.

### FileDropped
`fun(self: ui.Common, file: love.DroppedFile): boolean`

### Focus
`fun(self: ui.Common, focus: boolean): boolean`
어떤 컴포넌트가 hidden 상태에 들어갈 때 또는 나갈 때 발생한다.


### GamepadAxis
`fun(self: ui.Common, joystick: love.Joystick, axis: love.GamepadAxis, value: number): boolean`

### GamepadPressed
`fun(self: ui.Common, joystick: love.Joystick, button: love.GamepadButton): boolean`

###  GamepadReleased
`fun(self: ui.Common, joystick: love.Joystick, button: love.GamepadButton): boolean`

### JoystickAdded
`fun(self: ui.Common, joystick: love.Joystick): boolean`

### JoystickAxis
`fun(self: ui.Common, joystick: love.Joystick, axis: number, value: number): boolean`

### JoystickHat
`fun(self: ui.Common, joystick: love.Joystick, hat: number, direction: love.JoystickHat): boolean`

### JoystickPressed
`fun(self: ui.Common, joystick: love.Joystick, button: number): boolean`

### JoystickReleased
`fun(self: ui.Common, joystick: love.Joystick, button: number): boolean`

###  JoystickRemoved
`fun(self: ui.Common, joystick: love.Joystick): boolean`

### JoystickSensorUpdated
`fun(self: ui.Common, joystick: love.Joystick, sensorType: love.SensorType, x: number, y: number, z: number): boolean`  
Love2D 12.0 or later

### KeyPressed
`fun(self: ui.Common, key: love.KeyConstant, scancode: love.Scancode, isrepeat: boolean): boolean`

이 함수는 단순한 래퍼 함수일 수도 있다. 그러나 내부를 보면 작동이 생각보다 복잡하다.

먼저, 이 함수는 현재 focus되고 있는 컴포넌트에 이벤트를 전달하지 않는다는 것이다. 대신, 스택 최상단에 위치한 컴포넌트에 이벤트를 전달한다.
스택의 최상단은 `self[#self]`로 얻어낼 수 있다. 그 말은, 가장 나중에 그려지는 컴포넌트가 스택의 최상단이고, 이 컴포넌트가 이벤트를 받을 수 있다.
사실, Love2D와 SDL의 동작을 모방했기 때문에 아주 비슷하게 작동하는 것 뿐이다.

스택의 최상단이 focusing이 아니거나, focusing이 hidden 상태라면 동작이 정의되어 있지 않다.

### KeyReleased
`fun(self: ui.Common, key: love.KeyConstant, scancode: love.Scancode): boolean`

### LocaleChanged
`fun(self: ui.Common): boolean`
전파: 가능  
오버라이딩: 가능  

이 이벤트는 언어가 변경되었을 때 발생한다. 이 이벤트는 전역적으로 발생하며, 모든 컴포넌트에 전파된다.


### LowMemory
`fun(self: ui.Common): boolean`  
전파: 불가능  
오버라이딩: 알 수 없음  

이 이벤트는 다른 몇가지의 이벤트를 추가로 발생시킬 수도 있다. 애플리케이션 수준(하위 컴포넌트)가 해당 이벤트를 스스로 호출하면 절대로 안된다. 이 경우, 동작은 정의되어 있지 않다.

### MouseFocus
`fun(self: ui.Common, focus: boolean): boolean`  
전파: 불가능, 대상 컴포넌트에 명시적으로 이벤트가 발생함.  
오버라이딩: 가능  

### MouseMoved
`fun(self: ui.Common, x: number, y: number, dx: number, dy: number, istouch: boolean): boolean`  
전파: 가능  
오버라이딩: 가능  

### MousePressed
`fun(self: ui.Common, x: number, y: number, button: number, istouch: boolean, presses: number): boolean`  
전파: 가능  
오버라이딩: 가능  

### MouseReleased
`fun(self: ui.Common, x: number, y: number, button: number, istouch: boolean): boolean`  
전파: 가능  
오버라이딩: 가능  

### Quit
`fun(self: ui.Common): boolean`  
전파: 불가능, 대상 컴포넌트에 명시적으로 이벤트가 발생함.  
오버라이딩: 가능  

### Resize
`fun(self: ui.Common, w: number, h: number): boolean`  
전파: 불가능, 대상 컴포넌트에 명시적으로 이벤트가 발생함.  
오버라이딩: 가능  

### SensorUpdated
`fun(self: ui.Common, sensorType: love.SensorType, x: number, y: number, z: number): boolean`  
전파: 가능  
오버라이딩: 가능  

### TextEdited
`fun(self: ui.Common, text: string, start: number, length: number): boolean`
전파: 가능
오버라이딩: 가능  

### TextInput
`fun(self: ui.Common, text: string): boolean`  
전파: 가능  
오버라이딩: 가능  

### ThreadError
`fun(self: ui.Common, thread: love.Thread, errorstr: string): boolean`  
전파: 알 수 없음  
오버라이딩: 알 수 없음  

### TouchMoved
`fun(self: ui.Common, id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number): boolean`

### TouchPressed
`fun(self: ui.Common, id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number): boolean`

### TouchReleased
`fun(self: ui.Common, id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number): boolean`

### Update
`fun(self: ui.Common, dt: number): boolean`  
전파: 가능  
오버라이딩: 가능  

### Visible
`fun(self: ui.Common, visible: boolean): boolean`

### WheelMoved
`fun(self: ui.Component, x: number, y: number): boolean`  
전파: 가능  
오버라이딩: 가능  

## Unsupported Events
### Load
우리 UI 프레임워크에서 `love.load`가 끝나기 전에 작동하는 것은 정의되지 않은 동작입니다.

### Run
`love.run` 콜백 함수는 게임을 부트스트래핑해야 하기 때문에, 사용할 수 없습니다.

메인 게임 루프 함수를 수정해서 별도의 이벤트를 정의한다면, Run 이벤트 또한 정의할 수 있습니다. 이는 디버깅 용도로 유용합니다.
]]
---@class ui.Common: ui.Common.Callback
local Common = Yami.def()

---@class ui.Common.Callback
---@field onAudioDisconnected? ui.Common.OnAudioDisconnected
---@field onDirectoryDropped? ui.Common.OnDirectoryDropped
---@field onDisplayRotated? ui.Common.OnDisplayRotated
---@field onDraw? ui.Common.OnDraw
---@field onErrorHandler? ui.Common.OnErrorHandler
---@field onFileDropped? ui.Common.OnFileDropped
---@field onFocus? ui.Common.OnFocus
---@field onGamepadAxis? ui.Common.OnGamepadAxis
---@field onGamepadPressed? ui.Common.OnGamepadPressed
---@field onGamepadReleased? ui.Common.OnGamepadReleased
---@field onJoystickAdded? ui.Common.OnJoystickAdded
---@field onJoystickAxis? ui.Common.OnJoystickAxis
---@field onJoystickHat? ui.Common.OnJoystickHat
---@field onJoystickPressed? ui.Common.OnJoystickPressed
---@field onJoystickReleased? ui.Common.OnJoystickReleased
---@field onJoystickRemoved? ui.Common.OnJoystickRemoved
---@field onJoystickSensorUpdated? ui.Common.OnJoystickSensorUpdated
---@field onKeyPressed? ui.Common.OnKeyPressed
---@field onKeyReleased? ui.Common.OnKeyReleased
---@field onLocaleChanged? ui.Common.OnLocaleChanged
---@field onLowMemory? ui.Common.OnLowMemory
---@field onMouseFocus? ui.Common.OnMouseFocus
---@field onMouseMoved? ui.Common.OnMouseMoved
---@field onMousePressed? ui.Common.OnMousePressed
---@field onMouseReleased? ui.Common.OnMouseReleased
---@field onQuit? ui.Common.OnQuit
---@field onResize? ui.Common.OnResize
---@field onSensorUpdated? ui.Common.OnSensorUpdated
---@field onTextEdited? ui.Common.OnTextEdited
---@field onTextInput? ui.Common.OnTextInput
---@field onThreadError? ui.Common.OnThreadError
---@field onTouchMoved? ui.Common.OnTouchMoved
---@field onTouchPressed? ui.Common.OnTouchPressed
---@field onTouchReleased? ui.Common.OnTouchReleased
---@field onUpdate? ui.Common.OnUpdate
---@field onVisible? ui.Common.OnVisible
---@field onWheelMoved? ui.Common.OnWheelMoved

-- 이벤트는 굉장히 추상적이다. 심지어 파생 객체에서 이벤트의 동작을 재정의할 수도 있다.
-- 하지만 그럼에도 지켜야 하는 규칙이 몇가지 있다. 첫번째로, 매개변수의 목록을 변경해서는 안된다.
-- 그리고 특정 이벤트를 예상치 못한 동작에 사용해서는 안된다. `onMouseMoved`라는 이벤트는 항상 마우스가 움직였을 때, 발생하고 그와 관련된 동작을 해야 한다.
-- 대부분의 이벤트는 Love의 이벤트와 대응하지만 몇가지는 대응하지 않다. 또, 고수준의 이벤트를 우리 프레임워크에서 몇가지를 정의하고 있다.

-- Pre가 중간에 있는 콜백 이름은 이벤트가 발생하기 전에 먼저 호출되는 콜백이다. 따라서 Pre 콜백을 이용하여 전역 Window의 단축키 등을 구현할 수 있다. Raw 콜백이라고도 부른다.
-- 모든 이벤트는 반드시 그 실행 대상이 필요하다. 예를 들어, MouseFocus 이벤트는 어떠한 컴포넌트라도 가리키지 않을 때만 최상위 윈도우에게 이벤트를 전달한다.
-- Pre나 Raw 이벤트는 그걸 무시하고 먼저 실행할 수 있다. 단, 여러 Window가 중첩된 상황에서는 먼저 이벤트가 실행되는 것을 항상 보장하지는 않는다. 왜냐하면 이벤트를 처음 잡는 컴포넌트는 항상 최상위 윈도우이기 때문이다.

-- 오버라이딩 이벤트의 이름을 Pre나 Raw로 정했었는데 이를 무시하고 새로운 규격을 제정함.
-- 어떤 이벤트 이름이든지 앞에 on 대신 do가 붙으면 이벤트의 발생 조건을 따지지 않고 무조건 실행한다.
-- 이게 좋은 이름 규칙인지는 잘 모르겠다. 하지만 글자 수가 엄청 늘어나지 않으면서 직관적으로 표기할 수 있음에 큰 의미가 있다.

-- on은 해당 이벤트가 자신에게 발생했을 때만 호출하라는 의미이다. 예전에는 이벤트가 발생하기만 해도 호출했었고, 자신이 이벤트 호출 대상에 포함되는지는 알아서 판단했다. 지금은 아니다.
-- do는 해당 이벤트가 자신에게 발생했든 아니든 무조건 호출하라는 의미이다. 자신에게 해당되는 이벤트인지는 알아서 판단하지만 보통은 키 입력 이벤트를 가로채어 전역 단축 키를 구현할 때 사용된다.

-- 오버라이딩 콜백은 다음과 같은 일들을 할 수 있다.
-- 1. 이벤트의 인자를 적절히 가공하여 새로운 인자들을 만들어낸다.
-- 이는 IME와 같은 기능을 구현하는데 유용할 수 있다.
-- 2. 특정 이벤트를 무시한다.
-- 이는 특정 상황에서만 이벤트를 무시하고 싶을 때 사용할 수 있다.
-- 하지만 다음과 같은 행동을 하면 안된다.
-- 1. 이벤트의 매개 변수의 순서를 뒤바꾸거나, 새로 추가하거나, 삭제한다.
-- 2. 이벤트의 동작을 예상치 못한 방향으로 바꾼다.

-- 오버라이딩을 사용하면 재미있는 일들을 할 수 있다. 다음은, 입력된 모든 알파벳을 대문자로 바꾸는 예제이다.
--[[
```lua
local function doTextInput (self, text)
    return text:upper()
end
```
]]

-- 그냥, 오버라이딩이 필요하면 이벤트 핸들러를 직접 재정의하는게 훨씬 더 좋을 것 같다...
-- 또는, 이전 이벤트 핸들러는 그대로 두고, 클로저를 이용해서 오버라이딩을 수행한 후에, 이전 이벤트 핸들러를 호출하게 만드는 방식도 좋을 것 같다.


return Common