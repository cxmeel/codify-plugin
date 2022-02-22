local TargetInstance = require(script.TargetInstance)
local PluginMetadata = require(script.PluginMetadata)
local UserSettings = require(script.UserSettings)
local Attribution = require(script.Attribution)
local Snippet = require(script.Snippet)

return function(state, action)
	state = state or {}

	return {
		targetInstance = TargetInstance(state.targetInstance, action),
		pluginMeta = PluginMetadata(state.pluginMetadata, action),
		userSettings = UserSettings(state.userSettings, action),
		attribution = Attribution(state.attribution, action),
		snippet = Snippet(state.snippet, action),
	}
end
