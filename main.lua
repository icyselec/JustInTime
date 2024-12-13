local Vector = require 'yj.comp.Vector'

local Unit = require 'yj.Unit'
local player


function love.load ()
	player = Unit.new()
	player.position.x = 400
	player.position.y = 300
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

	player.position.x = player.position.x + x*100*dt
	player.position.y = player.position.y + y*100*dt
end

function love.draw ()
	love.graphics.print("Hello World!", 400, 300)

	love.graphics.circle('fill', player.position.x, player.position.y, 10)
end