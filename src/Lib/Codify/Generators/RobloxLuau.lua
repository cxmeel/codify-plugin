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

function RobloxLuau:Generate(package, options)
	local instances: { [string]: { string } } = {}
	local document: { string } = {}

	local function formatProperty(property)
		local formatter = Serializer[property.Type]
		local propValue = property.Value

		if formatter then
			propValue = formatter[options.Format[property.Type]](propValue)
		elseif typeof(propValue) == "string" then
			propValue = `"{propValue}"`
		elseif typeof(propValue) == "number" then
			propValue = SerCommon.FormatNumber(propValue)
		else
			propValue = tostring(propValue)
		end

		return SerCommon.IndentValue(propValue, options.Global.INDENT_CHAR)
	end

	local function writeNode(node)
		local var = options.VariableName[node.Ref]

		if not instances[var] then
			instances[var] = { Priority = 1 }
		elseif not instances[var].Priority then
			instances[var].Priority = 1
		end

		local write = MakeWrite(instances[var])
		write(`local {var} = Instance.new("{node.ClassName}")`)

		for propName, prop in node.Properties do
			if prop.Type == "REF" then
				local linkedRef = options.VariableName[prop.Value]

				if linkedRef ~= nil then
					if not instances[linkedRef] then
						instances[linkedRef] = { Priority = 1 }
					else
						instances[linkedRef].Priority += 1
					end

					write(`{var}.{propName} = {linkedRef}`)
				end

				continue
			end

			write(`{var}.{propName} = {formatProperty(prop)}`)
		end

		write("")

		if options.Local.INCLUDE_ATTRIBUTES == true and node.Attributes then
			for attrName, attr in node.Attributes do
				write(`{var}:SetAttribute("{attrName}", {formatProperty(attr)})`)
			end

			write("")
		end

		if options.Local.INCLUDE_TAGS == true and node.Tags then
			for _, tag in node.Tags do
				write(`CollectionService:AddTag({var}, "{tag}")`)
			end

			write("")
		end

		if node.Children then
			for _, child in node.Children do
				local childVar = writeNode(child)
				write(`{childVar}.Parent = {var}\n`)
			end
		end

		return var
	end

	local rootVar = writeNode(package.Tree)
	instances[rootVar].Priority = math.huge

	table.sort(instances, function(a, b)
		return a.Priority > b.Priority
	end)

	for _, instance in instances do
		table.insert(document, table.concat(instance, "\n"))
	end

	return table.concat(document, "\n")
end

return RobloxLuau
