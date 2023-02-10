--!strict
local Packages = script.Parent.Parent.Packages

local DumpParser = require(Packages.DumpParser)
local Packager = require(Packages.Packager)

local GT = require(script.Generators["init.d"])
local Generators = require(script.Generators)
local SafeNamer = require(script.SafeNamer)

local Sift = require(Packages.Sift)
local Dictionary = Sift.Dictionary

local Codify = {}

Codify.__index = Codify

function Codify.new(apiDump: any)
	local self = setmetatable({}, Codify)

	self.Dump = DumpParser.new(apiDump)
	self.Packager = Packager.new(self.dump)

	return self
end

function Codify:GetGenerators()
	return Generators
end

function Codify:GetGeneratorDefaultOptions(generator: GT.Generator)
	local options = {}

	if generator.Settings ~= nil then
		for id, setting in generator.Settings do
			options[id] = setting.Default
		end
	end

	return options
end

function Codify:GetDefaultFormatters(generator: GT.Generator)
	local formatters = {}

	for dataType, formatter in generator.Formatter do
		formatters[dataType] = formatter.DEFAULT
	end

	return formatters
end

function Codify:GenerateSnippet(
	rootInstance: Instance,
	generatorId: string,
	options: {
		Global: { [string]: any },
		Formats: { [string]: string },
		Local: { [string]: any },
	}
)
	-- Step 4: Generate code (pass to generator)
	--   Step 4.1: Create root Instance
	--   Step 4.2: Serialise and assign properties
	--   Step 4.3: Assign attributes (if enabled)
	--   Step 4.4: Assign tags (if enabled)
	--   Step 4.5: Repeat for children
	--   Step 4.6: Assign Parent property
	local generator = assert(Generators[generatorId], `Generator "{generatorId}" does not exist`)
	local generatorOptions = Dictionary.merge(self:GetGeneratorDefaultOptions(generator), options.Local)
	local formatters = Dictionary.merge(self:GetDefaultFormatters(generator), options.Formats)

	local package = self.Packager:CreatePackageFlat(rootInstance)
	local variableNames = {}

	for ref, node in package.Tree do
		variableNames[ref] = SafeNamer.Sanitize(node.Name)
	end

	package = self.Packager:ConvertToPackage(package)

	return generator.Generate(package, {
		Global = options.Global,
		Formats = formatters,
		Local = generatorOptions,
	}, {
		Dump = self.Dump,
		Packager = self.Packager,
		Variable = variableNames,
	})
end

return Codify
