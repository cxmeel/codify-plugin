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
	JsxTags: string?,
	NumberRangeFormat: string?,
	PhysicalPropertiesFormat: string?,
	TabCharacter: string?,
	Indent: number?,
	FontFormat: string?,
}

type CodifyInstanceOptions = CodifyOptions & {
	PropIndent: number,
	LevelIdentifiers: {
		[string]: number,
	}?,
}

type GuiTextObject = TextBox | TextLabel | TextButton

local function FormatNumber(value: number): string
	if value == math.huge then
		return "math.huge"
	elseif value == -math.huge then
		return "-math.huge"
	end

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
		Full = function(value: Color3, Jsx: boolean?)
			local red = clamp(value.R, 0, 1)
			local green = clamp(value.G, 0, 1)
			local blue = clamp(value.B, 0, 1)

			red = FormatNumber(red)
			green = FormatNumber(green)
			blue = FormatNumber(blue)

			if red == 0 and green == 0 and blue == 0 then
				return if Jsx then "new Color3()" else "Color3.new()"
			end

			local strFormat = if Jsx then "new Color3(%s, %s, %s)" else "Color3.new(%s, %s, %s)"
			return fmt(strFormat, red, green, blue)
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
		Full = function(value: UDim2, Jsx: boolean)
			local x = value.X.Scale
			local y = value.Y.Scale
			local ox = value.X.Offset
			local oy = value.Y.Offset

			if x == 0 and y == 0 and ox == 0 and oy == 0 then
				return if Jsx then "new UDim2" else "UDim2.new()"
			end

			local xs = FormatNumber(x)
			local ys = FormatNumber(y)
			local strFormat = if Jsx then "new UDim2(%s, %d, %s, %d)" else "UDim2.new(%s, %d, %s, %d)"

			return fmt(strFormat, xs, ox, ys, oy)
		end,

		Smart = function(value: UDim2, Jsx: boolean)
			local x = value.X.Scale
			local y = value.Y.Scale
			local ox = value.X.Offset
			local oy = value.Y.Offset

			local xs = FormatNumber(x)
			local ys = FormatNumber(y)

			if x == 0 and y == 0 and ox == 0 and oy == 0 then
				return if Jsx then "new UDim2" else "UDim2.new()"
			elseif x == 0 and y == 0 then
				return fmt("UDim2.fromOffset(%.0f, %.0f)", ox, oy)
			elseif ox == 0 and oy == 0 then
				return fmt("UDim2.fromScale(%s, %s)", xs, ys)
			end

			return FORMAT_MAP.UDim2Format.Full(value, Jsx)
		end,
	},

	NumberRangeFormat = {
		Full = function(value: NumberRange, Jsx: boolean)
			local strFormat = if Jsx then "new NumberRange(%s, %s)" else "NumberRange.new(%s, %s)"
			return fmt(strFormat, FormatNumber(value.Min), FormatNumber(value.Max))
		end,

		Smart = function(value: NumberRange, Jsx: boolean)
			if value.Max == value.Min then
				local strFormat = if Jsx then "new NumberRange(%s)" else "NumberRange.new(%s)"
				return fmt(strFormat, FormatNumber(value.Min))
			end

			return FORMAT_MAP.NumberRangeFormat.Full(value, Jsx)
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
		Full = function(value: Axes | Faces, className: string, Jsx: boolean?)
			local axes = {}

			for _, normalId in ipairs(Enum.NormalId:GetEnumItems()) do
				if value[normalId.Name] then
					table.insert(axes, FORMAT_MAP.EnumFormat.Full(normalId))
				end
			end
			local strFormat = if Jsx then "new %s(%s)" else "%s.new(%s)"
			return fmt(strFormat, className, table.concat(axes, ", "))
		end,
	},

	BrickColorFormat = {
		Name = function(value: BrickColor, Jsx: boolean)
			local strFormat = if Jsx then "new BrickColor(%q)" else "BrickColor.new(%q)"
			return fmt(strFormat, tostring(value))
		end,

		RGB = function(value: BrickColor, Jsx: boolean)
			local strFormat = if Jsx then "new BrickColor(%s, %s, %s)" else "BrickColor.new(%s, %s, %s)"
			return fmt(strFormat, FormatNumber(value.r), FormatNumber(value.g), FormatNumber(value.b))
		end,

		Number = function(value: BrickColor, Jsx: boolean)
			local strFormat = if Jsx then "new BrickColor(%d)" else "BrickColor.new(%d)"
			return fmt(strFormat, value.Number)
		end,

		Color3 = function(value: BrickColor, options: CodifyInstanceOptions?, Jsx: boolean?)
			local strFormat = if Jsx then "new BrickColor(%s)" else "BrickColor.new(%s)"
			local FormatColor3 = FORMAT_MAP.Color3Format[options and options.Color3Format or "Smart"]
			return fmt(strFormat, FormatColor3(value.Color, Jsx))
		end,

		Smart = function(value: BrickColor, Jsx: boolean?)
			for methodName, color in pairs(SHORT_BRICKCOLORS) do
				if value == color then
					return fmt("BrickColor.%s()", methodName)
				end
			end

			return FORMAT_MAP.BrickColorFormat.Name(value, Jsx)
		end,
	},

	PhysicalPropertiesFormat = {
		Full = function(value: PhysicalProperties, Jsx: boolean?)
			local props = {
				FormatNumber(value.Density),
				FormatNumber(value.Friction),
				FormatNumber(value.Elasticity),
				FormatNumber(value.FrictionWeight),
				FormatNumber(value.ElasticityWeight),
			}
			local strFormat = if Jsx then "new PhysicalProperties(%s)" else "PhysicalProperties.new(%s)"
			return fmt(strFormat, table.concat(props, ", "))
		end,

		Smart = function(value: PhysicalProperties, Jsx: boolean)
			local propsString = tostring(value)
			local strFormat = if Jsx then "new PhysicalProperties(%s)" else "PhysicalProperties.new(%s)"
			for material, materialPropsString in pairs(MATERIAL_PHYISCAL_PROPS) do
				if propsString == materialPropsString then
					return fmt(strFormat, FORMAT_MAP.EnumFormat.Full(material))
				end
			end

			return FORMAT_MAP.PhysicalPropertiesFormat.Full(value, Jsx)
		end,
	},

	UDimFormat = {
		Full = function(value: UDim, Jsx: boolean)
			local strFormat = if Jsx then "new UDim(%s, %s)" else "UDim.new(%s, %s)"
			return fmt(strFormat, FormatNumber(value.Scale), FormatNumber(value.Offset))
		end,
	},

	CFrameFormat = {
		Full = function(value: CFrame, Jsx)
			local strFormat = if Jsx then "new CFrame(%s)" else "CFrame.new(%s)"
			return fmt(strFormat, tostring(value))
		end,
	},

	VectorFormat = {
		Full = function(value: Vector2 | Vector3 | Vector2int16 | Vector3int16, Jsx: boolean)
			local elements = tostring(value):split(", ")

			for index, element in ipairs(elements) do
				elements[index] = FormatNumber(tonumber(element))
			end

			local strFormat = if Jsx then "new %s(%s)" else "%s.new(%s)"
			return fmt(strFormat, typeof(value), table.concat(elements, ", "))
		end,
	},

	FontFormat = {
		Full = function(instance: GuiTextObject, options: CodifyInstanceOptions, Jsx: boolean): string
			local value = instance.FontFace

			local isDefaultStyle = value.Style == Enum.FontStyle.Normal
			local isDefaultWeight = value.Weight == Enum.FontWeight.Regular
			local strFormat = if Jsx then "new Font(%q)" else "Font.new(%q)"

			if isDefaultStyle and isDefaultWeight then
				return fmt(strFormat, value.Family)
			end

			local baseIndent = rep(options.TabCharacter, options.Indent)
			local propIndent = rep(options.TabCharacter, options.Indent + 1)

			local fontProps = {
				fmt("%q", value.Family),
				fmt("Enum.FontWeight.%s", value.Weight.Name),
				fmt("Enum.FontStyle.%s", value.Style.Name),
			}
			local strAdvFormat = if Jsx
				then "new Font(\n%s%s,\n%s%s,\n%s%s\n%s)"
				else "Font.new(\n%s%s,\n%s%s,\n%s%s\n%s)"
			return fmt(
				strAdvFormat,
				propIndent,
				fontProps[1],
				propIndent,
				fontProps[2],
				propIndent,
				fontProps[3],
				baseIndent
			)
		end,

		Smart = function(instance: GuiTextObject, options: CodifyInstanceOptions, Jsx: boolean): string
			if instance.Font == Enum.Font.Unknown then
				return FORMAT_MAP.FontFormat.Full(instance, options, Jsx)
			end

			return fmt("Font.fromEnum(Enum.Font.%s)", instance.Font.Name)
		end,
	},
}

local function SerialiseColorSequence(sequence: ColorSequence, options: CodifyInstanceOptions, Jsx: boolean)
	local result = {}

	local baseIndent = rep(options.TabCharacter, options.Indent)
	local propIndent = rep(options.TabCharacter, options.Indent + 1)

	for _, keypoint in ipairs(sequence.Keypoints) do
		local value = keypoint.Value
		local time = keypoint.Time

		local valueString = FORMAT_MAP.Color3Format[options.Color3Format](value)
		local timeString = FormatNumber(time)
		local strFormat = if Jsx then "%snew ColorSequenceKeypoint(%s, %s)" else "%sColorSequenceKeypoint.new(%s, %s)"
		table.insert(result, fmt(strFormat, propIndent, timeString, valueString))
	end

	local resultString = table.concat(result, ",\n")
	local strFormat = if Jsx then "new ColorSequence({\n%s,\n%s})" else "ColorSequence.new({\n%s,\n%s})"
	return fmt(strFormat, resultString, baseIndent)
end

local function SerialiseNumberSequence(sequence: NumberSequence, options: CodifyInstanceOptions, Jsx: boolean)
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
			local strFormat = if Jsx
				then "%snew NumberSequenceKeypoint(%s, %s)"
				else "%sNumberSequenceKeypoint.new(%s, %s)"
			table.insert(result, fmt(strFormat, propIndent, timeString, valueString))
		else
			local envelopeString = FormatNumber(envelope)
			local strFormat = if Jsx
				then "%snew NumberSequenceKeypoint(%s, %s, %s)"
				else "%sNumberSequenceKeypoint.new(%s, %s, %s)"
			table.insert(result, fmt(strFormat, propIndent, timeString, valueString, envelopeString))
		end
	end

	local resultString = table.concat(result, ",\n")
	local strFormat = if Jsx then "new NumberSequence({\n%s,\n%s})" else "NumberSequence.new({\n%s,\n%s})"
	return fmt(strFormat, resultString, baseIndent)
end

local function SerialiseProperty(instance: Instance, property: string, options: CodifyInstanceOptions, Jsx: boolean?)
	local value = (instance :: any)[property]
	local valueTypeOf = typeof(value)
	local valueType = type(value)

	if valueTypeOf == "Color3" then
		return FORMAT_MAP.Color3Format[options.Color3Format or "Hex"](value, Jsx)
	elseif valueTypeOf == "BrickColor" then
		return FORMAT_MAP.BrickColorFormat[options.BrickColorFormat or "Smart"](value, Jsx)
	elseif valueTypeOf == "UDim" then
		return FORMAT_MAP.UDimFormat.Full(value, Jsx)
	elseif valueTypeOf == "UDim2" then
		return FORMAT_MAP.UDim2Format[options.UDim2Format or "Smart"](value, Jsx)
	elseif valueTypeOf == "NumberRange" then
		return FORMAT_MAP.NumberRangeFormat[options.NumberRangeFormat or "Smart"](value, Jsx)
	elseif valueTypeOf == "EnumItem" then
		return FORMAT_MAP.EnumFormat[options.EnumFormat or "Full"](value, Jsx)
	elseif valueTypeOf == "Axes" then
		return FORMAT_MAP.NormalIdConstructor.Full(value, "Axes", Jsx)
	elseif valueTypeOf == "Faces" then
		return FORMAT_MAP.NormalIdConstructor.Full(value, "Faces", Jsx)
	elseif valueTypeOf == "PhysicalProperties" then
		return FORMAT_MAP.PhysicalPropertiesFormat[options.PhysicalPropertiesFormat or "Smart"](value, Jsx)
	elseif valueTypeOf == "CFrame" then
		return FORMAT_MAP.CFrameFormat.Full(value, Jsx)
	elseif valueTypeOf == "ColorSequence" then
		return SerialiseColorSequence(value, options, Jsx)
	elseif valueTypeOf == "NumberSequence" then
		return SerialiseNumberSequence(value, options, Jsx)
	elseif valueTypeOf == "Font" then
		return FORMAT_MAP.FontFormat[options.FontFormat or "Full"](instance, options, Jsx)
	elseif valueTypeOf == "Instance" then
		return nil
	elseif valueType == "vector" or valueTypeOf:match("Vector%d") then
		return FORMAT_MAP.VectorFormat.Full(value, Jsx)
	elseif valueTypeOf == "number" then
		return FormatNumber(value)
	elseif valueTypeOf == "string" then
		local isMultiline = value:match("\n")

		if isMultiline then
			return if Jsx then fmt("`%s`", value:gsub("`", "\\`")) else fmt("[[%s]]", value:gsub("]]", "]\\]"))
		end

		return fmt("%q", value)
	elseif valueType == "userdata" then
		local stfFormat = if Jsx then "new %s(%s)" else "%s.new(%s)"

		return fmt(stfFormat, valueTypeOf, tostring(value))
	end

	return tostring(value)
end

return {
	SerialiseProperty = SerialiseProperty,
}
