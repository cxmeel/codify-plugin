--!strict
local Generator = require(script.Parent.Generator)

local Fusion = Generator.new("FUSION_LUAU", {
	name = "Fusion",
	description = 'New "Object" { ... }',
	category = "Luau",
})

Fusion.Settings.CREATE_METHOD = Generator.Setting({
	name = "Create function",
	description = "The name of the function used to create new objects",
	default = "New",
	type = "string",

	validate = function(value)
		return #value > 0
	end,
})

Fusion.Settings.CHILDREN_KEY = Generator.Setting({
	name = "Children key",
	description = "The name of the variable referencing the Children special key",
	default = "Children",
	type = "string",

	validate = function(value)
		return #value > 0
	end,
})

---@diagnostic disable-next-line: unused-local
function Fusion:Generate(package, options)
	return ""
end

return Fusion
