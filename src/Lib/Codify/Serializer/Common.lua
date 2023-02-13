--!strict
local Sift = require(script.Parent.Parent.Sift)
local Array = Sift.Array

export type Options = {
	Formats: {
		[string]: string,
	},
}

export type Property = {
	Type: string,
	Value: any | {
		Type: string,
		Value: string,
	},
}

export type FormatterMap<T, F> = {
	DEFAULT: F,
	[F]: (value: T, options: Options) -> string,
}

--[[
	@prop BRICKCOLOR_CONVENIENCE_METHODS { [string]: BrickColor }
	@within SerializerCommon

	A map of convenience methods for BrickColor. This is used to
	convert BrickColor values to their convenience method
	representation.
]]
local BRICKCOLOR_CONVENIENCE_METHODS = {
	Black = BrickColor.Black(),
	Blue = BrickColor.Blue(),
	DarkGray = BrickColor.DarkGray(),
	Gray = BrickColor.Gray(),
	Green = BrickColor.Green(),
	Red = BrickColor.Red(),
	White = BrickColor.White(),
	Yellow = BrickColor.Yellow(),
}

--[[
	@prop PHYSICALPROPERTIES_FROM_MATERIAL { [Enum.Material]: string }
	@within SerializerCommon

	PhysicalProperties can be constructed from a material. This
	map is used to convert materials to their PhysicalProperties
	representation as a string.

	```lua
	local material = Enum.Material.Grass
	print(PHYSICALPROPERTIES_FROM_MATERIAL[material]) -- tostring(PhysicalProperties.new(Enum.Material.Grass))
	```
]]
local PHYSICALPROPERTIES_FROM_MATERIAL = Array.reduce(
	Enum.Material:GetEnumItems(),
	function(acc, material: Enum.Material)
		local materialProps = PhysicalProperties.new(material)
		acc[material] = tostring(materialProps)

		return acc
	end,
	{}
) :: { [Enum.Material]: string }

--[[
	@function FormatNumber
	@within SerializerCommon

	@param value number -- The number to format
	@param places number -- The number of decimal places to format to
	@return string

	Formats a number to a string. Numbers are formatted to three
	required places. Infinity is formatted to "math.huge" or
	"-math.huge" depending on the sign of the number.

	`places` defaults to 3 if not provided.

	```lua
	print(FormatNumber(1.23456789)) -- 1.23
	print(FormatNumber(1.23456789, 5)) -- 1.2346
	```
]]
local function FormatNumber(value: number, places: number?)
	if value == math.huge then
		return "math.huge"
	elseif value == -math.huge then
		return "-math.huge"
	end

	return (`%.{places or 3}g`):format(value)
end

--[[
	@function IndentValue
	@within SerializerCommon

	@param property string -- The property value to indent
	@param character string? -- The character to use for indentation (default: "\t")
	@param depth number? -- The depth to indent to (default: 0)
	@return string

	Indents a property value by a given depth. This is used to indent
	things like tables and values which span multiple lines.

	The depth is the base indentation level and will be incremented by
	one for each line between the first and last. The first line will
	not be indented.

	```lua
	local property = `{
		"Hello",
		"World",
	}`

	local indented = IndentValue(property, "\t", 1)

	print(indented)
	-- local property = { -- This is why the first line is not indented
	-- 	"Hello", 					-- Indented by depth + 1
	-- 	"World", 					-- Indented by depth + 1
	-- } 									-- Indented by depth
	```
]]
local function IndentValue(property: string, character: string?, depth: number?)
	if not property:find("\n") then
		return property
	end

	local lines = property:split("\n")

	character = character or "\t"
	depth = depth or 0

	local baseIndent = character:rep(depth)
	local indent = character:rep(depth + 1)

	if #lines > 2 then
		for index = 2, #lines - 1 do
			lines[index] = `{indent}{lines[index]}`
		end
	end

	lines[#lines] = `{baseIndent}{lines[#lines]}`

	return table.concat(lines, "\n")
end

return {
	BRICKCOLOR_CONVENIENCE_METHODS = BRICKCOLOR_CONVENIENCE_METHODS,
	PHYSICALPROPERTIES_FROM_MATERIAL = PHYSICALPROPERTIES_FROM_MATERIAL,

	FormatNumber = FormatNumber,
	IndentValue = IndentValue,
}
