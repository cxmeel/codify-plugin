local String = {}

function String.Trim(value: string)
	local result = value:match("^%s*(.-)%s*$")
	return result
end

return String
