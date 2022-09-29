local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "Font Format",
	hint = "Configure how FontFace values are displayed in code snippets.",

	settingsKey = "fontFormat",

	enumMap = {
		[Enums.FontFormat.Full] = {
			label = "Full",
			hint = "Font.new",
		},

		[Enums.FontFormat.Smart] = {
			label = "Smart",
			hint = "Font.fromEnum, Font.new",
		},
	},
})
