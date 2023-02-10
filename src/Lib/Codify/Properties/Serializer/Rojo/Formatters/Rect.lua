--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type RectFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<Rect, RectFormat> = {}

function Formatter.EXPLICIT(value)
	return {
		Rect = {
			{ value.Min.X, value.Min.Y },
			{ value.Max.X, value.Max.Y },
		},
	}
end

return Formatter
