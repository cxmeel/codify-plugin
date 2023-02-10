--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

local Sift = require(script.Parent.Parent.Parent.Parent.Parent.Sift)
local Array = Sift.Array

export type NumberSequenceFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<NumberSequence, NumberSequenceFormat> = {}

local function FormatKeypoint(keypoint: NumberSequenceKeypoint)
	return {
		time = keypoint.Time,
		value = keypoint.Value,
		envelope = keypoint.Envelope,
	}
end

function Formatter.EXPLICIT(value)
	return {
		NumberSequence = {
			keypoints = Array.map(value.Keypoints, FormatKeypoint),
		},
	}
end

return Formatter
