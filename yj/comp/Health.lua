local Yami = require 'Yami'

---@class yj.comp.Health
---@field point number
---@field max number
local Health = Yami.def()
local base = Yami.base(Health)

---comment
---@param max number
---@param point? number
function Health.new (max, point)
    assert(type(max) == 'number', 'max must be a number')

    return base {
        max = max,
        point = point or max,
    }
end

function Health:heal (amount)
    self.point = math.min(self.point + amount, self.max)
end

function Health:deal (amount)
    self.point = math.max(self.point - amount, 0)
end

-- 여기서 질문, 만약 어떤 클래스에 Health 컴포넌트가 없을 때, heal 또는 deal 메서드를 호출하면 어떻게 되는가?
-- 이런 경우에는 에러가 발생한다. 이런 경우에는 Health 컴포넌트가 있는지 확인한 후에 호출해야 한다.
-- 그럼, 어떤 객체에 특정 컴포넌트가 있는지 확인하는 방법은 무엇인가?
-- 확인했다. 그런 메서드는 없다. 직접 구현해야 한다.
-- Yami는 Yaoi와 달리 상속 기반의 객체 지향 시스템이 아니다. 그래서 상속을 사용하는 것이 아니라 컴포넌트를 사용한다.
-- 당연히 Yami라는 자료형이 존재하지 않는다. 모든 클래스가 하나의 클래스를 상속받는 Yaoi와는 대조적인 부분이다.
-- 우리 프로젝트에서는 컴포넌트가 어떤 필드 이름으로 저장되는지 명확한 규칙은 없지만, 보통은 낙타 등 표기법을 사용하여 컴포넌트를 저장한다.
-- 그래서 컴포넌트가 있는지 확인하는 방법은 컴포넌트의 필드 이름을 확인하는 것이다. Health의 경우에는 health를 확인한다.
-- Yami는 Yaoi와 마찬가지로 타입 정보를 Lua의 값에 의존하지 않는다. 오직 유일한 방법은 LSP를 사용하는 것이다.
-- 아까 필드를 확인하는 좋은 방법을 떠올려냈는데 그냥 `o.health and o.health:heal(10)` 이렇게 하면 된다. 정말 깔끔하다.
-- 그게 뭔 소리냐? 아무튼 못 들은 것으로 한다.

return Health