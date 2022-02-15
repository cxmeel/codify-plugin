local rep = string.rep
local fmt = string.format
local clamp = math.clamp

type CodifyOptions = {
	Framework: string?,
	CreateMethod: string?,
	Color3Format: string?,
	UDim2Format: string?,
	EnumFormat: string?,
	NamingScheme: string?,
	NumberRangeFormat: string?,
	TabCharacter: string?,
	Indent: number?,
}

type CodifyInstanceOptions = CodifyOptions & {
	PropIndent: number,
	LevelIdentifiers: {
		[string]: number,
	}?,
}

local function FormatNumber(value: number): string
	return fmt("%.3g", value)
end

local FORMAT_MAP
FORMAT_MAP = {
	Color3Format = {
		Full = function(value: Color3)
			local red = clamp(value.R, 0, 1)
			local green = clamp(value.G, 0, 1)
			local blue = clamp(value.B, 0, 1)

			red = FormatNumber(red)
			green = FormatNumber(green)
			blue = FormatNumber(blue)

			if red == 0 and green == 0 and blue == 0 then
				return "Color3.new()"
			end

			return fmt("Color3.new(%s, %s, %s)", red, green, blue)
		end,

		Hex = function(value: Color3)
			local hex: string = (value :: any):ToHex()
			return fmt('Color3.fromHex("#%s")', hex:upper())
		end,

		RGB = function(value: Color3)
			local red = clamp(value.R * 255, 0, 255)
			local green = clamp(value.G * 255, 0, 255)
			local blue = clamp(value.B * 255, 0, 255)

			return fmt("Color3.fromRGB(%.0f, %.0f, %.0f)", red, green, blue)
		end,

		HSV = function(value: Color3)
			local hsv = { value:ToHSV() }

			local h = clamp(hsv[1], 0, 1)
			local s = clamp(hsv[2], 0, 1)
			local v = clamp(hsv[3], 0, 1)

			h = FormatNumber(h)
			s = FormatNumber(s)
			v = FormatNumber(v)

			return fmt("Color3.fromHSV(%s, %s, %s)", h, s, v)
		end,
	},

	UDim2Format = {
		Full = function(value: UDim2)
			local x = clamp(value.X.Scale, 0, 1)
			local y = clamp(value.Y.Scale, 0, 1)
			local ox = value.X.Offset
			local oy = value.Y.Offset

			if x == 0 and y == 0 and ox == 0 and oy == 0 then
				return "UDim2.new()"
			end

			local xs = FormatNumber(x)
			local ys = FormatNumber(y)

			return fmt("UDim2.new(%s, %d, %s, %d)", xs, ox, ys, oy)
		end,

		Smart = function(value: UDim2)
			local x = clamp(value.X.Scale, 0, 1)
			local y = clamp(value.Y.Scale, 0, 1)
			local ox = value.X.Offset
			local oy = value.Y.Offset

			local xs = FormatNumber(x)
			local ys = FormatNumber(y)

			if x == 0 and y == 0 and ox == 0 and oy == 0 then
				return "UDim2.new()"
			elseif x == 0 and y == 0 then
				return fmt("UDim2.fromOffset(%.0f, %.0f)", ox, oy)
			elseif ox == 0 and oy == 0 then
				return fmt("UDim2.fromScale(%s, %s)", xs, ys)
			end

			return FORMAT_MAP.UDim2Format.Full(value)
		end,
	},

	NumberRangeFormat = {
		Full = function(value: NumberRange)
			return fmt("NumberRange.new(%s, %s)", FormatNumber(value.Min), FormatNumber(value.Max))
		end,

		Smart = function(value: NumberRange)
			if value.Max == value.Min then
				return fmt("NumberRange.new(%s)", FormatNumber(value.Min))
			end

			return fmt("NumberRange.new(%s, %s)", FormatNumber(value.Min), FormatNumber(value.Max))
		end,
	},

	EnumFormat = {
		Full = tostring,

		Number = function(value: EnumItem)
			return value.Value
		end,

		String = function(value: EnumItem)
			return fmt("%q", value.Name)
		end,
	},
}

local function SerialiseColorSequence(sequence: ColorSequence, options: CodifyInstanceOptions)
	local result = {}

	local baseIndent = rep(options.TabCharacter, options.Indent)
	local propIndent = rep(options.TabCharacter, options.Indent + 1)

	for _, keypoint in ipairs(sequence.Keypoints) do
		local value = keypoint.Value
		local time = keypoint.Time

		local valueString = FORMAT_MAP.Color3Format[options.Color3Format](value)
		local timeString = FormatNumber(time)

		table.insert(result, fmt("%sColorSequenceKeypoint.new(%s, %s)", propIndent, timeString, valueString))
	end

	local resultString = table.concat(result, ",\n")

	return fmt("ColorSequence.new({\n%s,\n%s})", resultString, baseIndent)
end

local function SerialiseNumberSequence(sequence: NumberSequence, options: CodifyInstanceOptions)
	local result = {}

	local baseIndent = rep(options.TabCharacter, options.Indent)
	local propIndent = rep(options.TabCharacter, options.Indent + 1)

	for _, keypoint in ipairs(sequence.Keypoints) do
		local envelope = keypoint.Envelope
		local value = keypoint.Value
		local time = keypoint.Time

		local valueString = FormatNumber(value)
		local timeString = FormatNumber(time)

		if envelope == 0 then
			table.insert(result, fmt("%sNumberSequenceKeypoint.new(%s, %s)", propIndent, timeString, valueString))
		else
			local envelopeString = FormatNumber(envelope)

			table.insert(
				result,
				fmt("%sNumberSequenceKeypoint.new(%s, %s, %s)", propIndent, timeString, valueString, envelopeString)
			)
		end
	end

	local resultString = table.concat(result, ",\n")

	return fmt("NumberSequence.new({\n%s,\n%s})", resultString, baseIndent)
end

local function SerialiseProperty(instance: Instance, property: string, options: CodifyInstanceOptions)
	local value = instance[property] :: any
	local valueTypeOf = typeof(value)
	local valueType = type(value)

	if valueTypeOf == "Color3" then
		return FORMAT_MAP.Color3Format[options.Color3Format](value)
	elseif valueTypeOf == "UDim2" then
		return FORMAT_MAP.UDim2Format[options.UDim2Format](value)
	elseif valueTypeOf == "NumberRange" then
		return FORMAT_MAP.NumberRangeFormat[options.NumberRangeFormat](value)
	elseif valueTypeOf == "EnumItem" then
		return FORMAT_MAP.EnumFormat[options.EnumFormat](value)
	elseif valueTypeOf == "ColorSequence" then
		return SerialiseColorSequence(value, options)
	elseif valueTypeOf == "NumberSequence" then
		return SerialiseNumberSequence(value, options)
	elseif valueTypeOf == "number" then
		return FormatNumber(value)
	elseif valueTypeOf == "string" then
		return fmt("%q", value)
	elseif valueType == "userdata" then
		return fmt("%s.new(%s)", valueTypeOf, tostring(value))
	end

	return tostring(value)
end

return {
	SerialiseProperty = SerialiseProperty,
}
