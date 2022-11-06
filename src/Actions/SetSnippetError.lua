return function(errorText: string | nil)
	return {
		type = "SET_SNIPPET_ERROR",
		payload = errorText,
	}
end
