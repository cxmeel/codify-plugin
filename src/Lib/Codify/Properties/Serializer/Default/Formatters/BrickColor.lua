--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)
local FormatColor3 = require(script.Parent.Color3)

export type BrickColorFormat = "FULL" | "RGB" | "NUMBER" | "COLOR3" | "SMART"

local Formatter: Common.FormatterMap<BrickColor, BrickColorFormat> = {}

Formatter.DEFAULT = "FULL"

function Formatter.FULL(value)
	return `BrickColor.new("{value.Name}")`
end

function Formatter.RGB(value)
	local red = Common.FormatNumber(value.Color.R * 255)
	local green = Common.FormatNumber(value.Color.G * 255)
	local blue = Common.FormatNumber(value.Color.B * 255)

	return `BrickColor.new({red}, {green}, {blue})`
end

function Formatter.NUMBER(value)
	return `BrickColor.new({value.Number})`
end

function Formatter.COLOR3(value, options)
	local color3 = FormatColor3[options.Formats.Color3](value.Color, options)
	return `BrickColor.new({color3})`
end

function Formatter.SMART(value, options)
	for methodName, brickColor in Common.BRICKCOLOR_CONVENIENCE_METHODS do
		if brickColor == value then
			return `BrickColor.{methodName}()`
		end
	end

	return Formatter.FULL(value, options)
end

return Formatter
