local Llama = require(script.Parent.Parent.Packages.Llama)

return function(state, action)
	state = state or {
		authors = {},
		contributors = {},
	}

	if action.type == "SET_CONTRIBUTORS" then
		assert(
			type(action.payload) == "table" or action.payload == nil,
			"SET_CONTRIBUTORS `action.payload` must be a table"
		)

		return Llama.Dictionary.merge(state, {
			contributors = action.payload or {},
		})
	elseif action.type == "SET_AUTHORS" then
		assert(type(action.payload) == "table" or action.payload == nil, "SET_AUTHORS `action.payload` must be a table")

		return Llama.Dictionary.merge(state, {
			authors = action.payload or {},
		})
	end

	return state
end
