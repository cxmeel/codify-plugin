--!strict
local T = require(script.Parent["init.d"])
local Properties = require(script.Parent.Parent.Properties)

local Generator: T.Generator = {}

Generator.Name = "None"
Generator.Language = "Luau"
Generator.Description = 'Instance.new("Object")'
Generator.Serializer = Properties.Serializer.Default

Generator.Settings = {
	INCLUDE_ATTRIBUTES = {
		Name = "Include attributes",
		Description = "Include custom attributes in the output",
		Type = "boolean",
		Default = true,
	},
	INCLUDE_TAGS = {
		Name = "Include tags",
		Description = "Include CollectionService tags in the output",
		Type = "boolean",
		Default = true,
	},
}

function Generator.Generate(package, options, lib)
	local vars = lib.Variable
	local document = {}

	local function createInstance(node)
		local var = vars[node.Ref]
		table.insert(document, `local {var} = Instance.new("{node.ClassName}")`)

		for propertyName, property in node.Properties do
			local prop = Generator.Serializer.FormatProperty(property.Value, {
				Formats = options.Formats,
			})

			table.insert(document, `{var}.{propertyName} = {prop}`)
		end
	end

	createInstance(package.Tree)

	return table.concat(document, "\n")
end

return Generator
