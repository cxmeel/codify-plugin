--!strict
local Packages = script.Parent.Parent.Parent.Parent.Packages

local DumpParser = require(Packages.DumpParser)
local Packager = require(Packages.Packager)

export type Generator = {
	Name: string,
	Language: string,
	Description: string,

	Settings: {
		[string]: {
			Id: string,
			Name: string,
			Description: string,
			Type: "boolean" | "number" | "string" | "enum",
			Default: any,
			Options: {
				[string]: {
					Name: string,
					Description: string,
					Value: any,
				},
			}?,
		},
	}?,

	Generate: (
		package: Packager.Package,
		options: {
			Global: { [string]: any },
			Formats: { [string]: string },
			Local: { [string]: any },
		},
		lib: {
			Dump: typeof(DumpParser.__index),
			Packager: typeof(Packager.__index),

			Variable: { [string]: string },
		}
	) -> string,
}

return true
