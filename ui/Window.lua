-- ui.Window
-- Window는 모든 UI 컴포넌트를 제어하는 최상위 컴포넌트이다.
-- 컴포넌트에는 Window도 포함되므로, Window 안에 Window가 있을 수 있다.
-- Window는 UI 컴포넌트를 관리하고, 이벤트를 처리한다.
-- Window는 UI 컴포넌트를 그리는 역할도 한다.
-- Window는 UI 컴포넌트를 업데이트하는 역할도 한다.
-- 아무튼 많은 역할을 담당하지만 Window는 ui.Component의 일종이라는 것을 기억해야 한다.

local Yami = require 'Yami'

local Position = require 'yj.comp.Position'
local Dimension = require 'yj.comp.Dimension'

local Renderer = require 'ui.Renderer'

-- 짧은 Lua 최적화 테크닉.
-- 함수는 사실 클로저이다.
-- 클로저를 대량 생성하면 성능이 저하될 수 있다.
-- 미리 생성해놓고 나중에 필요할 때 호출하는 것이 최적의 성능을 낸다.
-- 또한, 너무 무분별한 업밸류 사용을 자제하는 것이 좋다.
-- 그거 편리해보이지만, 다 비용이 든다.

---@alias ui.Window.OnFocus fun(self: ui.Component, focus: boolean): ui.Component?
---@alias ui.Window.OnQuit fun(self: ui.Component): ui.Component?

---@class ui.Window.Event: ui.Component.Event, ui.Drawable.Event
---@field onDraw ui.Drawable.OnDraw

---@class ui.Window.Callback: ui.Component.Callback
---@field Draw ui.Drawable.OnDraw



---@class ui.Window: ui.Component, ui.Container, ui.Iterable, ui.Window.Event
---@field activated boolean
---@field mousePosition yj.comp.Position
---@field focusing? ui.Component
---@field renderer ui.Renderer
---@field grabbing? ui.Component
---@field callback ui.Window.Callback
---@field visible boolean
local Window = Yami.def('ui.Component', 'ui.Container', 'ui.Iterable')
local base = Yami.base(Window)

--- Create a new root window.
---@param pos yj.comp.Position
---@param renderer? ui.Renderer
---@return ui.Window
function Window.new (
    pos,
    renderer
)
    assert(pos, 'Position is required')

    return base {
        position = pos,
        mousePosition = Position.new(love.mouse.getPosition()),
        visible = false,
    }
end

function Window:reorder (comp)
    table.sort(self, function (a, b)
        return a == comp
    end)
end

---@param self ui.Drawable
---@param renderer ui.Renderer
local function draw_children (self, renderer)
    if self.onDraw and self.activated then
        self:onDraw(renderer)
    end
end

---@param renderer? ui.Renderer
function Window:onDraw (
    renderer
)
    if not self.visible then return end

    love.graphics.push('all')
    love.graphics.translate(self.position.x, self.position.y)
    self:invokeCallback('Draw', renderer or self.renderer)
    self:foreach(draw_children, renderer or self.renderer)
    self:invokeCallback('Overlay', renderer or self.renderer)
    love.graphics.pop()
end

---@param dt number
function Window:update (dt) end

local function propagateEnterEvent (self, x, y)
    return self.onEnter and self:onEnter(x, y)
end

--- Entry point of the mouse event.
---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function Window:onMouseMoved (
    x,
    y,
    dx,
    dy,
    istouch
)
    if not self.visible then return end

    x, y = self.position:toLocal(x, y)

    if self.grabbing then
        ---@cast self {grabbing: ui.Contactable}
        self.grabbing:onGrab(dx, dy)
    end

    if self.focusing then
        ---@cast self {focusing: ui.Contactable}
        self.focusing:onLeave(x, y)
    end

    ---@cast self ui.Window
    self.focusing = self:find(function (comp)
        return propagateEnterEvent(comp, x, y)
    end)
end

local function propagatePressedEvent (self, x, y, button, istouch, presses)
    return self.onMousePressed and self:onMousePressed(x, y, button, istouch, presses)
end

function Window:onMousePressed (x, y, button, istouch, presses)
    if not self.visible then return end

    x, y = self.position:toLocal(x, y)

    self:invokeCallback('MousePressed', x, y, button, istouch, presses)
    self.grabbing = self:findLast(propagatePressedEvent, x, y, button, istouch, presses)
    self.focusing = self.grabbing
end

function Window:onMouseReleased (x, y, button, istouch)
    if not self.visible then return end

    x, y = self.position:toLocal(x, y)

    if self.grabbing then
        if self.grabbing.onMouseReleased then
            self.grabbing:onMouseReleased(x, y, button, istouch)
        end

        self.grabbing = nil
    end
end

function Window:show ()
    self.visible = true
end

function Window:hide ()
    self.visible = false
end

local function propagateUpdateEvent (self, dt)
    return self.onUpdate and self:onUpdate(dt)
end

---@param dt number
function Window:onUpdate (dt)
    self:invokeCallback('Update', dt)
    self:foreach(propagateUpdateEvent, dt)
end

---@param key love.KeyConstant
---@param scancode love.Scancode
---@param isrepeat boolean
function Window:onKeyPressed (key, scancode, isrepeat)
    if not self.visible then return end

    self:invokeCallback('KeyPressed', key, scancode, isrepeat)

    if self.focusing then
        if self.focusing.onKeyPressed then
            self.focusing:onKeyPressed(key, scancode, isrepeat)
        end
    end
end

---@param key love.KeyConstant
---@param scancode love.Scancode
function Window:onKeyReleased (key, scancode)
    if not self.visible then return end

    self:invokeCallback('KeyPressed', key, scancode)

    if self.focusing then
        if self.focusing.onKeyReleased then
            self.focusing:onKeyReleased(key, scancode)
        end
    end
end

return Window