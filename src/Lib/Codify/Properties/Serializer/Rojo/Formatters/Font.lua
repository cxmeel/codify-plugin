--!strict
-- Note: Not currently implemented in Rojo
-- https://github.com/rojo-rbx/rbx-dom/pull/248
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type FontFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<Font, FontFormat> = {}

function Formatter.EXPLICIT(value)
	return {
		family = value.Family,
		weight = value.Weight.Name,
		style = value.Style.Name,
	}
end

return Formatter
