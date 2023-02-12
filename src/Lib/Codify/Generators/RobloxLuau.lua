--!strict
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

---@diagnostic disable-next-line: unused-local
function RobloxLuau:Generate(package, options)
	return ""
end

return RobloxLuau
