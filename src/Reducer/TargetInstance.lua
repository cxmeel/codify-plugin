return function(state, action)
	state = state or {
		instance = nil,
		large = false,
	}

	if action.type == "SET_TARGET_INSTANCE" then
		return {
			instance = action.payload,
		}
	end

	return state
end
