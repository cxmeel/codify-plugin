local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "Child Indexing",
	hint = "Configure how child Instance indices are generated.",

	settingsKey = "namingScheme",

	enumMap = {
		[Enums.NamingScheme.All] = {
			label = "All",
			hint = "frame, textButton",
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
