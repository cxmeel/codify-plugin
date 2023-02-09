--!strict
local HttpService = game:GetService("HttpService")
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type BrickColorFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<BrickColor, BrickColorFormat> = {}

function Formatter.EXPLICIT(value)
	return HttpService:JSONEncode({
		BrickColor = value.Number,
	})
end

return Formatter
