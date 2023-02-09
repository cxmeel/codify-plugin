--!strict
local Common = require(script.Parent.Parent.Parent.Common)

return {
	Axes = require(script.NormalId),
	BrickColor = require(script.BrickColor),
	CFrame = require(script.CFrame),
	Color3 = require(script.Color3),
	ColorSequence = require(script.ColorSequence),
	Enum = require(script.Enum),
	Faces = require(script.NormalId),
	Font = require(script.Font),
	NumberRange = require(script.NumberRange),
	NumberSequence = require(script.NumberSequence),
	PhysicalProperties = require(script.PhysicalProperties),
	Rect = require(script.Rect),
	UDim = require(script.UDim),
	UDim2 = require(script.UDim2),
	Vector2 = require(script.Vector2),
	Vector2int16 = require(script.Vector2int16),
	Vector3 = require(script.Vector3),
	Vector3int16 = require(script.Vector3int16),

	number = function(value)
		return Common.FormatNumber(value)
	end,

	string = function(value)
		return `"{value}"`
	end,
}
