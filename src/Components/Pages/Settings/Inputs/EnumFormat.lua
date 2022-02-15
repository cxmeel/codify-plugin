local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "Enum Format",
	hint = "Configure how Enum values are displayed in code snippets.",

	settingsKey = "enumFormat",

	enumMap = {
		[Enums.EnumFormat.Full] = {
			label = "Full",
			hint = "Enum.ScaleType.Fit",
		},

		[Enums.EnumFormat.Number] = {
			label = "Number",
			hint = "3",
		},

		[Enums.EnumFormat.String] = {
			label = "String",
			hint = '"Fit"',
		},
	},
})
