local Serialize = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)
local Properties = require(script.Parent.Parent.Parent.Properties)

local getSafeVarName = require(script.Parent.Parent.GetSafeName)

local function RoactifyInstance(instance: Instance, options)
	local createMethod = options.CreateMethod or "Roact.createElement"
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

	snippet:CreateLine():Push(createMethod, '("', instance.ClassName, '"')

	if options.Indent > 0 then
		local nameChanged = table.find(changedProps, "Name")

		if nameChanged then
			table.remove(changedProps, nameChanged)
		end

		if options.NamingScheme == "All" or (options.NamingScheme == "Changed" and nameChanged) then
			local name = getSafeVarName(instance)
			if options.LevelIdentifiers[name] ~= nil then
				options.LevelIdentifiers[name] += 1
				name ..= tostring(options.LevelIdentifiers[name])
			else
				options.LevelIdentifiers[name] = 0
			end

			snippet:Line():Insert(1, name, " = ")
		end
	end

	if #changedProps > 0 then
		snippet:Line():Push(", {")
		options.Indent += 1

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

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), "}")
	end

	if #children > 0 then
		snippet:Line():Push(", {")
		options.Indent += 1

		for index, child in ipairs(children) do
			if index > 1 then
				snippet:CreateLine()
			end

			snippet:CreateLine():Push(tab(), RoactifyInstance(child, options), ",")
		end

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), "}")
	end

	snippet:Line():Push(")")

	return snippet:Concat()
end

return {
	Generator = RoactifyInstance,
	Sample = table.concat({
		'return Roact.createElement("Lorem", {',
		'  ipsum = "dolor"',
		'  sit = "amet"',
		'  consectetur = "adipiscing"',
		'  elit = "sed"',
		'  do = "eiusmod"',
		'  tempor = "incididunt"',
		"})",
	}, "\n"),
}
