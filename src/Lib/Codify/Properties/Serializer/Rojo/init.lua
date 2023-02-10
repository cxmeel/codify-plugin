--!strict
local Common = require(script.Parent.Parent.Common)
local Formatters = require(script.Formatters)

local function FormatProperty(property: Common.Property, options: any)
	local propType = property.Type

	local formatter = Formatters[propType]
	local format = options.Formats[propType]

	if formatter ~= nil then
		return formatter[format](property.Value, options)
	end

	if type(property.Value) == "userdata" then
		return
	end

	return property.Value
end

return FormatProperty
