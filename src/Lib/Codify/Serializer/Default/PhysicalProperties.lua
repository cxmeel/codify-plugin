--!strict
local Common = require(script.Parent.Parent.Common)
local FormatEnum = require(script.Parent.Enum)

export type PhysicalPropertiesFormat = "FULL" | "SMART"

local Formatter: Common.FormatterMap<PhysicalProperties, PhysicalPropertiesFormat> = {}

Formatter.DEFAULT = "SMART"

function Formatter.FULL(value)
	local props = {
		Common.FormatNumber(value.Density),
		Common.FormatNumber(value.Friction),
		Common.FormatNumber(value.Elasticity),
		Common.FormatNumber(value.FrictionWeight),
		Common.FormatNumber(value.ElasticityWeight),
	}

	return `PhysicalProperties.new({table.concat(props, ", ")})`
end

function Formatter.SMART(value, options)
	local propString = tostring(value)

	for material, materialString in Common.PHYSICALPROPERTIES_FROM_MATERIAL do
		if propString == materialString then
			return `PhysicalProperties.new({FormatEnum.FULL(material)})`
		end
	end

	return Formatter.FULL(value, options)
end

return Formatter
