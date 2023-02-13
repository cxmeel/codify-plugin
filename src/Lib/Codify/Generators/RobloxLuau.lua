--!strict
local Serializer = require(script.Parent.Parent.Serializer.Default)
local SerCommon = require(script.Parent.Parent.Serializer.Common)
local Generator = require(script.Parent.Generator)

local RobloxLuau = Generator.new("ROBLOX_LUAU", {
	name = "No framework",
	description = 'Instance.new("Object")',
	category = "Luau",
})

RobloxLuau.Settings.INCLUDE_ATTRIBUTES = Generator.Setting({
	name = "Include attributes",
	description = "Include custom Instance attributes",
	type = "boolean",
	default = true,
})

RobloxLuau.Settings.INCLUDE_TAGS = Generator.Setting({
	name = "Include tags",
	description = "Include CollectionService tags",
	type = "boolean",
	default = true,
})

local function MakeWrite<T>(t: { T })
	return function(value: T)
		t[#t + 1] = value
	end
end

function RobloxLuau:Generate(package, config)
	local instances: { [string]: { string } } = {}
	local document: { string } = {}

	local classNames: { [string]: string } = {}
	local hoisted: { [string]: true } = {}

	local function formatProperty(property)
		local formatter = Serializer[property.Type]
		local propValue = property.Value

		if property.Type == "Enum" then
			propValue = Enum[propValue.Type][propValue.Value]
		end

		if formatter then
			propValue = formatter[config.Format[property.Type]](propValue)
		elseif property.Type == "string" or property.Type == "Content" then
			propValue = `"{propValue}"`
		elseif property.Type == "number" then
			propValue = SerCommon.FormatNumber(propValue)
		else
			propValue = tostring(propValue)
		end

		return SerCommon.IndentValue(propValue, config.Global.INDENT_CHAR)
	end

	local function writeNode(node)
		local var = config.VariableName[node.Ref]

		instances[var] = instances[var] or {}
		classNames[var] = node.ClassName

		local write = MakeWrite(instances[var])
		write(`local {var} = Instance.new("{node.ClassName}")`)

		for propName, prop in node.Properties do
			if prop.Type == "REF" then
				local linkedRef = config.VariableName[prop.Value]

				if linkedRef ~= nil then
					hoisted[linkedRef] = true
					write(`{var}.{propName} = {linkedRef}`)
				end

				continue
			end

			write(`{var}.{propName} = {formatProperty(prop)}`)
		end

		write("")

		if config.Local.INCLUDE_ATTRIBUTES == true and node.Attributes then
			for attrName, attr in node.Attributes do
				write(`{var}:SetAttribute("{attrName}", {formatProperty(attr)})`)
			end

			write("")
		end

		if config.Local.INCLUDE_TAGS == true and node.Tags then
			for _, tag in node.Tags do
				write(`CollectionService:AddTag({var}, "{tag}")`)
			end

			write("")
		end

		if node.Children then
			for _, child in node.Children do
				local childVar = writeNode(child)
				instances[childVar][#instances[childVar]] = `{childVar}.Parent = {var}\n`
			end
		end

		return var
	end

	local rootVar = writeNode(package.Tree)
	hoisted[rootVar] = true

	document[1] = `local {rootVar} = Instance.new("{classNames[rootVar]}")`

	local hoistedCount = 0

	for _ in hoisted do
		hoistedCount += 1
	end

	if hoistedCount > 1 then
		for hoistedVar in hoisted do
			if hoistedVar ~= rootVar then
				document[#document + 1] = instances[hoistedVar][1]
			end
		end

		document[#document + 1] = ""
	end

	for instanceVar, instance in instances do
		for index, line in instance do
			if index == 1 and hoisted[instanceVar] then
				continue
			end

			document[#document + 1] = line
		end
	end

	return table.concat(document, "\n")
end

return RobloxLuau
