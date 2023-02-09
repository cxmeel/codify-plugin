--!strict
local Sift = require(script.Parent.Parent.Parent.Parent.Parent.Sift)
local Common = require(script.Parent.Parent.Parent.Parent.Common)

local Array = Sift.Array

export type CFrameFormat = "FULL" | "SMART"

local Formatter: Common.FormatterMap<CFrame, CFrameFormat> = {}

local function isIdentity(value: CFrame)
	return Array.every({ value:GetComponents() }, function(component)
		return component == 0
	end)
end

function Formatter.FULL(value)
	if isIdentity(value) then
		return "new CFrame()"
	end

	local components = Array.map({ value:GetComponents() }, Common.FormatNumber)
	return `new CFrame({table.concat(components, ", ")})`
end

function Formatter.SMART(value)
	local x = value.Position.X
	local y = value.Position.Y
	local z = value.Position.Z

	if isIdentity(value) then
		return "new CFrame()"
	end

	local positionless = x == 0 and y == 0 and z == 0

	x = Common.FormatNumber(x)
	y = Common.FormatNumber(y)
	z = Common.FormatNumber(z)

	if value.LookVector == -Vector3.zAxis then
		return positionless and "new CFrame()" or `new CFrame({x}, {y}, {z})`
	end

	local rotation = table.concat(Array.map({ value:ToEulerAnglesXYZ() }, Common.FormatNumber), ", ")

	if positionless then
		return `CFrame.Angles({rotation})`
	end

	return `new CFrame({x}, {y}, {z}) * CFrame.Angles({rotation})`
end

return Formatter
