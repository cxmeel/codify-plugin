--!strict
local Common = require(script.Parent.Parent.Common)
local FormatUDim = require(script.Parent.UDim)

export type UDim2Format = "EXPLICIT"

local Formatter: Common.FormatterMap<UDim2, UDim2Format> = {}

Formatter.DEFAULT = "EXPLICIT"

function Formatter.EXPLICIT(value)
	return {
		UDim2 = {
			FormatUDim.EXPLICIT(value.X).UDim,
			FormatUDim.EXPLICIT(value.Y).UDim,
		},
	}
end

return Formatter
