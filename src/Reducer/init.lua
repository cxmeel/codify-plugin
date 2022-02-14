local Attribution = require(script.Attribution)

return function(state, action)
	state = state or {}

	return {
		attribution = Attribution(state.attribution, action),
	}
end
