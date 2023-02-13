--!strict
local Common = require(script.Parent.Parent.Common)
local FormatColor3 = require(script.Parent.Color3)

local Sift = require(script.Parent.Parent.Parent.Sift)
local Array = Sift.Array

export type ColorSequenceFormat = "SMART"

local Formatter: Common.FormatterMap<ColorSequence, ColorSequenceFormat> = {}

Formatter.DEFAULT = "SMART"

local function FormatKeypoint(keypoint: ColorSequenceKeypoint, options)
	local time = Common.FormatNumber(keypoint.Time)
	local value = FormatColor3(keypoint.Value, options)

	return `ColorSequenceKeypoint.new({time}, {value})`
end

function Formatter.SMART(value, options)
	local keypoints = value.Keypoints

	if keypoints[1].Value == keypoints[2].Value then
		local color = FormatColor3(keypoints[1].Value, options)

		return `ColorSequence.new({color})`
	elseif #keypoints == 2 then
		local color0 = FormatColor3(keypoints[1].Value, options)
		local color1 = FormatColor3(keypoints[2].Value, options)

		return `ColorSequence.new({color0}, {color1})`
	end

	keypoints = table.concat(
		Array.map(keypoints, function(keypoint)
			return FormatKeypoint(keypoint, options)
		end),
		",\n"
	)

	return ("ColorSequence.new({\n%s\n})"):format(keypoints)
end

return Formatter
