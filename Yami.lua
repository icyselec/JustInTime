--- (NOT) Smart Component class system helper.
--- Copyright (C) 2024  icyselec
---
--- This library is free software; you can redistribute it and/or
--- modify it under the terms of the GNU Lesser General Public
--- License as published by the Free Software Foundation; either
--- version 2.1 of the License, or (at your option) any later version.
---
--- This library is distributed in the hope that it will be useful,
--- but WITHOUT ANY WARRANTY; without even the implied warranty of
--- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--- Lesser General Public License for more details.
---
--- You should have received a copy of the GNU Lesser General Public
--- License along with this library; if not, write to the Free Software
--- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

local function setbase (o) return rawset(o, '__index', o) end

---@param t table
---@param m table
local function mix (t, m)
	assert(type(t) == 'table', 'table expected')

	for k, v in pairs(t) do
		if k ~= 'new' and k ~= '__index' and m[k] then
			error('conflict field: ' .. k)
		end

		if type(v) == 'function' and k ~= 'new' then
			m[k] = v
		end
	end

	return m
end

return {
	---@param ... string
	---@return table
	def = function (...)
		local t = setbase {}

		for i, v in ipairs {...} do
			mix(require(v), t)
		end

		return t
	end,
	---@generic T: table
	---@param T T
	---@return fun(instance: table): T
	base = function (T)
		return function (instance)
			return setmetatable(instance, T)
		end
	end,
}