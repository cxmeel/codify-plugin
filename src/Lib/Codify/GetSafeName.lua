local split = string.split
local match = string.match
local lower = string.lower
local gsub = string.gsub
local sub = string.sub

local DICTIONARY = split("abcdefghijklmnopqrstuvwxyz", "")

local function CreateSafeName(name: string)
	local firstChar = utf8.codepoint(sub(name, 1, 1))
	local rest = gsub(sub(name, 2), "[^%w]", "_")

	return DICTIONARY[firstChar % #DICTIONARY] .. rest
end

local function GetSafeName(instance: Instance)
	local name = instance.Name

	local matchedSafeName = { match(name, "([%a_])(.+)") }
	local safeName

	if #matchedSafeName == 2 then
		safeName = lower(matchedSafeName[1]) .. matchedSafeName[2]
		safeName = gsub(safeName, "[^%w_]", "_")
	elseif match(name, "([%a_])") then
		safeName = lower(name)
	else
		safeName = CreateSafeName(name)
	end

	return safeName
end

return GetSafeName
