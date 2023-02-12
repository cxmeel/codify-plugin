--!strict
local Common = require(script.Parent.Parent.Common)

export type Vector3Format = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<Vector3, Vector3Format> = {}

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
		Vector3 = Formatter.IMPLICIT(value, options),
	}
end

return Formatter
