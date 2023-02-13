--!strict
local Common = require(script.Parent.Parent.Common)

export type BooleanFormat = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<boolean, BooleanFormat> = {}

Formatter.DEFAULT = "IMPLICIT"

function Formatter.IMPLICIT(value)
	return value
end

function Formatter.EXPLICIT(value, options)
	return {
		Boolean = Formatter.IMPLICIT(value, options),
	}
end

return Formatter
