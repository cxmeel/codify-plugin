local Contributors = require(script.Contributors)

return function(state, action)
	state = state or {}

	return {
		contributors = Contributors(state.contributors, action),
	}
end
