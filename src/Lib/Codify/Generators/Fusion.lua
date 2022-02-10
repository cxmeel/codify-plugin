local Serialize = require(script.Parent.Parent.Serialize)
local Script = require(script.Parent.Parent.Script)
local Properties = require(script.Parent.Parent.Parent.Properties)

local function FusionifyInstance(instance: Instance, options)
	local snippet = Script.new()

	local changedProps = select(2, Properties.GetChangedProperties(instance):await())
	local children = instance:GetChildren()

	local function tab()
		return string.rep(options.TabCharacter, options.Indent)
	end

	snippet:CreateLine():Push('New "', instance.ClassName, '" {')
	options.Indent += 1

	local name = instance.Name
	local nameChanged = table.find(changedProps, "Name")
	if options.NamingScheme == "NONE" or (options.NamingScheme == "CHANGED" and not nameChanged) then
		name = nil
	end

	if name ~= nil then
		if options.LevelIdentifiers[name] ~= nil then
			options.LevelIdentifiers[name] += 1
			name ..= tostring(options.LevelIdentifiers[name])
		else
			options.LevelIdentifiers[name] = 0
		end

		snippet:CreateLine():Push(tab(), "Name = ", string.format("%q", name), ",")
	end

	if #changedProps > 0 then
		for _, prop in ipairs(changedProps) do
			if prop == "Name" then
				continue
			end

			options.PropIndent = #prop + 3

			local value = Serialize.SerialiseProperty(instance, prop, options)
			snippet:CreateLine():Push(tab(), prop, " = ", value, ",")
		end
	end

	if #children > 0 then
		snippet:CreateLine()
		snippet:CreateLine():Push(tab(), "[Children] = {")
		options.Indent += 1

		for _, child in ipairs(children) do
			snippet:CreateLine():Push(tab(), FusionifyInstance(child, options), ",")
		end

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), "}")
	end

	options.Indent -= 1
	snippet:CreateLine():Push(tab(), "}")

	return snippet:Concat()
end

return FusionifyInstance
