local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "Child Instance Keys",
	anchor = "format-namingscheme",
	hint = "Determines how to assign child Instance names/keys.",

	settingsKey = "namingScheme",

	enumMap = {
		[Enums.NamingScheme.All] = {
			label = "All",
			hint = "frame, myButton",
		},

		[Enums.NamingScheme.Changed] = {
			label = "Changed",
			hint = "myButton",
		},

		[Enums.NamingScheme.None] = {
			label = "None",
		},
	},
})
