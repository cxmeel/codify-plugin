--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type EnumFormat = "FULL" | "NUMBER" | "STRING"

local Formatter: Common.FormatterMap<EnumItem, EnumFormat> = {}

Formatter.DEFAULT = "FULL"

function Formatter.FULL(value)
	return tostring(value)
end

function Formatter.NUMBER(value)
	return tostring(value.Value)
end

function Formatter.STRING(value)
	return `"{value.Name}"`
end

return Formatter
