--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

local Sift = require(script.Parent.Parent.Parent.Parent.Parent.Sift)
local Array = Sift.Array

export type NumberSequenceFormat = "SMART"

local Formatter: Common.FormatterMap<NumberSequence, NumberSequenceFormat> = {}

Formatter.DEFAULT = "SMART"

local function FormatKeypoint(keypoint: NumberSequenceKeypoint)
	local time = Common.FormatNumber(keypoint.Time)
	local value = Common.FormatNumber(keypoint.Value)

	if keypoint.Envelope == 0 then
		return `NumberSequenceKeypoint.new({time}, {value})`
	end

	local envelope = Common.FormatNumber(keypoint.Envelope)

	return `NumberSequenceKeypoint.new({time}, {value}, {envelope})`
end

function Formatter.SMART(value)
	local keypoints = value.Keypoints

	if keypoints[1].Value == keypoints[2].Value then
		local num = Common.FormatNumber(keypoints[1].Value)

		return `NumberSequence.new({num})`
	elseif #keypoints == 2 then
		local num0 = Common.FormatNumber(keypoints[1].Value)
		local num1 = Common.FormatNumber(keypoints[2].Value)

		return `NumberSequence.new({num0}, {num1})`
	end

	keypoints = table.concat(Array.map(keypoints, FormatKeypoint), ",\n")

	return ("NumberSequence.new({\n%s\n})"):format(keypoints)
end

return Formatter
