local Yami = require 'Yami'


local yj = {}
local ui = {}

yj.comp = {}

yj.comp.Position = require 'yj.comp.Position'
yj.comp.Dimension = require 'yj.comp.Dimension'

ui.Component = require 'ui.Component'
ui.Window = require 'ui.Window'
ui.Panel = require 'ui.Panel'
ui.Label = require 'ui.Label'
ui.Button = require 'ui.Button'

ui.Theme = require 'ui.Theme'

local imageLoadSettings = {
    linear = true,
    mipmaps = true
}

local current
local main = ui.Window.new()








---@class game.Item: ui.Panel
local Item = Yami.def 'ui.Panel'

do
    local base = Yami.base(Item)

    ---@param pos? yj.comp.Position
    ---@param dim? yj.comp.Dimension
    function Item.new (pos, dim, name, description)
        return base {
            position = pos or yj.comp.Position.new(0, 0),
            dimension = dim or yj.comp.Dimension.new(50, 50),
            userData = {
                name = name or 'Item',
                description = description or 'An item',
                hoveredTime = 0,
                isGrabbed = false,
            },
            active = true,
            visible = true,
        }
    end
end

function Item:onGrab (grab)
    self.userData.isGrabbed = grab

    local behavior = self.onFocus

    if behavior then
        behavior(self, grab)
    end

    print('Grab', grab)
    return true
end

function Item:onDraw ()
    love.graphics.push('all')

    ui.Panel.onDraw(self)

    local font = love.graphics.getFont()
    local name = self.userData.name
    love.graphics.print(name, self.position.x - font:getWidth(name)/2, self.position.y - font:getHeight()/2)

    love.graphics.pop()
end

function Item:onMouseMoved (x, y, dx, dy, istouch)
    if self.userData.isGrabbed then
        self.position:move(dx, dy)
        return true
    end

    return false
end

local InventoryBehavior = ui.Panel.new()

---@class game.Inventory: ui.Panel
local Inventory = Yami.def 'ui.Panel'

do
    local base = Yami.base(Inventory)

    function Inventory.new (pos, dim)
        return base {
            position = pos or yj.comp.Position.new(0, 0),
            dimension = dim or yj.comp.Dimension.new(250, 250),
            metaComponent = InventoryBehavior,
            userData = {
                columns = 5,
                rows = 5,
                contents = {},
            },
            active = true,
            visible = true,
        }
    end
end

function Inventory:onGrabbingChanged (new)
    ui.Panel.onGrabbingChanged(self, new)
end

function Inventory:newItem (name, description)
    local item = self:addComponent(Item.new(nil, nil, name, description))
    return item
end

function Inventory:getGrid (x, y)
    local c, r = self.userData.columns, self.userData.rows

    local gridW, gridH = self.dimension.width / c, self.dimension.height / r
    local posX, posY = x % self.dimension.width, y % self.dimension.height
    return (math.floor(posX / gridW) - math.floor(c / 2)) * gridW, (math.floor(posY / gridH) - math.floor(r / 2)) * gridH
end

---@type ui.Common.OnMouseReleased
function Inventory:onMouseReleased (x, y, button, istouch)
    if self.grabbing then
        local gX, gY = self:getGrid(self.dimension.width/2 + x, self.dimension.height/2 + y)
        print(gX, gY)
        self.grabbing.position.x = gX
        self.grabbing.position.y = gY
    end

    ui.Panel.onMouseReleased (self, x, y, button, istouch)
end

local inv = main:addComponent(Inventory.new(yj.comp.Position.new(0, 0), yj.comp.Dimension.new(250, 250)))

for i = 1, 25 do
    local item = inv:newItem('Item ' .. i, 'An item')
end




return main