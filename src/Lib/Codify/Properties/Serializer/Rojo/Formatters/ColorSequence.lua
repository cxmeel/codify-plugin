--!strict
local HttpService = game:GetService("HttpService")

local Common = require(script.Parent.Parent.Parent.Parent.Common)

local Sift = require(script.Parent.Parent.Parent.Parent.Parent.Sift)
local Array = Sift.Array

export type ColorSequenceFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<ColorSequence, ColorSequenceFormat> = {}

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
	return HttpService:JSONEncode({
		ColorSequence = {
			keypoints = Array.map(value.Keypoints, FormatKeypoint),
		},
	})
end

return Formatter
