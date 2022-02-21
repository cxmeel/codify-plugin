local Packages = script.Parent.Parent.Parent.Packages

local Roact = require(Packages.Roact)
local Hooks = require(Packages.Hooks)
local StudioTheme = require(Packages.StudioTheme)

local Layout = require(script.Parent.Parent.Layout)
local Icon = require(script.Parent.Parent.Icon)

local e = Roact.createElement

export type BaseCheckboxProps = {
	anchor: Vector2?,
	disabled: boolean?,
	pressed: boolean?,
	hovered: boolean?,
	checked: boolean?,
	position: UDim2?,
	order: number?,
}

local function BaseCheckbox(props: BaseCheckboxProps, hooks)
	local theme, styles = StudioTheme.useTheme(hooks)

	local modifier = hooks.useMemo(function()
		if props.disabled then
			return Enum.StudioStyleGuideModifier.Disabled
		elseif props.checked then
			return Enum.StudioStyleGuideModifier.Selected
		elseif props.pressed then
			return Enum.StudioStyleGuideModifier.Pressed
		elseif props.hovered then
			return Enum.StudioStyleGuideModifier.Hover
		end
	end, { props.disabled, props.checked, props.pressed, props.hovered })

	return e("Frame", {
		AnchorPoint = props.anchor,
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBorder, modifier),
		Position = props.position,
		LayoutOrder = props.order,
		Size = UDim2.fromOffset(28, 28),
	}, {
		corners = e(Layout.Corner),
		padding = e(Layout.Padding, { 1 }),

		container = e("Frame", {
			BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBackground, modifier),
			Size = UDim2.fromScale(1, 1),
		}, {
			corners = e(Layout.Corner, {
				radius = styles.borderRadius - 1,
			}),

			indicator = props.checked and e(Icon, {
				icon = "Tick",
				anchor = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				colour = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator, modifier),
			}),
		}),
	})
end

return Hooks.new(Roact)(BaseCheckbox)
