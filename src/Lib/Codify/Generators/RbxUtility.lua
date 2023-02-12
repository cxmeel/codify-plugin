--!strict
local Generator = require(script.Parent.Generator)

local RbxUtilityCreate = Generator.new("RBXUTILITY_CREATE", {
	name = "RbxUtility.Create",
	description = 'Create "Object" {...}',
	category = "Luau",
})

RbxUtilityCreate.Settings.CREATE_METHOD = Generator.Setting({
	name = "Create function",
	description = "The name of the function used to create new objects",
	default = "Create",
	type = "string",

	validate = function(value)
		return #value > 0
	end,
})

RbxUtilityCreate.Settings.INCLUDE_ATTRIBUTES = Generator.Setting({
	name = "Include attributes",
	description = "Include custom Instance attributes",
	type = "boolean",
	default = true,
})

RbxUtilityCreate.Settings.INCLUDE_TAGS = Generator.Setting({
	name = "Include tags",
	description = "Include CollectionService tags",
	type = "boolean",
	default = true,
})

---@diagnostic disable-next-line: unused-local
function RbxUtilityCreate:Generate(package, options)
	return ""
end

return RbxUtilityCreate
