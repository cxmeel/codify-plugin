--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type BrickColorFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<BrickColor, BrickColorFormat> = {}

function Formatter.EXPLICIT(value)
	return {
		BrickColor = value.Number,
	}
end

return Formatter
