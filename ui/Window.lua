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

--- 이름과는 다르게, 실제로 Window의 전역 상태가 아니다.
--- Lua에서 global_State가 있는 것처럼, Window에서도 어떤 그룹에 속한 Window 간에 공유되는 전역 상태가 있다.
--- 이번 게임잼을 위해 특수하게 설계된 Yami 라이브러리 또한 Lua 철학을 엄격하게 따르므로, 모든 모듈은 반드시 불변 상태를 가져야 한다.
---@class ui.Window.GlobalState
---@field font love.Font
---@field renderer ui.Renderer
local GlobalState = Yami.def()

---@param renderer? ui.Renderer
function GlobalState.new (
    renderer
)
    return {
        renderer = renderer or Renderer.new(),
    }
end

-- 짧은 Lua 최적화 테크닉.
-- 함수는 사실 클로저이다.
-- 클로저를 대량 생성하면 성능이 저하될 수 있다.
-- 미리 생성해놓고 나중에 필요할 때 호출하는 것이 최적의 성능을 낸다.
-- 또한, 너무 무분별한 업밸류 사용을 자제하는 것이 좋다.
-- 그거 편리해보이지만, 다 비용이 든다.


---@class ui.Window: ui.Component, ui.Container, ui.Iterable
---@field G ui.Window.GlobalState
---@field active boolean
---@field dimension yj.comp.Dimension
---@field mousePosition yj.comp.Position
---@field focused? ui.Component
---@field renderer ui.Renderer
---@field grabbing? ui.Component
local Window = Yami.def('ui.Component', 'ui.Container', 'ui.Iterable')
local base = Yami.base(Window)

--- Create a new root window.
---@param pos yj.comp.Position
---@param dim yj.comp.Dimension
---@param renderer? ui.Renderer
---@return ui.Window
function Window.new (
    pos,
    dim,
    renderer
)
    assert(pos, 'Position is required')

    local G = GlobalState.new()

    return base {
        G = G,
        position = pos,
        dimension = dim or Dimension.new(32, 32),
        mousePosition = Position.new(love.mouse.getPosition()),
    }
end

--- Create a new window and add it to the window list.
---@param pos number
---@param dim number
---@param renderer? ui.Renderer
---@return ui.Window
function Window:newWindow (
    pos,
    dim,
    renderer
)
    assert(pos, 'Position is required')

    return base {
        G = self.G,
        position = pos,
        dimension = dim or Dimension.new(32, 32),
        mousePosition = Position.new(love.mouse.getPosition()),
        renderer = renderer,
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
    love.graphics.push('all')
    love.graphics.translate(self.position.x, self.position.y)
    self:foreach(draw_children, renderer or self.renderer or self.G.renderer)
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
function Window:onMouseMoved (x, y)
    x, y = self.position:toLocal(x, y)

    if self.focused then
        ---@cast self {focused: ui.Contactable}
            self.focused:onLeave(x, y)
    end

    self.focused = self:find(function (comp)
        return propagateEnterEvent(comp, x, y)
    end)
end

local function propagatePressedEvent (self, x, y, button, istouch, presses)
    return self.onMousePressed and self:onMousePressed(x, y, button, istouch, presses)
end

function Window:onMousePressed (x, y, button, istouch, presses)
    x, y = self.position:toLocal(x, y)

    self.grabbing = self:findLast(propagatePressedEvent, x, y, button, istouch, presses)
    print(self.grabbing)
end

function Window:onMouseReleased (x, y, button, istouch)
    x, y = self.position:toLocal(x, y)

    if self.grabbing then
        if self.grabbing.onMouseReleased then
            self.grabbing:onMouseReleased(x, y, button, istouch)
        end
    end
end

function Window:show ()
    self.visible = true
end


return Window