--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type FontFormat = "FULL" | "SMART"

local Formatter: Common.FormatterMap<Font, FontFormat> = {}

function Formatter.FULL(value)
	local isDefaultStyle = value.Style == Enum.FontStyle.Default
	local isDefaultWeight = value.Weight == Enum.FontWeight.Regular

	if isDefaultStyle and isDefaultWeight then
		return `new Font("{value.Family}")`
	end

	if isDefaultStyle then
		return `new Font("{value.Family}", Enum.FontWeight.{value.Weight.Name})`
	end

	return `new Font(\n"{value.Family}",\nEnum.FontWeight.{value.Weight.Name},\nEnum.FontStyle.{value.Style.Name}\n)`
end

function Formatter.SMART(value, options)
	local isDefaultStyle = value.Style == Enum.FontStyle.Default
	local isDefaultWeight = value.Weight == Enum.FontWeight.Regular

	local cloudFontId = value.Family:match("^rbxassetid://(%d+)$")
	local localFontName = value.Family:match("^rbxasset://.-/([%w_-]+)%.json$")

	if cloudFontId ~= nil then
		if isDefaultWeight and isDefaultStyle then
			return `Font.fromId({cloudFontId})`
		end

		if isDefaultStyle then
			return `Font.fromId({cloudFontId}, Enum.FontWeight.{value.Weight.Name})`
		end

		return `Font.fromId(\n{cloudFontId},\n Enum.FontWeight.{value.Weight.Name},\n Enum.FontStyle.{value.Style.Name}\n)`
	elseif localFontName ~= nil then
		if isDefaultWeight and isDefaultStyle then
			return `Font.fromName("{localFontName}")`
		end

		if isDefaultStyle then
			return `Font.fromName("{localFontName}", Enum.FontWeight.{value.Weight.Name})`
		end

		return `Font.fromName(\n"{localFontName}",\n Enum.FontWeight.{value.Weight.Name},\n Enum.FontStyle.{value.Style.Name}\n)`
	end

	return Formatter.FULL(value, options)
end

return Formatter
