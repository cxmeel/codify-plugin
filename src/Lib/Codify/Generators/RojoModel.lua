--!strict
local Generator = require(script.Parent.Generator)

local RojoModel = Generator.new("ROJO_JSON_MODEL", {
	name = "Rojo Model",
	description = '{"$className": "Object", ...}',
	category = "JSON",
})

RojoModel.Settings.IGNORE_UNKNOWN_INSTANCES = Generator.Setting({
	name = "Ignore unknown instances",
	description = 'Sets "$ignoreUnknownInstances" to true on all Instances',
	type = "boolean",
	default = false,
})

RojoModel.Settings.EXPLICIT_VALUES = Generator.Setting({
	name = "Explicit values",
	description = "Declares all property values explicitly where possible",
	type = "boolean",
	default = false,
})

RojoModel.Settings.MINIFY_OUTPUT = Generator.Setting({
	name = "Minify output",
	description = "Renders a minified JSON string, rather than a pretty-printed one",
	type = "boolean",
	default = false,
})

---@diagnostic disable-next-line: unused-local
function RojoModel:Generate(package, options)
	return ""
end

return RojoModel
