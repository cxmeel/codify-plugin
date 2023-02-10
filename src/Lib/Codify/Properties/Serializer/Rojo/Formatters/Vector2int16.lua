--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type Vector2int16Format = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<Vector2int16, Vector2int16Format> = {}

function Formatter.IMPLICIT(value)
	return {
		value.X,
		value.Y,
	}
end

function Formatter.EXPLICIT(value, options)
	return {
		Vector2int16 = Formatter.IMPLICIT(value, options),
	}
end

return Formatter
