return function(authors: { string })
	return {
		type = "SET_AUTHORS",
		payload = authors,
	}
end
