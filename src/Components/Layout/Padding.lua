local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local StudioTheme = require(Packages.StudioTheme)
local Hooks = require(Packages.Hooks)

local e = Roact.createElement

export type PaddingProps = {
	[number]: number?,
	top: number?,
	right: number?,
	bottom: number?,
	left: number?,
}

local function Padding(props: PaddingProps, hooks)
	local _, styles = StudioTheme.useTheme(hooks)

	local top = props.top or props[1] or styles.spacing
	local right = props.right or props[2] or top
	local bottom = props.bottom or props[3] or top
	local left = props.left or props[4] or right

	return e("UIPadding", {
		PaddingTop = UDim.new(0, top),
		PaddingRight = UDim.new(0, right),
		PaddingBottom = UDim.new(0, bottom),
		PaddingLeft = UDim.new(0, left),
	})
end

return Hooks.new(Roact)(Padding)
