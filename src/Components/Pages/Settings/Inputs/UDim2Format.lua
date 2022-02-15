local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "UDim2 Format",
	hint = "Configure how UDim2 values are displayed in code snippets.",

	settingsKey = "udim2Format",

	enumMap = {
		[Enums.UDim2Format.Full] = {
			label = "Full",
			hint = "UDim2.new",
		},

		[Enums.UDim2Format.Smart] = {
			label = "Smart",
			hint = "UDim2.fromScale, fromOffset",
		},
	},
})
