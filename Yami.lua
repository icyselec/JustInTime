--- (NOT) Smart Component class system helper.
--- Copyright (C) 2024  icyselec
---
--- This library is free software; you can redistribute it and/or
--- modify it under the terms of the GNU Lesser General Public
--- License as published by the Free Software Foundation; either
--- version 2.1 of the License, or (at your option) any later version.
---
--- This library is distributed in the hope that it will be useful,
--- but WITHOUT ANY WARRANTY; without even the implied warranty of
--- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--- Lesser General Public License for more details.
---
--- You should have received a copy of the GNU Lesser General Public
--- License along with this library; if not, write to the Free Software
--- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

local function setbase (o) return rawset(o, '__index', o) end

---@param t table
---@param m table
local function mix (t, m)
	assert(type(t) == 'table', 'table expected')

	for k, v in pairs(t) do
--		if k ~= 'new' and k ~= '__index' and m[k] then
--			error('conflict field: ' .. k)
--		end

		if type(v) == 'function' and k ~= 'new' and k ~= '__index' then
			m[k] = v
		end
	end

	return m
end

--[[
# Yami 사용 매뉴얼

## Yami는 무엇인가?
Yami 이전에는 Yaoi가 있었고 오래전부터 개량해온 것이라 매우 비효율적인 구조와 코드를 가지고 있었다.

Yaoi는 애초에 게임 개발용으로 설계되지 않았다. 원래 목적은 silo-project에서 내부적으로 사용할 목적으로 설계되었지만 이후에 게임 개발에도 몇몇 사용했을 뿐이지, 그것이 게임 개발에 적합한 라이브러리라는 말은 아니다.

그래서 Yami는 Yaoi의 개선판이라고 볼 수 있다. 더욱 효율적이고 빠르게 작동하며, 게임 개발에 적합한 라이브러리를 만들기 위해 설계되었다. 표준 PUC-Lua에서 비교했을 때, 인스턴스 생성 성능으로 비교하자면 Yami가 무려 7배나 빠르다.

## Yami의 사용법
Yami는 두 개의 함수를 제공한다. `Yami.def`와 `Yami.base`이다.

### `Yami.def`
이 함수는 여러개의 모듈 이름을 받아서 하나의 모듈로 만들어 반환한다. Yaoi부터 전통적으로 모듈을 클래스로 취급하고 있기 때문에, 이 함수는 클래스를 만들 때 사용된다.

Yami라는 이름은 Yet Another Mixin Implementation의 약자라는 점에서 알 수 있듯이, 이 함수는 여러개의 클래스를 합성할 수 있다. 그러므로, Yami는 믹스인을 지원한다고 할 수 있다.

### `Yami.base`
타입을 받아서 인스턴스를 만드는 함수를 반환한다. 이 함수는 클래스의 생성자를 만들 때 사용한다.

## Yami의 사용 예제
그런 건 제공하지 않는다. Yaoi는 너무 사용법이 복잡해서 매뉴얼에 복잡한 소스코드를 함께 제공해야 했었지만, Yami는 그럴 필요가 없다고 생각한다.

정말로 필요하다면, 아래에 간단한 클래스를 만드는 예시를 제공하고 있다. 참고가 되길 바란다.
```lua
local Yami = require 'Yami'

---@class Fruit
---@field sweetness number
---@field sourness number
---@field bitterness number
---@field saltiness number
---@field umami number
local Fruit = Yami.def()
local base = Yami.base(Fruit)

function Fruit.new (sweetness, sourness, bitterness, saltiness, umami)
	return base {
		sweetness = sweetness or 0,
		sourness = sourness or 0,
		bitterness = bitterness or 0,
		saltiness = saltiness or 0,
		umami = umami or 0,
	}
end

return Fruit
```
이제, 다른 파일에서 이 클래스를 사용할 수 있다.
```lua
local Yami = require 'Yami'

---@class Apple: Fruit
local Apple = Yami.def 'Fruit'
local base = Yami.base(Apple)

function Apple.new ()
	return base {
		sweetness = 10,
		sourness = 5,
		bitterness = 0,
		saltiness = 0,
		umami = 0,
	}
end

return Apple
```
주의할 점으로, Yaoi와는 다르게 메서드나 필드의 구현 책임은 파생 클래스에 있다는 것이다. Yami는 파생 클래스가 항상 책임지고 구현되지 않은 메서드나 필드가 있는지 꼭 확인해야 한다.
또한, 믹스인은 함수 이외의 타입을 지원하지 않는다. 애초에 그럴 필요가 없기도 하고, 상속 받은 테이블이 변경되는 참사를 막기 위해서다.
마지막으로 다른 점은, Yaoi의 경우 생성자에 항상 자기 자신을 전달해야 했지만 이제는 그럴 필요가 없다는 것이다. Yami는 생성자에 자기 자신을 전달하지 않아도 된다. 그래서 생성자를 훨씬 더 간결하고 빠르게 할 수 있다.

--]]
---@class Yami # for documentation
local Yami = {
	---@param ... string
	---@return table
	def = function (...)
		local t = setbase {}

		for i, v in ipairs {...} do
			mix(require(v), t)
		end

		return t
	end,
	---@generic T: table
	---@param T T
	---@return fun(instance: table): T
	base = function (T)
		return function (instance)
			return setmetatable(instance, T)
		end
	end,
}

return Yami