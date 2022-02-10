local Llama = require(script.Parent.Parent.Packages.Llama)

local Properties = require(script.Parent.Properties)
local Script = require(script.Script)

local rep = string.rep
local fmt = string.format
local clamp = math.clamp

export type RoactifyOptions = {
	CreateMethod: string?,
	Color3Format: string?, -- "HEX" | "RGB"| "HSV" | "FULL"
	UDim2Format: string?, -- "FULL" | "SMART"
	EnumFormat: string?, -- "FULL" | "NUMBER" | "STRING"
	NamingScheme: string?, -- "ALL" | "NONE" | "CHANGED"
	TabCharacter: string?,
	Indent: number?,
}

type RoactifyInstanceOptions = RoactifyOptions & {
	PropIndent: number,
	LevelIdentifiers: {
		[string]: number,
	}?,
}

local DEFAULT_OPTIONS: RoactifyOptions = {
	CreateMethod = "Roact.createElement",
	Color3Format = "FULL",
	UDim2Format = "FULL",
	EnumFormat = "FULL",
	NamingScheme = "ALL",
	TabCharacter = "  ",
	Indent = 0,
}

local function FormatNumber(value: number): string
	return fmt("%.3g", value)
end

local FORMAT_MAP
FORMAT_MAP = {
	Color3Format = {
		FULL = function(value: Color3)
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

		HEX = function(value: Color3)
			local hex = value:ToHex()
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
		FULL = function(value: UDim2)
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

		SMART = function(value: UDim2)
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

			return FORMAT_MAP.UDim2Format.FULL(value)
		end,
	},

	EnumFormat = {
		FULL = tostring,

		NUMBER = function(value: EnumItem)
			return value.Value
		end,

		STRING = function(value: EnumItem)
			return fmt("%q", value.Name)
		end,
	},
}

local function SerialiseColorSequence(sequence: ColorSequence, options: RoactifyInstanceOptions)
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

local function SerialiseNumberSequence(sequence: NumberSequence, options: RoactifyInstanceOptions)
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

local function SerialiseProperty(instance: Instance, property: string, options: RoactifyInstanceOptions)
	local value = instance[property] :: any
	local valueTypeOf = typeof(value)
	local valueType = type(value)

	if valueTypeOf == "Color3" then
		return FORMAT_MAP.Color3Format[options.Color3Format](value)
	elseif valueTypeOf == "UDim2" then
		return FORMAT_MAP.UDim2Format[options.UDim2Format](value)
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

local function RoactifyInstance(instance: Instance, options: RoactifyInstanceOptions)
	local snippet = Script.new()

	local changedProps = select(2, Properties.GetChangedProperties(instance):await())
	local children = instance:GetChildren()

	local function tab()
		return rep(options.TabCharacter, options.Indent)
	end

	snippet:CreateLine():Push(options.CreateMethod, '("', instance.ClassName, '"')

	if options.Indent > 0 then
		local nameChanged = table.find(changedProps, "Name")
		local name = instance.Name

		if options.NamingScheme == "ALL" or (options.NamingScheme == "CHANGED" and nameChanged) then
			name = name:sub(1, 1):lower() .. name:sub(2)
		elseif options.NamingScheme == "NONE" or (options.NamingScheme == "CHANGED" and not nameChanged) then
			name = nil
		end

		if name ~= nil then
			if options.LevelIdentifiers[name] ~= nil then
				options.LevelIdentifiers[name] += 1
				name ..= tostring(options.LevelIdentifiers[name])
			else
				options.LevelIdentifiers[name] = 0
			end

			snippet:Line():Insert(1, name, " = ")
		end
	end

	if #changedProps > 0 then
		snippet:Line():Push(", {")
		options.Indent += 1

		for _, prop in ipairs(changedProps) do
			if prop == "Name" then
				continue
			end

			options.PropIndent = #prop + 3

			local value = SerialiseProperty(instance, prop, options)
			snippet:CreateLine():Push(tab(), prop, " = ", value, ",")
		end

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), "}")
	end

	if #children > 0 then
		snippet:Line():Push(", {")
		options.Indent += 1

		for _, child in ipairs(children) do
			snippet:CreateLine():Push(tab(), RoactifyInstance(child, options), ",")
		end

		options.Indent -= 1
		snippet:CreateLine():Push(tab(), "}")
	end

	snippet:Line():Push(")")

	return snippet:Concat()
end

local function Roactify(rootInstance: Instance, options: RoactifyOptions?)
	local config = Llama.Dictionary.merge(DEFAULT_OPTIONS, options or {}, {
		LevelIdentifiers = {},
	}) :: RoactifyInstanceOptions

	return "return " .. RoactifyInstance(rootInstance, config)
end

return Roactify
