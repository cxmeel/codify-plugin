--!strict
local Common = require(script.Parent.Parent.Common)
local FormatEnum = require(script.Parent.Enum)

export type NormalIdFormat = "FULL"
type NormalId = Axes | Faces

local Formatter: Common.FormatterMap<NormalId, NormalIdFormat> = {}

Formatter.DEFAULT = "FULL"

function Formatter.FULL(value)
	local dataType = typeof(value)
	local axes = {}

	for _, normalId in Enum.NormalId:GetEnumItems() do
		if value[normalId] then
			axes[#axes + 1] = FormatEnum.FULL(normalId)
		end
	end

	return `{dataType}.new({table.concat(axes, ", ")})`
end

return Formatter
