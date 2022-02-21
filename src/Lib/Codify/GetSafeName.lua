local lower = string.lower
local find = string.find
local gsub = string.gsub
local sub = string.sub

local function GetSafeName(instance: Instance)
	local name = instance.Name

	local firstChar = find(name, "^%a")
	local prefix = lower(sub(name, firstChar, firstChar))
	local suffix = sub(name, firstChar + 1)

	local safeName = gsub(prefix .. suffix, "[^%w]", "_")

	return safeName
end

return GetSafeName
