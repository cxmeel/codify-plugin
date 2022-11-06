local Sift = require(script.Parent.Parent.Packages.Sift)
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
	PhysicalPropertiesFormat: string?,
	BrickColorFormat: string?,
	FontFormat: string?,

	ChildrenKey: string?, -- customise Fusion's [Children] key
}

type CodifyInstanceOptions = CodifyOptions & {
	PropIndent: number,
	LevelIdentifiers: {
		[string]: number,
	}?,
}

local DEFAULT_OPTIONS: CodifyOptions = {
	Framework = "Regular",
	NamingScheme = "All",
	TabCharacter = "  ",
	Indent = 0,
}

local function CodifyInstance(instance: Instance, options: CodifyInstanceOptions)
	local generator = Frameworks[options.Framework].Generator
	return generator(instance, options)
end

local function Codify(rootInstance: Instance, options: CodifyOptions?)
	local config = Sift.Dictionary.merge(DEFAULT_OPTIONS, options or {}, {
		LevelIdentifiers = {},
	}) :: CodifyInstanceOptions

	return (config.Framework ~= "Regular" and "return " or "") .. CodifyInstance(rootInstance, config)
end

return Codify
