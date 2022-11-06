local Sift = require(script.Parent.Parent.Packages.Sift)

local fmt = string.format

local ERROR_TEMPLATES = {
	SET_SNIPPET_PROCESSING = "SET_SNIPPET_PROCESSING `action.payload` must be a boolean, got %q (%s)",
	SET_SNIPPET_CONTENT = {
		BASE = "SET_SNIPPET_CONTENT `action.payload` must be a table, got %q (%s)",
		NAME = "SET_SNIPPET_CONTENT `action.payload.name` must be a string, got %q (%s)",
		CONTENT = "SET_SNIPPET_CONTENT `action.payload.content` must be a string, got %q (%s)",
	},
	SET_SNIPPET_ERROR = "SET_SNIPPET_ERROR `action.payload` must be a string | nil, got %q (%s)",
}

return function(state, action)
	state = state or {
		name = nil,
		content = nil,
		processing = false,
		error = nil,
	}

	if action.type == "SET_SNIPPET_PROCESSING" then
		assert(
			type(action.payload) == "boolean",
			fmt(ERROR_TEMPLATES.SET_SNIPPET_PROCESSING, tostring(action.payload), typeof(action.payload))
		)

		return Sift.Dictionary.merge(state, {
			processing = action.payload,
		})
	elseif action.type == "SET_SNIPPET_CONTENT" then
		assert(
			type(action.payload) == "table",
			fmt(ERROR_TEMPLATES.SET_SNIPPET_CONTENT.BASE, tostring(action.payload), typeof(action.payload))
		)

		assert(
			type(action.payload.name) == "string",
			fmt(ERROR_TEMPLATES.SET_SNIPPET_CONTENT.NAME, tostring(action.payload.name), typeof(action.payload.name))
		)

		assert(
			type(action.payload.content) == "string",
			fmt(
				ERROR_TEMPLATES.SET_SNIPPET_CONTENT.CONTENT,
				tostring(action.payload.content),
				typeof(action.payload.content)
			)
		)

		return Sift.Dictionary.merge(state, {
			content = action.payload.content,
			name = action.payload.name,
		})
	elseif action.type == "SET_SNIPPET_ERROR" then
		assert(
			type(action.payload) == "string" or type(action.payload) == "nil",
			fmt(ERROR_TEMPLATES.SET_SNIPPET_ERROR, tostring(action.payload), typeof(action.payload))
		)

		return Sift.Dictionary.merge(state, {
			error = action.payload or Sift.None,
		})
	end

	return state
end
