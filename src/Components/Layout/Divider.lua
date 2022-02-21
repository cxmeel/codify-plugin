local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local e = Roact.createElement

export type DividerProps = {
	height: number?,
	colour: Color3?,
	anchor: Vector2?,
	position: UDim2?,
	order: number?,
	zindex: number?,
}

local function Divider(props: DividerProps, hooks)
	local theme = StudioTheme.useTheme(hooks)

	return e("Frame", {
		AnchorPoint = props.anchor,
		BackgroundColor3 = if props.colour then props.colour else theme:GetColor(Enum.StudioStyleGuideColor.Border),
		BorderSizePixel = 0,
		LayoutOrder = props.order,
		Position = props.position,
		Size = UDim2.new(1, 0, 0, props.height or 1),
		ZIndex = props.zindex,
	})
end

return Hooks.new(Roact)(Divider, {
	defaultProps = {
		height = 1,
	},
})
