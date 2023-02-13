--!strict
local Generator = require(script.Parent.Generator)

local RoactTSX = Generator.new("ROACT_TYPESCRIPT", {
	name = "Roact TSX",
	description = "<Object>...</Object>",
	category = "TypeScript",
})

---@diagnostic disable-next-line: unused-function, unused-local
local function reformatProperty(property: string): string
	local newProperty = property:gsub("(%w+)%.new", "new %1")
	return newProperty
end

---@diagnostic disable-next-line: unused-local
function RoactTSX:Generate(package, options)
	return ""
end

return RoactTSX
