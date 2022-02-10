local Line = {}
Line.__index = Line

function Line.new()
	local self = setmetatable({}, Line)

	self.Text = {}
	self.Indent = 0

	return self
end

function Line:Push(...: string)
	local args = { ... }

	for _, arg in ipairs(args) do
		table.insert(self.Text, arg)
	end
end

function Line:Insert(index: number, ...: string)
	local args = { ... }

	for argIndex, arg in ipairs(args) do
		table.insert(self.Text, index + (argIndex - 1), arg)
	end
end

function Line:Concat(separator: string?)
	return table.concat(self.Text, separator or "")
end

return Line
