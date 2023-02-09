--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type EnumFormat = "FULL" | "SMART"

local Formatter: Common.FormatterMap<EnumItem, EnumFormat> = {}

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
