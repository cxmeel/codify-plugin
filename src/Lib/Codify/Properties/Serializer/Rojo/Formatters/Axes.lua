--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type AxesFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<Axes, AxesFormat> = {}

function Formatter.EXPLICIT(value)
	local axes = {}

	for _, axis in Enum.Axis:GetEnumItems() do
		if value[axis] then
			table.insert(axes, axis.Name)
		end
	end

	return {
		Axes = axes,
	}
end

return Formatter
