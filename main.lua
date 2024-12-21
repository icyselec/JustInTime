local Vector = require 'yj.comp.Vector'

-- new namespace
local yj = {}


---@type ui.Window
local main_window

function love.load ()
	main_window = dofile 'test.lua'


	love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
end

local count = 0

function love.update (dt)
	local behavior = main_window.onUpdate

	if behavior then
		behavior(main_window, dt)
	end

	count = count + 1
	if count == 75 then
		collectgarbage()
		count = 0
	end
end

function love.mousemoved (x, y, dx, dy, istouch)
	local behavior = main_window.onMouseMoved

	if behavior then
		behavior(main_window, x, y, dx, dy, istouch)
	end
end

function love.mousepressed (x, y, button, istouch, presses)
	local behavior = main_window.onMousePressed

	if behavior then
		behavior(main_window, x, y, button, istouch, presses)
	end
end

function love.mousereleased (x, y, button, istouch)
	local behavior = main_window.onMouseReleased

	if behavior then
		behavior(main_window, x, y, button, istouch)
	end
end

function love.keypressed (key, scancode, isrepeat)
	local behavior = main_window.onKeyPressed

	if behavior then
		behavior(main_window, key, scancode, isrepeat)
	end
end

function love.keyreleased (key, scancode)
	local behavior = main_window.onKeyReleased

	if behavior then
		behavior(main_window, key, scancode)
	end
end

function love.wheelmoved (x, y)
	local behavior = main_window.onWheelMoved

	if behavior then
		behavior(main_window, x, y)
	end
end

function love.mousefocus (focus)
	local behavior = main_window.onMouseFocus

	if behavior then
		behavior(main_window, focus)
	end
end

function love.textinput (text)
	local behavior = main_window.onTextInput

	if behavior then
		behavior(main_window, text)
	end
end

function love.draw ()
	local behavior = main_window.onDraw

	if behavior then
		behavior(main_window)
	end

	love.graphics.print(string.format('x: %d, y: %d (global)', love.mouse.getPosition()), 0, 12)
	love.graphics.print(string.format('FPS: %d', love.timer.getFPS()), 0, 24)
	love.graphics.print(string.format('GC: %d KB', collectgarbage('count')), 0, 36)
end

function love.focus (focus)
	local behavior = main_window.onFocus

	if behavior then
		behavior(main_window, focus)
	end
end


--- Start of error handling code




--[[
function love.errorhandler(msg)
	local behavior = main_window.onError

	if behavior then
		behavior(main_window, msg)
	end

	local utf8 = require("utf8")

	local function error_printer(msg, layer)
		print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
	end

	msg = tostring(msg)

	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end

	love.graphics.reset()
	local font = love.graphics.newFont(14)

	love.graphics.setColor(1, 1, 1)

	local trace = debug.traceback()

	love.graphics.origin()

	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)

	local err = {}

	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)

	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end

	table.insert(err, "\n")

	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")

	local function draw()
		if not love.graphics.isActive() then return end
		local pos = 70
		love.graphics.clear(89/255, 157/255, 220/255)
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end

	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
	end

	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end

	local dt = 0

	local errorhandler = {}

	function errorhandler.update (dt)

	end

	function errorhandler.draw ()
		draw()
	end

	return function ()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end


		errorhandler.update(dt)

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			errorhandler.draw()

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end

end
]]