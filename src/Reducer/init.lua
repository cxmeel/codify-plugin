local Attribution = require(script.Attribution)
local Snippet = require(script.Snippet)
local TargetInstance = require(script.TargetInstance)
local UserSettings = require(script.UserSettings)

return function(state, action)
	state = state or {}

	return {
		attribution = Attribution(state.attribution, action),
		snippet = Snippet(state.snippet, action),
		targetInstance = TargetInstance(state.targetInstance, action),
		userSettings = UserSettings(state.userSettings, action),
	}
end
