local Plugin = script.Parent.Parent

local Promise = require(Plugin.Packages.Promise)

local Codify = require(Plugin.Lib.Codify)
local String = require(Plugin.Lib.String)
local Actions = require(Plugin.Actions)

local CodifyAsync = Promise.promisify(Codify)

local function GenerateSnippet()
	return function(store)
		local state = store:getState()

		if not state.targetInstance.instance or state.snippet.processing then
			return
		end

		store:dispatch(Actions.SetSnippetProcessing(true))

		local tabCharacter = if state.userSettings.indentationUsesTabs
			then "\t"
			else string.rep(" ", state.userSettings.indentationLength or 2)

		CodifyAsync(state.targetInstance.instance, {
				Framework = state.userSettings.framework,
				CreateMethod = state.userSettings["createMethod" .. state.userSettings.framework],
				Color3Format = state.userSettings.color3Format,
				UDim2Format = state.userSettings.udim2Format,
				NumberRangeFormat = state.userSettings.numberRangeFormat,
				EnumFormat = state.userSettings.enumFormat,
				NamingScheme = state.userSettings.namingScheme,
				PhysicalPropertiesFormat = state.userSettings.physicalPropertiesFormat,
				BrickColorFormat = state.userSettings.brickColorFormat,
				ChildrenKey = state.userSettings["childrenKey" .. state.userSettings.framework],
				TabCharacter = tabCharacter,
				FontFormat = state.userSettings.fontFormat,
			})
			:andThen(function(snippet)
				store:dispatch(Actions.SetSnippetContent({
					name = state.targetInstance.instance.Name,
					content = String.Trim(snippet),
				}))

				store:dispatch(Actions.SetSnippetError(nil))
			end)
			:catch(function(rejection)
				local errorText = tostring(rejection.error)
				store:dispatch(Actions.SetSnippetError(errorText))
			end)
			:finally(function()
				store:dispatch(Actions.SetSnippetProcessing(false))
			end)
	end
end

return GenerateSnippet
