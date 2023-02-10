--!strict
local T = require(script.Parent["init.d"])
local Properties = require(script.Parent.Parent.Properties)

local Generator: T.Generator = {}

Generator.Name = "None"
Generator.Language = "Luau"
Generator.Description = 'Instance.new("Object")'
Generator.Formatter = Properties.Serializer.Default

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

local function GenerateNode(node, options, lib)
	local var = lib.Variables[node.Ref]
	local output = {}

	output[#output + 1] = `local {var} = Instance.new("{node.ClassName}")`

	for propertyName, property in node.Properties do
		if property.Type == "Ref" then
			continue
		end

		local propertyValue = Generator.Formatter.FormatProperty(property, {
			Formats = options.Formats,
		})

		output[#output + 1] = `{var}.{propertyName} = {propertyValue}`
	end

	if options.INCLUDE_ATTRIBUTES == true then
		output[#output + 1] = ""

		for attributeName, attribute in node.Attributes do
			local attributeValue = Generator.Formatter.FormatProperty(attribute, {
				Formats = options.Formats,
			})

			output[#output + 1] = `{var}:SetAttribute("{attributeName}", {attributeValue})`
		end
	end

	if options.INCLUDE_TAGS == true then
		output[#output + 1] = ""

		for _, tagName in ipairs(node.Tags) do
			output[#output + 1] = `CollectionService:AddTag({var}, "{tagName}")`
		end
	end

	if node.Children then
		output[#output + 1] = ""

		for _, child in ipairs(node.Children) do
			local childRef = child.Ref

			output[#output + 1] = GenerateNode(child, options, lib)

			output[#output + 1] = ""
			output[#output + 1] = `{childRef}.Parent = {var}`
		end
	end

	return table.concat(output, "\n")
end

function Generator.Generate(package, options, lib)
	local output = GenerateNode(package.Tree, options, lib)
	return table.concat(output, "\n")
end

return Generator
