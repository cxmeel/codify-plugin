local Llama = require(script.Parent.Parent.Packages.Llama)

return function(state, action)
	state = state or {
		name = nil,
		content = nil,
		processing = false,
	}

	if action.type == "SET_SNIPPET_PROCESSING" then
		assert(type(action.payload) == "boolean", "SET_SNIPPET_PROCESSING `action.payload` must be a boolean")

		return Llama.Dictionary.merge(state, {
			processing = action.payload,
		})
	elseif action.type == "SET_SNIPPET_CONTENT" then
		assert(type(action.payload) == "table", "SET_SNIPPET_CONTENT `action.payload` must be a table")
		assert(type(action.payload.name) == "string", "SET_SNIPPET_CONTENT `action.payload.name` must be a string")

		assert(
			type(action.payload.content) == "string",
			"SET_SNIPPET_CONTENT `action.payload.content` must be a string"
		)

		return Llama.Dictionary.merge(state, {
			content = action.payload.content,
			name = action.payload.name,
		})
	end

	return state
end
