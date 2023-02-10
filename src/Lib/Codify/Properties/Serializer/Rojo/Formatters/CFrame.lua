--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type CFrameFormat = "EXPLICIT" | "IMPLICIT"

local Formatter: Common.FormatterMap<CFrame, CFrameFormat> = {}

function Formatter.EXPLICIT(value)
	local px, py, pz, xx, yx, zx, xy, yy, zy, xz, yz, zz = value:GetComponents()

	return {
		CFrame = {
			position = { px, py, pz },
			orientation = { xx, yx, zx, xy, yy, zy, xz, yz, zz },
		},
	}
end

function Formatter.IMPLICIT(value)
	return { value:GetComponents() }
end

return Formatter
