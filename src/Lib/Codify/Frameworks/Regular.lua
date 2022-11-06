local Properties = require(script.Parent.Parent.Parent.Properties)
local GetSafeName = require(script.Parent.Parent.GetSafeName)
local Serialise = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)

local concat = table.concat
local fmt = string.format

local function Regularify(instance: Instance, options)
	local output = Script.new()

	if options.ParallelLuau then
		task.synchronize()
	end

	local success, changedProps = Properties.GetChangedProperties(instance):await()
	local children = instance:GetChildren()

	if not success then
		error("Failed to get changed properties: " .. tostring(changedProps), 2)
	end

	if options.ParallelLuau then
		task.desynchronize()
	end

	if not options._instanceNames then
		options._instanceNames = {}
	end

	local name = GetSafeName(instance)

	if options._instanceNames[name] == nil then
		options._instanceNames[name] = 0
	else
		options._instanceNames[name] += 1
		name ..= options._instanceNames[name]
	end

	output:CreateLine():Push(fmt("local %s = Instance.new(%q)", name, instance.ClassName))

	local isNameChanged = table.find(changedProps, "Name")

	if options.NamingScheme == "All" or (options.NamingScheme == "Changed" and isNameChanged) then
		output:CreateLine():Push(fmt("%s.Name = %q", name, instance.Name))
	end

	if #changedProps > 0 then
		for _, property in ipairs(changedProps) do
			if property == "Name" then
				continue
			end

			local value = Serialise.SerialiseProperty(instance, property, options)

			if value == nil then
				continue
			end

			options.PropIndent = #property + 3
			output:CreateLine():Push(fmt("%s.%s = %s", name, property, value))
		end
	end

	if #children > 0 then
		for index, child in ipairs(children) do
			output:CreateLine()

			local snippet, childName = Regularify(child, options)

			output:CreateLine():Push(snippet)
			output:CreateLine():Push(fmt("%s.Parent = %s", childName, name))

			if index == #children then
				output:CreateLine()
			end
		end
	end

	return output:Concat(), name
end

return {
	Generator = Regularify,
	Sample = concat({
		'local lorem = Instance.new("Lorem")',
		'lorem.ipsum = "dolor"',
		'lorem.sit = "amet"',
		'lorem.consectetur = "adipiscing"',
		'lorem.elit = "sed"',
		'lorem.do = "eiusmod"',
		'lorem.tempor = "incididunt"',
	}, "\n"),
}
