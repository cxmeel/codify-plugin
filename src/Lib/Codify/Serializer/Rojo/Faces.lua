--!strict
local Common = require(script.Parent.Parent.Common)

export type FacesFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<Faces, FacesFormat> = {}

Formatter.DEFAULT = "EXPLICIT"

function Formatter.EXPLICIT(value)
	local faces = {}

	for _, face in Enum.NormalId:GetEnumItems() do
		if value[face] then
			table.insert(faces, face.Name)
		end
	end

	return {
		Faces = faces,
	}
end

return Formatter
