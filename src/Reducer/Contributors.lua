return function(state, action)
	state = state or {}

	if action.type == "SET_CONTRIBUTORS" then
		assert(
			type(action.payload) == "table" or action.payload == nil,
			"SET_CONTRIBUTORS `action.payload` must be a table"
		)

		return action.payload or {}
	end

	return state
end
