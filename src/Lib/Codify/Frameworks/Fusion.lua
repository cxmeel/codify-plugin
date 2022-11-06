local Serialize = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)
local Properties = require(script.Parent.Parent.Parent.Properties)

local concat = table.concat
local fmt = string.format

local function FusionifyInstance(instance: Instance, options)
	local createMethod = options.CreateMethod or "New"
	local snippet = Script.new()

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

	local function tab()
		return string.rep(options.TabCharacter, options.Indent)
	end

	snippet:CreateLine():Push(createMethod, ' "', instance.ClassName, '" {')
	options.Indent += 1

	local nameChanged = table.find(changedProps, "Name")
	local name: string = nil

	if options.NamingScheme == "All" or (options.NamingScheme == "Changed" and nameChanged) then
		name = instance.Name

		snippet:CreateLine():Push(tab(), "Name = ", string.format("%q", name), ",")

		if #children > 0 and #changedProps == 0 then
			snippet:CreateLine()
		end
	end

	if #changedProps > 0 then
		for _, prop in ipairs(changedProps) do
			if prop == "Name" then
				continue
			end

			local value = Serialize.SerialiseProperty(instance, prop, options)

			if value == nil then
				continue
			end

			options.PropIndent = #prop + 3
			snippet:CreateLine():Push(tab(), prop, " = ", value, ",")
		end

		if #children > 0 then
			snippet:CreateLine()
		end
	end

	if #children > 0 then
		snippet:CreateLine():Push(tab(), fmt("[%s] = {", options.ChildrenKey or "Children"))
		options.Indent += 1

		for index, child in ipairs(children) do
			if index > 1 then
				snippet:CreateLine()
			end

			snippet:CreateLine():Push(tab(), FusionifyInstance(child, options), ",")
		end

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), "}")
	end

	options.Indent -= 1
	if #changedProps == 0 and #children == 0 and not name then
		snippet:Line():Push(" }")
	else
		snippet:CreateLine():Push(tab(), "}")
	end

	return snippet:Concat()
end

return {
	Generator = FusionifyInstance,

	Sample = concat({
		'return New "Lorem" {',
		'  ipsum = "dolor"',
		'  sit = "amet"',
		'  consectetur = "adipiscing"',
		'  elit = "sed"',
		'  do = "eiusmod"',
		'  tempor = "incididunt"',
		"}",
	}, "\n"),
}
