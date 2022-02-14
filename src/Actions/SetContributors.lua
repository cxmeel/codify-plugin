return function(contributors: { string })
	return {
		type = "SET_CONTRIBUTORS",
		payload = contributors,
	}
end
