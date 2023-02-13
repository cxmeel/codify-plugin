--!strict
local Packages = script.Parent.Parent.Parent.Parent.Packages

local DumpParser = require(Packages.DumpParser)
local Packager = require(Packages.Packager)
local Setting = require(script.Setting)

local Generator: Generator = {}

Generator.__index = Generator
Generator.Setting = Setting

export type NewGeneratorMetadata = {
	name: string,
	description: string,
	category: string,
}

export type GenerateConfig = {
	VariableName: { [string]: string },
	Global: { [string]: any },
	Format: { [string]: any },
	Local: { [string]: any },
}

export type Generator = typeof(Generator) & {
	Id: string,
	Name: string,
	Description: string,
	Category: string,

	DumpParser: typeof(DumpParser),
	Packager: typeof(Packager),

	Settings: { [string]: Setting.Setting },

	Generate: (self: Generator, package: Packager.Package, config: GenerateConfig) -> string,
}

function Generator.new(id: string, metadata: NewGeneratorMetadata): Generator
	local self = setmetatable({}, Generator)

	self.Id = id
	self.Name = metadata.name
	self.Description = metadata.description
	self.Category = metadata.category

	self.Settings = {}

	return self
end

function Generator:ReconcileSettings(userSettings: { [string]: any })
	local newSettings: { [string]: any } = {}
	local defaults = self.Settings or {}

	for key, setting in defaults do
		local value = userSettings[key]

		if setting.Validate and not setting.Validate(value, setting) then
			value = setting.Default
		end

		if setting.Type == "enum" then
			value = setting.Options[value or setting.Default].Value
		end

		newSettings[key] = if value ~= nil then value else setting.Default
	end

	return newSettings
end

return Generator
