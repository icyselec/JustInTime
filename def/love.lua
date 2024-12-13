---@meta

-- version: 12.0
---
---[Open in Browser](https://love2d.org/wiki/love)
---
---@class love
love = {}

---
---Gets the current running version of LÖVE.
---
---
---[Open in Browser](https://love2d.org/wiki/love.getVersion)
---
---@return number major # The major version of LÖVE, i.e. 0 for version 0.9.1.
---@return number minor # The minor version of LÖVE, i.e. 9 for version 0.9.1.
---@return number revision # The revision version of LÖVE, i.e. 1 for version 0.9.1.
---@return string codename # The codename of the current version, i.e. 'Baby Inspector' for version 0.9.1.
function love.getVersion() end

---
---Gets whether LÖVE displays warnings when using deprecated functionality. It is disabled by default in fused mode, and enabled by default otherwise.
---
---When deprecation output is enabled, the first use of a formally deprecated LÖVE API will show a message at the bottom of the screen for a short time, and print the message to the console.
---
---
---[Open in Browser](https://love2d.org/wiki/love.hasDeprecationOutput)
---
---@return boolean enabled # Whether deprecation output is enabled.
function love.hasDeprecationOutput() end

---
---Gets whether the given version is compatible with the current running version of LÖVE.
---
---
---[Open in Browser](https://love2d.org/wiki/love.isVersionCompatible)
---
---@overload fun(major: number, minor: number, revision: number):boolean
---@param version string # The version to check (for example '11.3' or '0.10.2').
---@return boolean compatible # Whether the given version is compatible with the current running version of LÖVE.
function love.isVersionCompatible(version) end

---
---Sets whether LÖVE displays warnings when using deprecated functionality. It is disabled by default in fused mode, and enabled by default otherwise.
---
---When deprecation output is enabled, the first use of a formally deprecated LÖVE API will show a message at the bottom of the screen for a short time, and print the message to the console.
---
---
---[Open in Browser](https://love2d.org/wiki/love.setDeprecationOutput)
---
---@param enable boolean # Whether to enable or disable deprecation output.
function love.setDeprecationOutput(enable) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/love.markDeprecated)
---
---@param level number # 
---@param name string # 
---@param apiname love.APIType # 
---@param deprecationtname love.DeprecationType # 
---@param replacement? string # 
function love.markDeprecated(level, name, apiname, deprecationtname, replacement) end

---
---The superclass of all data.
---
---
---[Open in Browser](https://love2d.org/wiki/love)
---
---@class love.Data: love.Object
local Data = {}

---
---Creates a new copy of the Data object.
---
---
---[Open in Browser](https://love2d.org/wiki/Data:clone)
---
---@return love.Data clone # The new copy.
function Data:clone() end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getDouble)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getDouble(offset, count) end

---
---Gets an FFI pointer to the Data.
---
---This function should be preferred instead of Data:getPointer because the latter uses light userdata which can't store more all possible memory addresses on some new ARM64 architectures, when LuaJIT is used.
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getFFIPointer)
---
---@return ffi.cdata* pointer # A raw void* pointer to the Data, or nil if FFI is unavailable.
function Data:getFFIPointer() end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getFloat)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getFloat(offset, count) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getInt8)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getInt8(offset, count) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getInt16)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getInt16(offset, count) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getInt32)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getInt32(offset, count) end

---
---Gets a pointer to the Data. Can be used with libraries such as LuaJIT's FFI.
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getPointer)
---
---@return lightuserdata pointer # A raw pointer to the Data.
function Data:getPointer() end

---
---Gets the Data's size in bytes.
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getSize)
---
---@return number size # The size of the Data in bytes.
function Data:getSize() end

---
---Gets the full Data as a string.
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getString)
---
---@return string data # The raw data.
function Data:getString() end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getUInt8)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getUInt8(offset, count) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getUInt16)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getUInt16(offset, count) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/Data:getUInt32)
---
---@param offset number # 
---@param count? number # 
---@return number number1 # 
---@return number number2 # 
---@return number number3 # 
function Data:getUInt32(offset, count) end

---
---The superclass of all LÖVE types.
---
---
---[Open in Browser](https://love2d.org/wiki/love)
---
---@class love.Object
local Object = {}

---
---Destroys the object's Lua reference. The object will be completely deleted if it's not referenced by any other LÖVE object or thread.
---
---This method can be used to immediately clean up resources without waiting for Lua's garbage collector.
---
---
---[Open in Browser](https://love2d.org/wiki/Object:release)
---
---@return boolean success # True if the object was released by this call, false if it had been previously released.
function Object:release() end

---
---Gets the type of the object as a string.
---
---
---[Open in Browser](https://love2d.org/wiki/Object:type)
---
---@return string type # The type as a string.
function Object:type() end

---
---Checks whether an object is of a certain type. If the object has the type with the specified name in its hierarchy, this function will return true.
---
---
---[Open in Browser](https://love2d.org/wiki/Object:typeOf)
---
---@param name string # The name of the type to check for.
---@return boolean b # True if the object is of the specified type, false otherwise.
function Object:typeOf(name) end

---
---Called when the active audio device is disconnected (e.g. physically unplugging headphones).
---All audio are stopped and loses their playback position when this callback is called.
---
---
---[Open in Browser](https://love2d.org/wiki/love.audiodisconnected)
---
---@alias love.audiodisconnected fun(sources: table):boolean

---
---If a file called conf.lua is present in your game folder (or .love file), it is run before the LÖVE modules are loaded. You can use this file to overwrite the love.conf function, which is later called by the LÖVE 'boot' script. Using the love.conf function, you can set some configuration options, and change things like the default size of the window, which modules are loaded, and other stuff.
---
---
---[Open in Browser](https://love2d.org/wiki/love.conf)
---
---@alias love.conf fun(t: table)

---
---Callback function triggered when a directory is dragged and dropped onto the window.
---
---
---[Open in Browser](https://love2d.org/wiki/love.directorydropped)
---
---@alias love.directorydropped fun(path: string)

---
---Called when the device display orientation changed, for example, user rotated their phone 180 degrees.
---
---
---[Open in Browser](https://love2d.org/wiki/love.displayrotated)
---
---@alias love.displayrotated fun(index: number, orientation: love.DisplayOrientation)

---
---Callback function used to draw on the screen every frame.
---
---
---[Open in Browser](https://love2d.org/wiki/love.draw)
---
---@alias love.draw fun()

---
---The error handler, used to display error messages.
---
---
---[Open in Browser](https://love2d.org/wiki/love.errorhandler)
---
---@alias love.errorhandler fun(msg: string):function

---
---Callback function triggered when a file is dragged and dropped onto the window.
---
---
---[Open in Browser](https://love2d.org/wiki/love.filedropped)
---
---@alias love.filedropped fun(file: love.DroppedFile)

---
---Callback function triggered when window receives or loses focus.
---
---
---[Open in Browser](https://love2d.org/wiki/love.focus)
---
---@alias love.focus fun(focus: boolean)

---
---Called when a Joystick's virtual gamepad axis is moved.
---
---
---[Open in Browser](https://love2d.org/wiki/love.gamepadaxis)
---
---@alias love.gamepadaxis fun(joystick: love.Joystick, axis: love.GamepadAxis, value: number)

---
---Called when a Joystick's virtual gamepad button is pressed.
---
---
---[Open in Browser](https://love2d.org/wiki/love.gamepadpressed)
---
---@alias love.gamepadpressed fun(joystick: love.Joystick, button: love.GamepadButton)

---
---Called when a Joystick's virtual gamepad button is released.
---
---
---[Open in Browser](https://love2d.org/wiki/love.gamepadreleased)
---
---@alias love.gamepadreleased fun(joystick: love.Joystick, button: love.GamepadButton)

---
---Called when a Joystick is connected.
---
---
---[Open in Browser](https://love2d.org/wiki/love.joystickadded)
---
---@alias love.joystickadded fun(joystick: love.Joystick)

---
---Called when a joystick axis moves.
---
---
---[Open in Browser](https://love2d.org/wiki/love.joystickaxis)
---
---@alias love.joystickaxis fun(joystick: love.Joystick, axis: number, value: number)

---
---Called when a joystick hat direction changes.
---
---
---[Open in Browser](https://love2d.org/wiki/love.joystickhat)
---
---@alias love.joystickhat fun(joystick: love.Joystick, hat: number, direction: love.JoystickHat)

---
---Called when a joystick button is pressed.
---
---
---[Open in Browser](https://love2d.org/wiki/love.joystickpressed)
---
---@alias love.joystickpressed fun(joystick: love.Joystick, button: number)

---
---Called when a joystick button is released.
---
---
---[Open in Browser](https://love2d.org/wiki/love.joystickreleased)
---
---@alias love.joystickreleased fun(joystick: love.Joystick, button: number)

---
---Called when a Joystick is disconnected.
---
---
---[Open in Browser](https://love2d.org/wiki/love.joystickremoved)
---
---@alias love.joystickremoved fun(joystick: love.Joystick)

---
---Called when a Joystick's sensor is updated with new values.
---Only Joystick sensors enabled with Joystick:setSensorEnabled will trigger this event.
---
---
---[Open in Browser](https://love2d.org/wiki/love.joysticksensorupdated)
---
---@alias love.joysticksensorupdated fun(joystick: love.Joystick, sensorType: love.SensorType, x: number, y: number, z: number)

---
---Callback function triggered when a key is pressed.
---
---
---[Open in Browser](https://love2d.org/wiki/love.keypressed)
---
---@alias love.keypressed fun(key: love.KeyConstant, scancode: love.Scancode, isrepeat: boolean)|fun(key: love.KeyConstant, isrepeat: boolean)

---
---Callback function triggered when a keyboard key is released.
---
---
---[Open in Browser](https://love2d.org/wiki/love.keyreleased)
---
---@alias love.keyreleased fun(key: love.KeyConstant, scancode: love.Scancode)

---
---This function is called exactly once at the beginning of the game.
---
---
---[Open in Browser](https://love2d.org/wiki/love.load)
---
---@alias love.load fun(arg: table, unfilteredArg: table)

---
---Callback function triggered when the user's system locale preferences have changed.
---
---
---[Open in Browser](https://love2d.org/wiki/love.localechanged)
---
---@alias love.localechanged fun()

---
---Callback function triggered when the system is running out of memory on mobile devices.
---
---Mobile operating systems may forcefully kill the game if it uses too much memory, so any non-critical resource should be removed if possible (by setting all variables referencing the resources to '''nil'''), when this event is triggered. Sounds and images in particular tend to use the most memory.
---
---
---[Open in Browser](https://love2d.org/wiki/love.lowmemory)
---
---@alias love.lowmemory fun()

---
---Callback function triggered when window receives or loses mouse focus.
---
---
---[Open in Browser](https://love2d.org/wiki/love.mousefocus)
---
---@alias love.mousefocus fun(focus: boolean)

---
---Callback function triggered when the mouse is moved.
---
---
---[Open in Browser](https://love2d.org/wiki/love.mousemoved)
---
---@alias love.mousemoved fun(x: number, y: number, dx: number, dy: number, istouch: boolean)

---
---Callback function triggered when a mouse button is pressed.
---
---
---[Open in Browser](https://love2d.org/wiki/love.mousepressed)
---
---@alias love.mousepressed fun(x: number, y: number, button: number, istouch: boolean, presses: number)

---
---Callback function triggered when a mouse button is released.
---
---
---[Open in Browser](https://love2d.org/wiki/love.mousereleased)
---
---@alias love.mousereleased fun(x: number, y: number, button: number, istouch: boolean, presses: number)

---
---Callback function triggered when the game is closed.
---
---
---[Open in Browser](https://love2d.org/wiki/love.quit)
---
---@alias love.quit fun():boolean

---
---Called when the window is resized, for example if the user resizes the window, or if love.window.setMode is called with an unsupported width or height in fullscreen and the window chooses the closest appropriate size.
---
---
---[Open in Browser](https://love2d.org/wiki/love.resize)
---
---@alias love.resize fun(w: number, h: number)

---
---The main function, containing the main loop. A sensible default is used when left out.
---
---
---[Open in Browser](https://love2d.org/wiki/love.run)
---
---@alias love.run fun():function

---
---Called when the in-device sensor is updated with new values.
---Only sensors enabled with love.sensor.setEnabled will trigger this event.
---
---
---[Open in Browser](https://love2d.org/wiki/love.sensorupdated)
---
---@alias love.sensorupdated fun(sensorType: love.SensorType, x: number, y: number, z: number)

---
---Called when the candidate text for an IME (Input Method Editor) has changed.
---
---The candidate text is not the final text that the user will eventually choose. Use love.textinput for that.
---
---
---[Open in Browser](https://love2d.org/wiki/love.textedited)
---
---@alias love.textedited fun(text: string, start: number, length: number)

---
---Called when text has been entered by the user. For example if shift-2 is pressed on an American keyboard layout, the text '@' will be generated.
---
---
---[Open in Browser](https://love2d.org/wiki/love.textinput)
---
---@alias love.textinput fun(text: string)

---
---Callback function triggered when a Thread encounters an error.
---
---
---[Open in Browser](https://love2d.org/wiki/love.threaderror)
---
---@alias love.threaderror fun(thread: love.Thread, errorstr: string)

---
---Callback function triggered when a touch press moves inside the touch screen.
---
---
---[Open in Browser](https://love2d.org/wiki/love.touchmoved)
---
---@alias love.touchmoved fun(id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number)

---
---Callback function triggered when the touch screen is touched.
---
---
---[Open in Browser](https://love2d.org/wiki/love.touchpressed)
---
---@alias love.touchpressed fun(id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number)

---
---Callback function triggered when the touch screen stops being touched.
---
---
---[Open in Browser](https://love2d.org/wiki/love.touchreleased)
---
---@alias love.touchreleased fun(id: lightuserdata, x: number, y: number, dx: number, dy: number, pressure: number)

---
---Callback function used to update the state of the game every frame.
---
---
---[Open in Browser](https://love2d.org/wiki/love.update)
---
---@alias love.update fun(dt: number)

---
---Callback function triggered when window is minimized/hidden or unminimized by the user.
---
---
---[Open in Browser](https://love2d.org/wiki/love.visible)
---
---@alias love.visible fun(visible: boolean)

---
---Callback function triggered when the mouse wheel is moved.
---
---
---[Open in Browser](https://love2d.org/wiki/love.wheelmoved)
---
---@alias love.wheelmoved fun(x: number, y: number, px: number, py: number, dir: string)

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/APIType)
---
---@alias love.APIType
---
---
---
---| "function"
---
---
---
---| "functionvariant"
---
---
---
---| "method"
---
---
---
---| "methodvariant"
---
---
---
---| "callback"
---
---
---
---| "field"
---
---
---
---| "constant"
---
---
---
---| "custom"

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/DeprecationType)
---
---@alias love.DeprecationType
---
---
---
---| "noreplacement"
---
---
---
---| "replaced"
---
---
---
---| "renamed"

return love
