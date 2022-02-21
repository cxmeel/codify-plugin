local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local StudioTheme = require(Packages.StudioTheme)
local Hooks = require(Packages.Hooks)

local e = Roact.createElement

export type ListLayoutProps = {
	gap: number?,
	direction: Enum.FillDirection?,
	alignX: Enum.HorizontalAlignment?,
	alignY: Enum.VerticalAlignment?,
	order: Enum.SortOrder?,
	onSizeChanged: ((UIListLayout) -> ())?,
}

local function ListLayout(props: ListLayoutProps, hooks)
	local _, styles = StudioTheme.useTheme(hooks)

	return e("UIListLayout", {
		Padding = UDim.new(0, props.gap or styles.spacing),
		FillDirection = props.direction,
		HorizontalAlignment = props.alignX,
		SortOrder = props.order,
		VerticalAlignment = props.alignY,

		[Roact.Change.AbsoluteContentSize] = props.onSizeChanged,
	})
end

return Hooks.new(Roact)(ListLayout, {
	defaultProps = {
		direction = Enum.FillDirection.Horizontal,
		order = Enum.SortOrder.LayoutOrder,
		alignX = Enum.HorizontalAlignment.Left,
		alignY = Enum.VerticalAlignment.Top,
	},
})
