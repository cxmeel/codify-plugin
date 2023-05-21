local Plugin = script.Parent.Parent

local Sift = require(Plugin.Packages.Sift)
local String = require(Plugin.Lib.String)
local Enums = require(Plugin.Data.Enums)

local DEFAULT_SETTINGS = {
	syntaxHighlighting = true,
	brickColorFormat = Enums.BrickColorFormat.Smart,
	color3Format = Enums.Color3Format.RGB,
	enumFormat = Enums.EnumFormat.Full,
	framework = Enums.Framework.Regular,
	namingScheme = Enums.NamingScheme.All,
	numberRangeFormat = Enums.NumberRangeFormat.Smart,
	physicalPropertiesFormat = Enums.PhysicalPropertiesFormat.Smart,
	udim2Format = Enums.UDim2Format.Smart,
	indentationUsesTabs = false,
	indentationLength = 2,
	fontFormat = Enums.FontFormat.Full,
	caseFormat = Enums.CaseFormat.CAMELCASE,
	httpTimeout = 30,
}

return function(state, action)
	state = state or Sift.Dictionary.copy(DEFAULT_SETTINGS)

	if action.type == "SET_SETTING" then
		assert(type(action.payload) == "table", "SET_SETTING `payload` must be a table")
		assert(type(action.payload.key) == "string", "SET_SETTING `payload.key` must be a string")

		if type(action.payload.value) == "string" then
			local newValue = String.Trim(action.payload.value)

			if #newValue == 0 then
				newValue = DEFAULT_SETTINGS[action.payload.key] or Sift.None
			end

			action.payload.value = newValue
		elseif action.payload.value ~= nil then
			if action.payload.key == "indentationLength" then
				assert(type(action.payload.value) == "number", "SET_SETTING `payload.value` must be a number")
				action.payload.value = math.max(0, action.payload.value)
			end
		elseif action.payload.value == nil then
			action.payload.value = Sift.None
		end

		return Sift.Dictionary.merge(state, {
			[action.payload.key] = action.payload.value,
		})
	end

	return state
end
