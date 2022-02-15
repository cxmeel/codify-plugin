local Plugin = script.Parent.Parent

local Promise = require(Plugin.Packages.Promise)

local Codify = require(Plugin.Lib.Codify)
local Actions = require(Plugin.Actions)

local DEPRECATE_STORE = require(Plugin.Store)

local CodifyAsync = Promise.promisify(Codify)

local function GenerateSnippet()
	return function(store)
		local state = store:getState()

		if not state.targetInstance.instance or state.snippet.processing then
			return
		end

		store:dispatch(Actions.SetSnippetProcessing(true))

		local DEPRECATE_STATE = DEPRECATE_STORE:Get("Settings", {})

		CodifyAsync(state.targetInstance.instance, {
			Framework = DEPRECATE_STATE.Framework,
			CreateMethod = DEPRECATE_STATE.CreateMethod,
			Color3Format = DEPRECATE_STATE.Color3Format,
			UDim2Format = DEPRECATE_STATE.UDim2Format,
			NumberRangeFormat = DEPRECATE_STATE.NumberRangeFormat,
			EnumFormat = DEPRECATE_STATE.EnumFormat,
			NamingScheme = DEPRECATE_STATE.NamingScheme,
		})
			:andThen(function(snippet)
				store:dispatch(Actions.SetSnippetContent({
					name = state.targetInstance.instance.Name,
					content = snippet,
				}))
			end)
			:catch(function() -- fail silently
				return false
			end)
			:finally(function()
				store:dispatch(Actions.SetSnippetProcessing(false))
			end)
	end
end

return GenerateSnippet
