--!strict
local Packages = script.Parent.Parent.Packages

local DumpParser = require(Packages.DumpParser)
local Packager = require(Packages.Packager)

local DefaultFormatter = require(script.Serializer.Default)
local Generators = require(script.Generators)
local SafeNamer = require(script.SafeNamer)

local Sift = require(Packages.Sift)
local Array, Dictionary = Sift.Array, Sift.Dictionary

local Codify = {}

local DEFAULT_FORMATTERS = Dictionary.map(DefaultFormatter, function(formatter)
	return formatter.DEFAULT
end)

export type CodifyConfig = {
	Global: { [string]: any },
	Format: { [string]: string },
	Local: { [string]: any },
}

Codify.__index = Codify

Codify.Dump = nil :: typeof(DumpParser)
Codify.Packager = nil :: typeof(Packager)

function Codify.new(apiDump: any)
	local self = setmetatable({}, Codify)

	self.DumpParser = DumpParser.new(apiDump)
	self.Packager = Packager.new(self.DumpParser)

	return self
end

function Codify:GenerateSnippet(
	rootInstance: Instance,
	generatorId: string,
	config: CodifyConfig
): string
	local generator = assert(Generators[generatorId], `Generator "{generatorId}" does not exist`)
	local package = self.Packager:CreatePackageFlat(rootInstance)
	local variableNames = SafeNamer.SanitizeMultiple(Dictionary.map(package.Tree, function(node)
		return node.Name
	end))

	generator.Packager = self.Packager
	generator.DumpParser = self.DumpParser

	package = self.Packager:ConvertToPackage(package)

	return generator:Generate(package, {
		VariableName = variableNames,
		Global = config.Global or {},
		Format = Dictionary.merge(DEFAULT_FORMATTERS, config.Format),
		Local = generator:ReconcileSettings(config.Local or {}),
	})
end

return Codify
