--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type Vector3int16Format = "FULL"

local Formatter: Common.FormatterMap<Vector3int16, Vector3int16Format> = {}

function Formatter.FULL(value)
	if value.X == 0 and value.Y == 0 and value.Z == 0 then
		return "Vector3int16.new()"
	end

	local x = Common.FormatNumber(value.X)
	local y = Common.FormatNumber(value.Y)
	local z = Common.FormatNumber(value.Z)

	return `Vector3int16.new({x}, {y}, {z})`
end

return Formatter
