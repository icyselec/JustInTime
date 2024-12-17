-- Just In Time main game file.

local yj = {}
local ui = {}

yj.comp = {}

yj.comp.Position = require 'yj.comp.Position'
yj.comp.Dimension = require 'yj.comp.Dimension'

ui.Window = require 'ui.Window'
ui.Panel = require 'ui.Panel'
ui.Label = require 'ui.Label'
ui.Button = require 'ui.Button'

ui.Theme = require 'ui.Theme'

local imageLoadSettings = {
    linear = true,
    mipmaps = true
}
local main = ui.Window.new(yj.comp.Position.new(400, 300))

local current_comp

local theme = ui.Theme.new()
theme:setPanelImage(love.graphics.newImage('assets/1057537.png', imageLoadSettings))
main.renderer = theme


local Grabbable = {}
function Grabbable:Grab (dx, dy) ---@cast self ui.Component
    self.position.x = self.position.x + dx
    self.position.y = self.position.y + dy
end


current_comp = main:addComponent(ui.Panel.new(yj.comp.Position.new(0, 0), yj.comp.Dimension.new(100, 100)))
current_comp.userData = {
    position = yj.comp.Position.new(0, 0),
    focused = false,
}
current_comp:setCallback('Enter', function (self, x, y)
    self.userData.position.x, self.userData.position.y = x, y
    self.userData.focused = true
end)
current_comp:setCallback('Leave', function (self, x, y)
    self.userData.focused = false
end)
current_comp:setCallback('Draw', function (self, renderer) ---@cast renderer ui.Renderer
    if self.userData.focused then
        love.graphics.print('Focused', self.userData.position.x, self.userData.position.y)
    end
end)
current_comp:setCallback('Grab', function (self, x, y)
    self.position.x, self.position.y = self.position.x + x, self.position.y + y
end)

current_comp = main:addComponent(ui.Panel.new(yj.comp.Position.new(0, -50), yj.comp.Dimension.new(200, 60)))
current_comp.userData = {
    focused = false,
    text = 'default',
}
current_comp:setCallback('MousePressed', function (self, x, y, button, istouch, presses)
    self.userData.focused = true
    love.keyboard.setTextInput(true)
end)
current_comp:setCallback('Leave', function (self, x, y)
    self.userData.focused = false
    love.keyboard.setTextInput(false)
end)

current_comp:setCallback('Draw', function (self, renderer) ---@cast renderer ui.Renderer
    love.graphics.print(self.userData.text, self.position.x, self.position.y)
end)

current_comp:setCallback('KeyPressed', function (self, key)
    if not self.userData.focused then
        return
    end

    if key == 'backspace' then
        self.userData.text = self.userData.text:sub(1, -2)
    else
        self.userData.text = self.userData.text .. key
    end

    return self
end)

main:setCallback('KeyPressed', function (self, key)
    if key == 'escape' then
        love.event.quit()
    end
end)

current_comp = main:addComponent(ui.Button.new('Button', yj.comp.Position.new(0, 50), yj.comp.Dimension.new(100, 50)))
local particleSystem = love.graphics.newParticleSystem(theme.panelImage, 100)
particleSystem:stop()

current_comp.userData = {
    particleSystem = particleSystem
}

current_comp:setCallback('Click', function (self, x, y, button, istouch, presses)
    if button ~= 1 then return end
    if self.userData.particleSystem:isActive() then
        self.userData.particleSystem:stop()
        return
    end

    self.userData.particleSystem:setPosition(x, y)
    particleSystem:setParticleLifetime(0.5, 1)
    particleSystem:setEmissionRate(5)
    particleSystem:setSizes(1/128)
    particleSystem:setEmissionArea('uniform', 100, 100)
    self.userData.particleSystem:start()
end)
current_comp:setCallback('Draw', function (self, renderer) ---@cast renderer ui.Renderer
    love.graphics.draw(self.userData.particleSystem)
end)
current_comp:setCallback('Update', function (self, dt)
    self.userData.particleSystem:update(dt)
end)

local circle_x, circle_y = 0, 0

main:setCallback('Update', function (self, dt)
    local x, y = 0, 0

    if love.keyboard.isDown('left') then
        x = x - 1
    elseif love.keyboard.isDown('right') then
        x = x + 1
    end

    if love.keyboard.isDown('up') then
        y = y - 1
    elseif love.keyboard.isDown('down') then
        y = y + 1
    end

    circle_x = circle_x + x * 100 * dt
    circle_y = circle_y + y * 100 * dt
end)

main:setCallback('Overlay', function (self, renderer) ---@cast renderer ui.Renderer
    love.graphics.circle('fill', circle_x, circle_y, 10)
end)

current_comp = main:addComponent(ui.Panel.new(yj.comp.Position.new(0, 0), yj.comp.Dimension.new(100, 100)))
current_comp:setBaseCallback(Grabbable)


return main