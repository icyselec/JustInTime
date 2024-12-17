local Vector = require 'yj.comp.Vector'

-- new namespace
local yj = {}


---@type ui.Window
local main_window

function love.load ()
	main_window = dofile 'game.lua'

	main_window:show()

	love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
end



function love.update (dt)
	main_window:onUpdate(dt)
end

function love.mousemoved (x, y)
	main_window:onMouseMoved(x, y)
end

function love.mousepressed (...)
	main_window:onMousePressed(...)
end

function love.mousereleased (x, y, button, istouch)
	main_window:onMouseReleased(x, y, button, istouch)
end

function love.keypressed (key, scancode, isrepeat)
	main_window:onKeyPressed(key, scancode, isrepeat)
end

function love.keyreleased (key, scancode)
	main_window:onKeyReleased(key, scancode)
end

function love.draw ()
	main_window:onDraw()
	love.graphics.print(string.format('x: %d, y: %d (global)', love.mouse.getPosition()), 0, 12)
end