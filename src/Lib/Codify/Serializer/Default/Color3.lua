--!strict
local Sift = require(script.Parent.Parent.Parent.Sift)
local Common = require(script.Parent.Parent.Common)
local Array = Sift.Array

export type Color3Format = "FULL" | "HEX" | "HSV" | "RGB"

local Formatter: Common.FormatterMap<Color3, Color3Format> = {}

Formatter.DEFAULT = "HEX"

function Formatter.FULL(value)
	if value.R == 0 and value.G == 0 and value.B == 0 then
		return "Color3.new()"
	end

	local red = Common.FormatNumber(value.R)
	local green = Common.FormatNumber(value.G)
	local blue = Common.FormatNumber(value.B)

	return `Color3.new({red}, {green}, {blue})`
end

function Formatter.HEX(value)
	local hex = value:ToHex()
	return `Color3.fromHex({hex})`
end

function Formatter.HSV(value)
	local hsv = Array.map({ value:ToHSV() }, Common.FormatNumber)
	return `Color3.fromHSV({hsv[1]}, {hsv[2]}, {hsv[3]})`
end

function Formatter.RGB(value)
	local r = Common.FormatNumber(value.R * 255)
	local g = Common.FormatNumber(value.G * 255)
	local b = Common.FormatNumber(value.B * 255)

	return `Color3.fromRGB({r}, {g}, {b})`
end

return Formatter
