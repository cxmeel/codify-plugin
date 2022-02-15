type SetSnippetContentPayload = {
	content: string,
	name: string,
}

return function(content: SetSnippetContentPayload)
	return {
		type = "SET_SNIPPET_CONTENT",
		payload = content,
	}
end
