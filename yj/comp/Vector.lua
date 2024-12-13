local Yaoi = require 'Yaoi'
local Yami = require 'Yami'

---@class yj.comp.Vector
---@field dim number
local Vector = {}

function Vector:init ()
	for i = 1, self.dim do
		self[i] = 0
	end
end

---@param buf table
function Vector:toNormalize (buf)
	local mag = self:getMagnitude()

	if mag == 0 then
		for i = 1, self.dim do
			buf[i] = 0
		end
	else
		for i = 1, self.dim do
			buf[i] = self[i]/mag
		end
	end

	return buf
end

function Vector:getMagnitude ()
	local mag = 0

	for i = 1, self.dim do
		mag = mag + self[i]^2
	end

	return math.sqrt(mag)
end

function Vector:getAdd (that, buf)
	for i = 1, self.dim do
		buf[i] = self[i] + that[i]
	end

	return buf
end

function Vector:getSub (that, buf)
	for i = 1, self.dim do
		buf[i] = self[i] - that[i]
	end

	return buf
end

function Vector:getScalarMul (val, buf)
	for i = 1, self.dim do
		buf[i] = self[i] * val
	end

	return buf
end

function Vector:getScalarProduct (that)
	local sum = 0

	for i = 1, self.dim do
		sum = sum + self[i]*that[i]
	end

	return sum
end

function Vector:getVectorProduct (that, buf)
	assert(self.dim == 3, "Vector Product(Cross Product) only defined in 3 dimensional euclidean space.")

	for i = 1, self.dim do
		local j, k = (i)%self.dim + 1, (i+1)%self.dim + 1
--		buf[#buf + 1] = self[j]*that[k] - self[k]*that[j] -- What are you doing?
		buf[i] = self[j]*that[k] - self[k]*that[j]
	end

	return buf
end

return Vector
