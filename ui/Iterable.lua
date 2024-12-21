local Yami = require 'Yami'

---@class ui.Iterable
local Iterable = Yami.def()
local base = Yami.base(Iterable)

---@alias ui.Delegate fun(self: ui.Component, a: any, b: any, c: any, d: any, e: any, f: any, ...): ui.Component?

---@param propagator ui.Delegate
---@param a any
---@param b any
---@param c any
---@param d any
---@param e any
---@param f any
---@param ... any
function Iterable:foreach (
    propagator,
    a,
    b,
    c,
    d,
    e,
    f,
    ...
)
    for _, comp in ipairs(self) do
        propagator(comp, ...)
    end
end

--- OnQuit와 같이 조건을 만족하는 컴포넌트에 추가적인 처리가 필요할 때 사용함.
--- propagator는 매 반복마다 나온 컴포넌트에 적용할 함수를 의미함.
--- handler는 propagator가 반환한 값이 참 또는 참으로 취급되는 값일 경우, self를 대상으로 적용할 함수를 의미함.
--[[ 사용 예제
local error_count = 0

local function handler (self)
    print("We are not ready to quit yet!")
    error_count = error_count + 1
end

local function propagator (self)
    if self.notReady then
        return true
    end
end

---@type ui.Window
local self = ...

self:propagate(handler, propagator)

print("Error count: " .. error_count)
]]
---@param handler fun(self: self, ...): boolean
---@param propagator fun(self: ui.Component, ...): ...
---@param ... any
---@return boolean?
---@return any
function Iterable:propagate (
    handler,
    propagator,
    ...
)
    local value

    for _, comp in ipairs(self) do
        if comp then
            value = handler(self, propagator(comp, ...)) or value
        end
    end

    return value
end

---@param f ui.Delegate
---@param ... any
---@return ui.Component? comp
---@return integer? index
function Iterable:findFirst (
    f,
    ...
)
    for i, v in ipairs(self) do
        local buf = f(v, ...)
        if buf then
            return buf, i
        end
    end

    return nil
end

---@param f ui.Delegate
---@param ... any
---@return ui.Component? comp
---@return integer? index
function Iterable:findLast (
    f,
    ...
)
    local value, index

    local buf

    for i, v in ipairs(self) do
        buf = f(v, ...)
        value = buf or value
        if buf then
            index = i
        end
    end

    return value, index
end

--- 조건에 맞는 가장 마지막으로 발견된 컴포넌트를 반환함.
--- 사용 방법:
--- 이 함수는 재귀적으로 동작하는 것이 원칙임.
--- focusing 필드가 구현된 컴포넌트는 이 함수의 focusing 반환값을 이용하여 해당 값의 컴포넌트가 우선순위를 제일 높게 설정할 수 있음.
--- 우선순위를 구하는 방법은 자신이 ui.Container의 일종일 때, `self[#self]`을 이용하여 가장 높은 우선 순위를 가진 컴포넌트를 찾을 수 있음.
--- focusing은 ui.Window와 같이 컴포넌트의 우선순위가 다른 것이 의미가 있는 컨테이너 컴포넌트에서만 구현되어야 함.
--- focusing으로 우선순위를 변경하고 난 뒤에는 이 함수를 사용하는 모든 함수는 self를 반환해야 함.
---@param f ui.Delegate
---@param ... any
---@return ui.Component? grabbing 조건에 맞는 컴포넌트.
---@return ui.Component? focusing 조건에 맞는 컴포넌트가 발견된 최상위 컴포넌트.
function Iterable:grab (
    f,
    ...
)
    local grabbing, focusing

    for _, comp in ipairs(self) do
        local v = f(comp, ...)
        if v then
            grabbing = v
            focusing = comp
        end
    end

    return grabbing, focusing
end

return Iterable