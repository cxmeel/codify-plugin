local Serialize = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)
local Properties = require(script.Parent.Parent.Parent.Properties)

local function RegularifyInstance(instance: Instance, options)
	local snippet = Script.new()

	local changedProps = select(2, Properties.GetChangedProperties(instance):await())
	local children = instance:GetChildren()

	local var = string.lower(string.sub(instance.Name, 1, 1)) .. string.sub(instance.Name, 2)
	if options.LevelIdentifiers[var] ~= nil then
		options.LevelIdentifiers[var] += 1
		var ..= tostring(options.LevelIdentifiers[var])
	else
		options.LevelIdentifiers[var] = 0
	end

	snippet:CreateLine():Push("local " .. var .. ' = Instance.new("', instance.ClassName, '")')

	local nameChanged = table.find(changedProps, "Name")
	if options.NamingScheme == "ALL" or (options.NamingScheme == "CHANGED" and nameChanged) then
		snippet:CreateLine():Push(var, ".Name = ", string.format("%q", var))
	end

	if #changedProps > 0 then
		for _, prop in ipairs(changedProps) do
			if prop == "Name" then
				continue
			end

			options.PropIndent = #prop + 3

			local value = Serialize.SerialiseProperty(instance, prop, options)
			snippet:CreateLine():Push(var, ".", prop, " = ", value)
		end
	end

	if #children > 0 then
		for _, child in ipairs(children) do
			snippet:CreateLine()
			snippet:CreateLine():Push(RegularifyInstance(child, options))

			local childVar = string.lower(string.sub(child.Name, 1, 1)) .. string.sub(child.Name, 2)
			if options.LevelIdentifiers[childVar] > 0 then
				childVar ..= tostring(options.LevelIdentifiers[childVar])
			end

			snippet:CreateLine():Push(childVar, ".Parent = ", var)
		end
	end

	return snippet:Concat()
end

return {
	Generator = RegularifyInstance,
	Sample = table.concat({
		'local lorem = Instance.new("Lorem")',
		'lorem.ipsum = "dolor"',
		'lorem.sit = "amet"',
		'lorem.consectetur = "adipiscing"',
		'lorem.elit = "sed"',
		'lorem.do = "eiusmod"',
		'lorem.tempor = "incididunt"',
	}, "\n"),
}
