--!strict
local Common = require(script.Parent.Parent.Common)

export type BrickColorFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<BrickColor, BrickColorFormat> = {}

Formatter.DEFAULT = "EXPLICIT"

function Formatter.EXPLICIT(value)
	return {
		BrickColor = value.Number,
	}
end

return Formatter
