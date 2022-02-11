local Serialize = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)
local Properties = require(script.Parent.Parent.Parent.Properties)

local function RoactifyInstance(instance: Instance, options)
	local snippet = Script.new()

	local changedProps = select(2, Properties.GetChangedProperties(instance):await())
	local children = instance:GetChildren()

	local function tab()
		return string.rep(options.TabCharacter, options.Indent)
	end

	snippet:CreateLine():Push(options.CreateMethod, '("', instance.ClassName, '"')

	if options.Indent > 0 then
		local nameChanged = table.find(changedProps, "Name")
		local name = instance.Name

		if options.NamingScheme == "ALL" or (options.NamingScheme == "CHANGED" and nameChanged) then
			name = name:sub(1, 1):lower() .. name:sub(2)
		elseif options.NamingScheme == "NONE" or (options.NamingScheme == "CHANGED" and not nameChanged) then
			name = nil
		end

		if name ~= nil then
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

			options.PropIndent = #prop + 3

			local value = Serialize.SerialiseProperty(instance, prop, options)
			snippet:CreateLine():Push(tab(), prop, " = ", value, ",")
		end

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), "}")
	end

	if #children > 0 then
		snippet:Line():Push(", {")
		options.Indent += 1

		for _, child in ipairs(children) do
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
