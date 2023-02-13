--!strict
local Common = require(script.Parent.Parent.Common)

export type Color3Format = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<Color3, Color3Format> = {}

Formatter.DEFAULT = "IMPLICIT"

function Formatter.EXPLICIT(value)
	return {
		Color3 = {
			value.R,
			value.G,
			value.B,
		},
	}
end

function Formatter.IMPLICIT(value)
	return {
		value.R,
		value.G,
		value.B,
	}
end

return Formatter
