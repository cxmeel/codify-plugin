--!strict
local Common = require(script.Parent.Parent.Common)

local Sift = require(script.Parent.Parent.Parent.Sift)
local Array = Sift.Array

export type ColorSequenceFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<ColorSequence, ColorSequenceFormat> = {}

Formatter.DEFAULT = "EXPLICIT"

local function FormatKeypoint(keypoint: ColorSequenceKeypoint)
	return {
		time = keypoint.Time,
		color = {
			keypoint.Value.R,
			keypoint.Value.G,
			keypoint.Value.B,
		},
	}
end

function Formatter.EXPLICIT(value)
	return {
		ColorSequence = {
			keypoints = Array.map(value.Keypoints, FormatKeypoint),
		},
	}
end

return Formatter
