--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type RectFormat = "SMART"

local Formatter: Common.FormatterMap<Rect, RectFormat> = {}

function Formatter.SMART(value)
	if value.Width == 0 and value.Height == 0 then
		return "new Rect()"
	end

	local x0 = Common.FormatNumber(value.Min.X)
	local y0 = Common.FormatNumber(value.Min.Y)
	local x1 = Common.FormatNumber(value.Max.X)
	local y1 = Common.FormatNumber(value.Max.Y)

	return `new Rect({x0}, {y0}, {x1}, {y1})`
end

return Formatter
