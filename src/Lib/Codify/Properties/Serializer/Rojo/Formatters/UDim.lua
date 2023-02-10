--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type UDimFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<UDim, UDimFormat> = {}

function Formatter.EXPLICIT(value)
	return {
		UDim = {
			value.Scale,
			value.Offset,
		},
	}
end

return Formatter
