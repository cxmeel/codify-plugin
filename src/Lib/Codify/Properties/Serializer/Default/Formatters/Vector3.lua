--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type Vector3Format = "FULL" | "SMART"

local Formatter: Common.FormatterMap<Vector3, Vector3Format> = {}

function Formatter.FULL(value)
	if value.X == 0 and value.Y == 0 and value.Z == 0 then
		return "Vector3.new()"
	end

	local x = Common.FormatNumber(value.X)
	local y = Common.FormatNumber(value.Y)
	local z = Common.FormatNumber(value.Z)

	return `Vector3.new({x}, {y}, {z})`
end

function Formatter.SMART(value, options)
	if value.X == 0 and value.Y == 0 and value.Z == 0 then
		return "Vector3.zero"
	elseif value.X == 1 and value.Y == 1 and value.Z == 1 then
		return "Vector3.one"
	elseif value.X == 1 and value.Y == 0 and value.Z == 0 then
		return "Vector3.xAxis"
	elseif value.X == 0 and value.Y == 1 and value.Z == 0 then
		return "Vector3.yAxis"
	elseif value.X == 0 and value.Y == 0 and value.Z == 1 then
		return "Vector3.zAxis"
	elseif value.X ~= 0 and value.Y == 0 and value.Z == 0 then
		local x = Common.FormatNumber(value.X)

		return `Vector3.new({x})`
	elseif value.X ~= 0 and value.Y ~= 0 and value.Z == 0 then
		local x = Common.FormatNumber(value.X)
		local y = Common.FormatNumber(value.Y)

		return `Vector3.new({x}, {y})`
	end

	return Formatter.FULL(value, options)
end

return Formatter
