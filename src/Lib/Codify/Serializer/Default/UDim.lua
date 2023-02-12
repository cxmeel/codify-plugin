--!strict
local Common = require(script.Parent.Parent.Common)

export type UDimFormat = "FULL" | "SMART"

local Formatter: Common.FormatterMap<UDim, UDimFormat> = {}

Formatter.DEFAULT = "SMART"

function Formatter.FULL(value)
	if value.Scale == 0 and value.Offset == 0 then
		return "UDim.new()"
	end

	local scale = Common.FormatNumber(value.Scale)
	local offset = ("%.0f"):format(value.Offset)

	return `UDim.new({scale}, {offset})`
end

function Formatter.SMART(value, options)
	if value.Scale == 0 and value.Offset == 0 then
		return "UDim.new()"
	end

	if value.Offset == 0 then
		local scale = Common.FormatNumber(value.Scale)
		return `UDim.new({scale})`
	end

	return Formatter.FULL(value, options)
end

return Formatter
