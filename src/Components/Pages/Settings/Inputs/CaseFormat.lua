local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Enums = require(Plugin.Data.Enums)
local CreateInput = require(script.Parent.CreateInput)

return CreateInput({
	heading = "Case Format",
	hint = "Configure the case format used when generating variable names.",

	settingsKey = "caseFormat",

	enumMap = {
		[Enums.CaseFormat.CAMELCASE] = { label = "camelCase" },
		[Enums.CaseFormat.LOWERCASE] = { label = "lowercase" },
		[Enums.CaseFormat.PASCALCASE] = { label = "PascalCase" },
		[Enums.CaseFormat.UPPERCASE] = { label = "UPPERCASE" },
	},
})
