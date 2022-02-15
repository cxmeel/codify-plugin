local Llama = require(script.Parent.Parent.Packages.Llama)
local Frameworks = require(script.Frameworks)
export type CodifyOptions = {
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

local DEFAULT_OPTIONS: CodifyOptions = {
	Framework = "Regular",
	CreateMethod = nil,
	Color3Format = "FULL",
	UDim2Format = "FULL",
	EnumFormat = "FULL",
	NamingScheme = "ALL",
	TabCharacter = "  ",
	Indent = 0,
}

local function CodifyInstance(instance: Instance, options: CodifyInstanceOptions)
	local generator = Frameworks[options.Framework].Generator
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

	return (options.Framework ~= "Regular" and "return " or "") .. CodifyInstance(rootInstance, config)
end

return Codify
