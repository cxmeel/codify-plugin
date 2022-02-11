local Serialize = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)
local Properties = require(script.Parent.Parent.Parent.Properties)

local function getSafeVarName(instance: Instance): string
	local name = instance.Name
	local first = string.find(name, "^%a")
	local prefix = string.lower(string.sub(name, first, first))
	local suffix = string.sub(name, first+1)
	local var = string.gsub(prefix .. suffix, "[^%w]", "_")
	return var
end

local function RegularifyInstance(instance: Instance, options)
	local snippet = Script.new()

	local changedProps = select(2, Properties.GetChangedProperties(instance):await())
	local children = instance:GetChildren()

	local var = getSafeVarName(instance)
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

			local childVar = getSafeVarName(child)
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
