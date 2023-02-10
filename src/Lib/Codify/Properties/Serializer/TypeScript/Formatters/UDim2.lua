--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)
local FormatUDim = require(script.Parent.UDim)

export type UDim2Format = "FULL" | "SMART" | "UDIM"

local Formatter: Common.FormatterMap<UDim2, UDim2Format> = {}

Formatter.DEFAULT = "SMART"

function Formatter.FULL(value)
	local sx, sy = value.X.Scale, value.Y.Scale
	local ox, oy = value.X.Offset, value.Y.Offset

	if sx == 0 and sy == 0 and ox == 0 and oy == 0 then
		return "new UDim2()"
	end

	sx, sy = Common.FormatNumber(sx), Common.FormatNumber(sy)
	ox, oy = ("%.0f"):format(ox), ("%.0f"):format(oy)

	return `new UDim2({sx}, {ox}, {sy}, {oy})`
end

function Formatter.SMART(value)
	local sx, sy = value.X.Scale, value.Y.Scale
	local ox, oy = value.X.Offset, value.Y.Offset

	if sx == 0 and sy == 0 and ox == 0 and oy == 0 then
		return "new UDim2()"
	end

	if sx == 0 and sy == 0 then
		ox, oy = ("%.0f"):format(ox), ("%.0f"):format(oy)
		return `UDim2.fromOffset({ox}, {oy})`
	end

	if ox == 0 and oy == 0 then
		sx, sy = Common.FormatNumber(sx), Common.FormatNumber(sy)
		return `UDim2.fromScale({sx}, {sy})`
	end

	return Formatter.FULL(value)
end

function Formatter.UDIM(value, options)
	local UDimFormat = options.Formats.UDim

	local ux = FormatUDim[UDimFormat](value.X, options)
	local uy = FormatUDim[UDimFormat](value.Y, options)

	return `new UDim2({ux}, {uy})`
end

return Formatter
