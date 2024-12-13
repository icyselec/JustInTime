---@meta

---
---Provides functionality to access device sensors such as an accelerometer or gyroscope.
---
---
---[Open in Browser](https://love2d.org/wiki/love.sensor)
---
---@class love.sensor
love.sensor = {}

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/love.sensor.getData)
---
---@param sensorType love.SensorType # 
---@return number x # 
---@return number y # 
---@return number z # 
function love.sensor.getData(sensorType) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/love.sensor.getName)
---
---@param sensorType love.SensorType # 
---@return string name # 
function love.sensor.getName(sensorType) end

---
---Check if the specified sensor exists in the device.
---
---
---[Open in Browser](https://love2d.org/wiki/love.sensor.hasSensor)
---
---@param sensorType love.SensorType # Type of sensor to check.
---@return boolean available # Sensor availability status.
function love.sensor.hasSensor(sensorType) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/love.sensor.isEnabled)
---
---@param sensorType love.SensorType # 
---@return boolean enabled # 
function love.sensor.isEnabled(sensorType) end

---
---
---
---
---[Open in Browser](https://love2d.org/wiki/love.sensor.setEnabled)
---
---@param sensorType love.SensorType # 
function love.sensor.setEnabled(sensorType) end

---
---Kinds of sensors.
---
---
---[Open in Browser](https://love2d.org/wiki/SensorType)
---
---@alias love.SensorType
---
---Accelerometer sensor.
---
---| "accelerometer"
---
---Gyroscope sensor.
---
---| "gyroscope"
