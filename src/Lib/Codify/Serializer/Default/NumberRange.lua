--!strict
local Common = require(script.Parent.Parent.Common)

export type NumberRangeFormat = "FULL" | "SMART"

local Formatter: Common.FormatterMap<NumberRange, NumberRangeFormat> = {}

Formatter.DEFAULT = "SMART"

function Formatter.FULL(value)
	local min = Common.FormatNumber(value.Min)
	local max = Common.FormatNumber(value.Max)

	return `NumberRange.new({min}, {max})`
end

function Formatter.SMART(value)
	if value.Min == value.Max then
		return `NumberRange.new({Common.FormatNumber(value.Min)})`
	end

	return Formatter.FULL(value)
end

return Formatter
