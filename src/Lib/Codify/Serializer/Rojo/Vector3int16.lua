--!strict
local Common = require(script.Parent.Parent.Common)

export type Vector3int16Format = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<Vector3int16, Vector3int16Format> = {}

Formatter.DEFAULT = "IMPLICIT"

function Formatter.IMPLICIT(value)
	return {
		value.X,
		value.Y,
		value.Z,
	}
end

function Formatter.EXPLICIT(value, options)
	return {
		Vector3int16 = Formatter.IMPLICIT(value, options),
	}
end

return Formatter
