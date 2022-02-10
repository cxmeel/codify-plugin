local Llama = require(script.Parent.Parent.Packages.Llama)
local Generators = require(script.Generators)
export type CodifyOptions = {
	Framework: string?, -- "Roact" | "Fusion"
	CreateMethod: string?,
	Color3Format: string?, -- "HEX" | "RGB"| "HSV" | "FULL"
	UDim2Format: string?, -- "FULL" | "SMART"
	EnumFormat: string?, -- "FULL" | "NUMBER" | "STRING"
	NamingScheme: string?, -- "ALL" | "NONE" | "CHANGED"
	TabCharacter: string?,
	Indent: number?,
}

type CodifyInstanceOptions = CodifyOptions & {
	PropIndent: number,
	LevelIdentifiers: {
		[string]: number,
	}?,
}

local DEFAULT_OPTIONS: CodifyOptions = {
	CreateMethod = "Roact.createElement",
	Color3Format = "FULL",
	UDim2Format = "FULL",
	EnumFormat = "FULL",
	NamingScheme = "ALL",
	TabCharacter = "  ",
	Indent = 0,
}

local function CodifyInstance(instance: Instance, options: CodifyInstanceOptions)
	local generator = Generators[options.Framework or "Roact"] or Generators["Roact"]
	local success, response = pcall(generator, instance, options)

	if success then
		return response
	else
		warn(response)
		return ""
	end
end

local function Codify(rootInstance: Instance, options: CodifyOptions?)
	local config = Llama.Dictionary.merge(DEFAULT_OPTIONS, options or {}, {
		LevelIdentifiers = {},
	}) :: CodifyInstanceOptions

	return "return " .. CodifyInstance(rootInstance, config)
end

return Codify
