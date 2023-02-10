--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type EnumFormat = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<EnumItem, EnumFormat> = {}

Formatter.DEFAULT = "IMPLICIT"

function Formatter.EXPLICIT(value)
	return {
		Enum = value.Value,
	}
end

function Formatter.IMPLICIT(value)
	return value.Name
end

return Formatter
