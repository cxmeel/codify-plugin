--!strict
local Common = require(script.Parent.Parent.Common)

export type StringFormat = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<string, StringFormat> = {}

Formatter.DEFAULT = "IMPLICIT"

function Formatter.IMPLICIT(value)
	return value
end

function Formatter.EXPLICIT(value, options)
	return {
		String = Formatter.IMPLICIT(value, options),
	}
end

return Formatter
