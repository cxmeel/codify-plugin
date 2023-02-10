--!strict
local Base64 = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Packages.Base64)
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type StringFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<string, StringFormat> = {}

Formatter.DEFAULT = "EXPLICIT"

function Formatter.EXPLICIT(value)
	return {
		BinaryString = Base64.encode(value),
	}
end

return Formatter
