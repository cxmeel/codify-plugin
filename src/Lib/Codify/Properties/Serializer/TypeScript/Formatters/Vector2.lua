--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type Vector2Format = "FULL" | "SMART"

local Formatter: Common.FormatterMap<Vector2, Vector2Format> = {}

function Formatter.FULL(value)
	if value.X == 0 and value.Y == 0 then
		return "new Vector2()"
	end

	local x = Common.FormatNumber(value.X)
	local y = Common.FormatNumber(value.Y)

	return `new Vector2({x}, {y})`
end

function Formatter.SMART(value, options)
	if value.X == 0 and value.Y == 0 then
		return "Vector2.zero"
	elseif value.X == 1 and value.Y == 1 then
		return "Vector2.one"
	elseif value.X == 1 and value.Y == 0 then
		return "Vector2.xAxis"
	elseif value.X == 0 and value.Y == 1 then
		return "Vector2.yAxis"
	elseif value.X ~= 0 and value.Y == 0 then
		local x = Common.FormatNumber(value.X)

		return `new Vector2({x})`
	end

	return Formatter.FULL(value, options)
end

return Formatter
