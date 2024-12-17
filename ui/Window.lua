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

local BaseUI = require 'ui.BaseUI'

---@class ui.Window: ui.Component, ui.Container
---@field parent? ui.Window # if nil, it is a root window
---@field active boolean
---@field dimension yj.comp.Dimension
---@field mousePosition yj.comp.Position
---@field focused? ui.Component
local Window = Yami.def('ui.Component', 'ui.Container')
local base = Yami.base(Window)

--- Create a new root window.
---@param pos yj.comp.Position
---@param dim yj.comp.Dimension
---@return ui.Window
function Window.new (pos, dim)
    assert(pos, 'Position is required')

    return base {
        position = pos,
        dimension = dim or Dimension.new(32, 32),
        mousePosition = Position.new(love.mouse.getPosition()),
    }
end

function Window:isParent ()
    return self.parent == nil
end

--- Create a new window and add it to the window list.
---@param pos any
---@param dim any
---@return ui.Window
function Window:newWindow (pos, dim)
    local window = Window.new(pos, dim)
    self:addComponent(window)
    return window
end

function Window:reorder (comp)
    table.sort(self, function (a, b)
        return a == comp
    end)
end

local function draw_children (self)
    if self.onDraw and self.visible then
        self:onDraw()
    end
end

---@param parent { position: yj.comp.Position }
function Window:onDraw (
    parent
)
    love.graphics.push('all')
    love.graphics.translate(self.position.x, self.position.y)
    self:foreach(false, draw_children)
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
    x, y = x - self.position.x, y - self.position.y

    if self.focused then
        ---@cast self {focused: ui.Contactable}
        if not self.focused:onLeave(x, y) then
            return
        end
    end

    self.focus = self:foreach(true, function (comp)
        return propagateEnterEvent(comp, x, y)
    end)
end

function Window:show ()
    self.visible = true
end


return Window