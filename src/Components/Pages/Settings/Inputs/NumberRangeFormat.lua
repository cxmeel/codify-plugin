local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "NumberRange Format",
	hint = "Configure how NumberRange values are displayed in code snippets.",

	settingsKey = "numberRangeFormat",

	enumMap = {
		[Enums.NumberRangeFormat.Full] = {
			label = "Full",
			hint = "NumberRange.new(x, y)",
		},

		[Enums.NumberRangeFormat.Smart] = {
			label = "Smart",
			hint = "NumberRange.new(n)",
		},
	},
})
