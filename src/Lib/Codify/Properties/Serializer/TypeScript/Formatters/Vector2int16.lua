--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type Vector2int16Format = "FULL"

local Formatter: Common.FormatterMap<Vector2int16, Vector2int16Format> = {}

Formatter.DEFAULT = "FULL"

function Formatter.FULL(value)
	if value.X == 0 and value.Y == 0 then
		return "new Vector2int16()"
	end

	local x = Common.FormatNumber(value.X)
	local y = Common.FormatNumber(value.Y)

	return `new Vector2int16({x}, {y})`
end

return Formatter
