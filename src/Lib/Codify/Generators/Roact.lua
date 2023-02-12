--!strict
local Generator = require(script.Parent.Generator)

local Roact = Generator.new("ROACT_LUAU", {
	name = "Roact",
	description = 'Roact.createElement("Object", { ... })',
	category = "Luau",
})

Roact.Settings.CREATE_METHOD = Generator.Setting({
	name = "Create function",
	description = "The name of the function used to create new objects",
	default = "Roact.createElement",
	type = "string",

	validate = function(value)
		return #value > 0
	end,
})

---@diagnostic disable-next-line: unused-local
function Roact:Generate(package, options)
	return ""
end

return Roact
