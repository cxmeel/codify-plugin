--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type Vector2Format = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<Vector2, Vector2Format> = {}

Formatter.DEFAULT = "IMPLICIT"

function Formatter.IMPLICIT(value)
	return {
		value.X,
		value.Y,
	}
end

function Formatter.EXPLICIT(value, options)
	return {
		Vector2 = Formatter.IMPLICIT(value, options),
	}
end

return Formatter
