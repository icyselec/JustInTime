local Vector = require 'yj.comp.Vector'

-- new namespace
local yj = {}

yj.Unit = require 'yj.Unit'
yj.TileSet = require 'yj.TileSet'

yj.comp = {}
yj.comp.Dimension = require 'yj.comp.Dimension'
yj.comp.Position = require 'yj.comp.Position'
yj.Player = require 'yj.Player'
yj.Health = require 'yj.comp.Health'

local ui = {}

ui.Window = require 'ui.Window'
ui.Panel = require 'ui.Panel'
ui.Label = require 'ui.Label'

---@type ui.Window
local main_window

local comps = {}
---@type ui.Panel[]
local panels = {}

local plr
local tileSet

local tilesetImage

local imageLoadSettings = {
	linear = true,
	mipmaps = true
}

local hover_pos = yj.comp.Position.new(0, 0)

function love.load ()
	plr = yj.Player.new(yj.comp.Position.new(400, 300), yj.Health.new(100))

	tilesetImage = love.graphics.newImage('assets/Forest Adventure/Tileset.png', imageLoadSettings)
	tileSet = yj.TileSet.new(
		nil,
		yj.comp.Dimension.new(16, 16),
		tilesetImage,
		nil,
		nil,
		yj.comp.Position.new(400, 300)
	)
	load_map(tileSet)

	main_window = ui.Window.new(yj.comp.Position.new(400, 300), yj.comp.Dimension.new(50, 50))
	comps[1] = ui.Panel.new(yj.comp.Position.new(-200, 0), yj.comp.Dimension.new(25, 25))

	panels[1] = ui.Panel.new(yj.comp.Position.new(0, -200), yj.comp.Dimension.new(100, 60))
	panels[2] = ui.Panel.new(yj.comp.Position.new(0, 0), yj.comp.Dimension.new(100, 60))
	panels[3] = ui.Panel.new(yj.comp.Position.new(0, 200), yj.comp.Dimension.new(100, 60))

	comps[1]:addComponent(panels[1])
	comps[1]:addComponent(panels[2])
	comps[1]:addComponent(panels[3])

	comps[2] = ui.Label.new('Hello, World!', love.graphics.newFont(12), yj.comp.Position.new(0, 0))
	panels[1]:addComponent(comps[2])

	panels[1].customData = {
		position = yj.comp.Position.new(0, 0),
		focus = false,
	}

	panels[1]:setHandler('onEnter', function (self, x, y)
		self.customData.position.x = x
		self.customData.position.y = y
		self.customData.focus = true
		return self
	end)
	panels[1]:setHandler('onLeave', function (self, _, _)
		self.customData.focus = false
		return nil
	end)
	panels[1]:setHandler('onDraw', function (self)
		if self.customData.focus then
			love.graphics.push('all')
			love.graphics.setColor(1, 0, 0)
			love.graphics.circle('line', self.customData.position.x, self.customData.position.y, 25)
			love.graphics.pop()
		end
	end)

	main_window:addComponent(comps[1])

--	love.graphics.setLineStyle('rough')
	love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
end

---@param tileSet yj.TileSet
function load_map (tileSet)
	tileSet:placeTile(0, 0, 8)
end

function love.update (dt)
	local x, y = 0, 0

	if love.keyboard.isDown('left') then
		x = -1
	elseif love.keyboard.isDown('right') then
		x = 1
	end

	if love.keyboard.isDown('up') then
		y = -1
	elseif love.keyboard.isDown('down') then
		y = 1
	end

	plr:move(x, y)
end

function love.mousemoved (x, y)
	main_window:onMouseMoved(x, y)
end

function love.draw ()

	love.graphics.circle('fill', plr.position.x, plr.position.y, 10)
	main_window:onDraw()
	tileSet:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(string.format('x: %d, y: %d', hover_pos.x, hover_pos.y), 0, 0)
	love.graphics.print(string.format('x: %d, y: %d (global)', love.mouse.getPosition()), 0, 12)
end