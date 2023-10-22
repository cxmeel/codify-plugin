local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "Color3 Format",
	anchor = "format-color3",
	hint = "Configure how Color3 values are displayed in code snippets.",

	settingsKey = "color3Format",

	enumMap = {
		[Enums.Color3Format.Full] = {
			label = "Full",
			hint = "Color3.new",
		},

		[Enums.Color3Format.RGB] = {
			label = "RGB",
			hint = "Color3.fromRGB",
		},

		[Enums.Color3Format.HSV] = {
			label = "HSV",
			hint = "Color3.fromHSV",
		},

		[Enums.Color3Format.Hex] = {
			label = "Hex",
			hint = "Color3.fromHex",
		},
	},
})
