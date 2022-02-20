local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "BrickColor Format",
	hint = "Configure how BrickColor values are displayed in code snippets.",

	settingsKey = "brickColorFormat",

	enumMap = {
		[Enums.BrickColorFormat.Name] = {
			label = "Name",
			hint = 'BrickColor.new("Bright red")',
		},

		[Enums.BrickColorFormat.Number] = {
			label = "Number",
			hint = "BrickColor.new(21)",
		},

		[Enums.BrickColorFormat.RGB] = {
			label = "RGB",
			hint = "BrickColor.new(196, 40, 28)",
		},

		[Enums.BrickColorFormat.Smart] = {
			label = "Smart",
			hint = "BrickColor.Red()",
		},
	},
})
