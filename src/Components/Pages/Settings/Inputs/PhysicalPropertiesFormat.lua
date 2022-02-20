local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "PhysicalProperties Format",
	hint = "Configure how custom PhysicalProperties are displayed in code snippets.",

	settingsKey = "physicalPropertiesFormat",

	enumMap = {
		[Enums.PhysicalPropertiesFormat.Full] = {
			label = "Full",
			hint = "PhysicalProperties.new(1, 2, 3, 4, 5)",
		},

		[Enums.PhysicalPropertiesFormat.Smart] = {
			label = "Smart",
			hint = "PhysicalProperties.new(Enum.Material.Grass)",
		},
	},
})
