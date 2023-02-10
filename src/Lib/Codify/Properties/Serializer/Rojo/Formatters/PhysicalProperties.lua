--!strict
local Common = require(script.Parent.Parent.Parent.Parent.Common)

export type PhysicalPropertiesFormat = "EXPLICIT"

local Formatter: Common.FormatterMap<PhysicalProperties, PhysicalPropertiesFormat> = {}

function Formatter.EXPLICIT(value)
	return {
		PhysicalProperties = {
			density = value.Density,
			friction = value.Friction,
			elasticity = value.Elasticity,
			frictionWeight = value.FrictionWeight,
			elasticityWeight = value.ElasticityWeight,
		},
	}
end

return Formatter