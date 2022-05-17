local rep = string.rep
local fmt = string.format
local clamp = math.clamp

type CodifyOptions = {
	Framework: string?,
	CreateMethod: string?,
	BrickColorFormat: string?,
	Color3Format: string?,
	UDim2Format: string?,
	EnumFormat: string?,
	NamingScheme: string?,
	NumberRangeFormat: string?,
	PhysicalPropertiesFormat: string?,
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

local SHORT_BRICKCOLORS = {
	White = BrickColor.White(),
	Gray = BrickColor.Gray(),
	DarkGray = BrickColor.DarkGray(),
	Black = BrickColor.Black(),
	Red = BrickColor.Red(),
	Yellow = BrickColor.Yellow(),
	Green = BrickColor.Green(),
	Blue = BrickColor.Blue(),
}

local MATERIAL_PHYISCAL_PROPS: { [Enum.Material]: string } = {}

do
	for _, material in ipairs(Enum.Material:GetEnumItems()) do
		local materialProps = PhysicalProperties.new(material)
		MATERIAL_PHYISCAL_PROPS[material] = tostring(materialProps)
	end
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
			local x = value.X.Scale
			local y = value.Y.Scale
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
			local x = value.X.Scale
			local y = value.Y.Scale
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

	NormalIdConstructor = {
		Full = function(value: Axes | Faces, className: string)
			local axes = {}

			for _, normalId in ipairs(Enum.NormalId:GetEnumItems()) do
				if value[normalId.Name] then
					table.insert(axes, FORMAT_MAP.EnumFormat.Full(normalId))
				end
			end

			return fmt("%s.new(%s)", className, table.concat(axes, ", "))
		end,
	},

	BrickColorFormat = {
		Name = function(value: BrickColor)
			return fmt("BrickColor.new(%q)", tostring(value))
		end,

		RGB = function(value: BrickColor)
			return fmt(
				"BrickColor.new(%s, %s, %s)",
				FormatNumber(value.r),
				FormatNumber(value.g),
				FormatNumber(value.b)
			)
		end,

		Number = function(value: BrickColor)
			return fmt("BrickColor.new(%d)", value.Number)
		end,

		Color3 = function(value: BrickColor, options: CodifyInstanceOptions?)
			local FormatColor3 = FORMAT_MAP.Color3Format[options and options.Color3Format or "Smart"]
			return fmt("BrickColor3.new(%s)", FormatColor3(value.Color))
		end,

		Smart = function(value: BrickColor)
			for methodName, colour in pairs(SHORT_BRICKCOLORS) do
				if value == colour then
					return fmt("BrickColor.%s()", methodName)
				end
			end

			return FORMAT_MAP.BrickColorFormat.Name(value)
		end,
	},

	PhysicalPropertiesFormat = {
		Full = function(value: PhysicalProperties)
			local props = {
				FormatNumber(value.Density),
				FormatNumber(value.Friction),
				FormatNumber(value.Elasticity),
				FormatNumber(value.FrictionWeight),
				FormatNumber(value.ElasticityWeight),
			}

			return fmt("PhysicalProperties.new(%s)", table.concat(props, ", "))
		end,

		Smart = function(value: PhysicalProperties)
			local propsString = tostring(value)

			for material, materialPropsString in pairs(MATERIAL_PHYISCAL_PROPS) do
				if propsString == materialPropsString then
					return fmt("PhysicalProperties.new(%s)", FORMAT_MAP.EnumFormat.Full(material))
				end
			end

			return FORMAT_MAP.PhysicalPropertiesFormat.Full(value)
		end,
	},

	UDimFormat = {
		Full = function(value: UDim)
			return fmt("UDim.new(%s, %s)", FormatNumber(value.Scale), FormatNumber(value.Offset))
		end,
	},

	CFrameFormat = {
		Full = function(value: CFrame)
			return fmt("CFrame.new(%s)", tostring(value))
		end,
	},

	VectorFormat = {
		Full = function(value: Vector2 | Vector3 | Vector2int16 | Vector3int16)
			local elements = tostring(value):split(", ")

			for index, element in ipairs(elements) do
				elements[index] = FormatNumber(tonumber(element))
			end

			return fmt("%s.new(%s)", typeof(value), table.concat(elements, ", "))
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
		return FORMAT_MAP.Color3Format[options.Color3Format or "Hex"](value)
	elseif valueTypeOf == "BrickColor" then
		return FORMAT_MAP.BrickColorFormat[options.BrickColorFormat or "Smart"](value)
	elseif valueTypeOf == "UDim" then
		return FORMAT_MAP.UDimFormat.Full(value)
	elseif valueTypeOf == "UDim2" then
		return FORMAT_MAP.UDim2Format[options.UDim2Format or "Smart"](value)
	elseif valueTypeOf == "NumberRange" then
		return FORMAT_MAP.NumberRangeFormat[options.NumberRangeFormat or "Smart"](value)
	elseif valueTypeOf == "EnumItem" then
		return FORMAT_MAP.EnumFormat[options.EnumFormat or "Full"](value)
	elseif valueTypeOf == "Axes" then
		return FORMAT_MAP.NormalIdConstructor.Full(value, "Axes")
	elseif valueTypeOf == "Faces" then
		return FORMAT_MAP.NormalIdConstructor.Full(value, "Faces")
	elseif valueTypeOf == "PhysicalProperties" then
		return FORMAT_MAP.PhysicalPropertiesFormat[options.PhysicalPropertiesFormat or "Smart"](value)
	elseif valueTypeOf == "CFrame" then
		return FORMAT_MAP.CFrameFormat.Full(value)
	elseif valueTypeOf == "ColorSequence" then
		return SerialiseColorSequence(value, options)
	elseif valueTypeOf == "NumberSequence" then
		return SerialiseNumberSequence(value, options)
	elseif valueTypeOf == "Instance" then
		return nil
	elseif valueType == "vector" or valueTypeOf:match("Vector%d") then
		return FORMAT_MAP.VectorFormat.Full(value)
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
