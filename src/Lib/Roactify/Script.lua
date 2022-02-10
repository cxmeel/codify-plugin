local Line = require(script.Parent.ScriptLine)

local Script = {}
Script.__index = Script

function Script.new()
	local self = setmetatable({}, Script)

	self.Lines = {}

	return self
end

function Script:CreateLine()
	local line = Line.new()

	table.insert(self.Lines, line)

	return line
end

function Script:At(index: number)
	return self.Lines[index]
end

function Script:Line(index: number?)
	if index then
		return self.Lines[index]
	else
		return self.Lines[#self.Lines]
	end
end

function Script:Concat(separator: string?)
	local lines = {}

	for _, line in ipairs(self.Lines) do
		table.insert(lines, line:Concat())
	end

	return table.concat(lines, separator or "\n")
end

return Script
